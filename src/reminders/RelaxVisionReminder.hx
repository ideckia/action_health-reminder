package reminders;

using StringTools;
using api.IdeckiaApi;

class RelaxVisionReminder implements IReminder {
	var dialogPath:String;

	static inline var EYE_MAX_FILL = 50;
	static inline var EYE_FILL_TPL_NAME = '::eye_openness::';
	static var ICON_SVG_DATA = Data.embedContent('./res/eye_tpl.svg');

	public function new() {}

	public function createDialog(title:String, body:String) {
		dialogPath = haxe.io.Path.join([js.Node.__dirname, '__vision.json']);
		var imagePath = haxe.io.Path.join([js.Node.__dirname, '__eye.svg']);

		var content = HealthReminder.DIALOG_CONTENT.replace('::title::', title);
		content = content.replace('::label_text::', body);
		content = content.replace('::image_path::', 'file://$imagePath');

		sys.io.File.saveContent(imagePath, ICON_SVG_DATA.replace(EYE_FILL_TPL_NAME, '5'));
		sys.io.File.saveContent(dialogPath, content);

		return dialogPath;
	}

	public inline function getSvgData(scale:Float) {
		final value = 5 + EYE_MAX_FILL * scale;
		return ICON_SVG_DATA.replace(EYE_FILL_TPL_NAME, '${value}');
	}
}
