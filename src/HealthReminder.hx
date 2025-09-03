package;

import datetime.DateTime;
import reminders.*;

using api.IdeckiaApi;

enum abstract ReminderType(String) from String to String {
	var hydrate;
	var relax_vision;
	var stretch;
}

typedef Props = {
	@:editable("prop_interval", 30)
	var interval:UInt;
	@:editable("prop_cron_expression")
	var cron_expression:String;
	@:editable("prop_remider_type", hydrate, [hydrate, relax_vision, stretch, null])
	var reminder_type:ReminderType;
}

@:name("health-reminder")
@:description("action_description")
@:localize("loc")
class HealthReminder extends IdeckiaAction {
	var timer:haxe.Timer;
	var minutes:UInt;
	var reminder:IReminder;
	var reminderDialogPath:String;
	var cron:Cron;
	var nextDate:DateTime;
	var prevDate:DateTime;

	static public var DIALOG_CONTENT:String = Data.embedContent('./reminders/res/dialog_tpl.json');

	override public function init(initialState:ItemState):js.lib.Promise<ItemState> {
		switch props.reminder_type {
			case hydrate:
				reminder = new HydrateReminder();
				reminderDialogPath = reminder.createDialog(Loc.drink_dialog_title.tr(), Loc.drink_dialog_body.tr());
			case relax_vision:
				reminder = new RelaxVisionReminder();
				reminderDialogPath = reminder.createDialog(Loc.relax_vision_dialog_title.tr(), Loc.relax_vision_dialog_body.tr());
			case stretch:
				reminder = new StretchReminder();
				reminderDialogPath = reminder.createDialog(Loc.stretch_dialog_title.tr(), Loc.stretch_dialog_body.tr());
		}

		minutes = 0;

		initialState.textPosition = TextPosition.top;

		if (props.cron_expression != null && props.cron_expression != '') {
			try {
				cron = CronSchedule.parseCronExpression(props.cron_expression);
				prevDate = localizeCronDate(cron.getPrevDate());
				nextDate = localizeCronDate(cron.getNextDate());
			} catch (e:haxe.Exception) {
				core.dialog.error('Cron parsing error', e.message);
			}
		}

		checkReminder(initialState);

		var secDiffToRound = 60 - DateTime.now().getSecond();

		haxe.Timer.delay(() -> {
			timer = new haxe.Timer(60 * 1000);
			timer.run = () -> {
				checkReminder(initialState);
				core.updateClientState(initialState);
			};
		}, secDiffToRound);

		return super.init(initialState);
	}

	override public function deinit():Void {
		if (timer != null) {
			timer.stop();
			timer = null;
		}
	}

	function checkReminder(state:ItemState) {
		var diffProportion = 1.;
		var bgColor = null;
		var text = '';

		if (cron == null) {
			minutes++;

			text = '${props.interval - minutes}';

			if (minutes == props.interval) {
				core.dialog.custom(reminderDialogPath);
				minutes = 0;
				bgColor = 'ffcc0000';
			} else {
				diffProportion = minutes / props.interval;
			}
		} else {
			var localNow = DateTime.local();

			var currentDiff = (nextDate - localNow).getTotalMinutes();
			var totalDiff = (nextDate - prevDate).getTotalMinutes();
			text = '${currentDiff}';
			diffProportion = currentDiff / totalDiff;

			if (localNow > nextDate) {
				bgColor = 'ffcc0000';
				core.dialog.custom(reminderDialogPath);
				prevDate = nextDate;
				nextDate = localizeCronDate(cron.getNextDate());
				core.log.info('Next health reminder in $nextDate');
			}
		}

		state.bgColor = bgColor;
		state.icon = reminder.getSvgData(1 - diffProportion);
		state.text = text + ' min.';

		return state;
	}

	override function onLongPress(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		minutes = 0;
		currentState.bgColor = null;
		currentState.icon = reminder.getSvgData(0);
		currentState.text = '${props.interval} min.';
		return super.onLongPress(currentState);
	}

	inline function localizeCronDate(date:Date) {
		return DateTime.fromDate(date).getTime() + DateTime.getLocalOffset();
	}

	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		checkReminder(currentState);
		return js.lib.Promise.resolve(new ActionOutcome({state: currentState}));
	}
}

@:jsRequire('cron-schedule')
extern class CronSchedule {
	static function parseCronExpression(expression:String):Cron;
}

extern class Cron {
	function getNextDate(?startDate:Date):Date;
	function getPrevDate(?startDate:Date):Date;
}
