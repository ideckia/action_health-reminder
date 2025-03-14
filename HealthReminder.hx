package;

using api.IdeckiaApi;

typedef Props = {
	@:editable("prop_interval", 30)
	var interval:UInt;
}

@:name("health-reminder")
@:description("action_description")
@:localize("loc")
class HealthReminder extends IdeckiaAction {
	var timer:haxe.Timer;
	var minutes:UInt;
	var water:Water;
	var state:ItemState;
	var showDefaultText:Bool = false;

	override public function init(initialState:ItemState):js.lib.Promise<ItemState> {
		water = new Water();
		timer = new haxe.Timer(60 * 1000);
		timer.run = updateReminder;
		minutes = 0;

		state = initialState;
		if (state.text == null || state.text == '') {
			state.textPosition = TextPosition.center;
			state.text = '${props.interval}';
			showDefaultText = true;
		}
		state.icon = water.getWaterSvg(0.);

		return super.init(state);
	}

	override public function deinit():Void {
		if (timer != null) {
			timer.stop();
			timer = null;
		}
	}

	function updateReminder() {
		minutes++;

		if (showDefaultText)
			state.text = '${props.interval - minutes}';

		if (minutes == props.interval) {
			core.dialog.info(Loc.drink_dialog_title.tr(), Loc.drink_dialog_body.tr(minutes));
			minutes = 0;
			state.icon = water.getWaterSvg(1.);
			state.bgColor = 'ffcc0000';
		} else {
			state.bgColor = null;
			state.icon = water.getWaterSvg(minutes / props.interval);
		}

		core.updateClientState(state);
	}

	override function onLongPress(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		minutes = 0;
		state.bgColor = null;
		state.icon = water.getWaterSvg(0);
		state.text = '${props.interval}';
		return super.onLongPress(state);
	}

	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome>
		return js.lib.Promise.resolve(new ActionOutcome({state: currentState}));
}
