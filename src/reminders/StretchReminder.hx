package reminders;

using StringTools;
using api.IdeckiaApi;

class StretchReminder implements IReminder {
	var dialogPath:String;

	static inline var MUSCLE_MAX_FILL = 30;
	static inline var MUSCLE_FILL_TPL_NAME = '::muscle::';
	static var ICON_SVG_DATA = Data.embedContent('./res/muscle_tpl.svg');

	public function new() {}

	public function createDialog(title:String, body:String) {
		dialogPath = haxe.io.Path.join([js.Node.__dirname, '__stretch.json']);
		var imagePath = haxe.io.Path.join([js.Node.__dirname, '__muscle.svg']);

		var content = HealthReminder.DIALOG_CONTENT.replace('::title::', title);
		content = content.replace('::label_text::', body);
		content = content.replace('::image_path::', 'file://$imagePath');

		sys.io.File.saveContent(imagePath, ICON_SVG_DATA.replace(MUSCLE_FILL_TPL_NAME, '20'));
		sys.io.File.saveContent(dialogPath, content);

		return dialogPath;
	}

	public inline function getSvgData(scale:Float) {
		final value = 20 + MUSCLE_MAX_FILL * scale;
		return ICON_SVG_DATA.replace(MUSCLE_FILL_TPL_NAME, '${value}');
	}
}
