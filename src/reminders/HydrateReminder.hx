package reminders;

using StringTools;
using api.IdeckiaApi;

class HydrateReminder implements IReminder {
	var dialogPath:String;

	static inline var WATER_MAX_FILL = 70;
	static inline var WATER_FILL_TPL_NAME = '::water_missing::';
	static var ICON_SVG_DATA = Data.embedContent('./res/glass_tpl.svg');

	public function new() {}

	public function createDialog(title:String, body:String) {
		dialogPath = haxe.io.Path.join([js.Node.__dirname, '__hydrate.json']);
		var imagePath = haxe.io.Path.join([js.Node.__dirname, '__glass.svg']);

		var content = HealthReminder.DIALOG_CONTENT.replace('::title::', title);
		content = content.replace('::label_text::', body);
		content = content.replace('::image_path::', 'file://$imagePath');

		sys.io.File.saveContent(imagePath, ICON_SVG_DATA);
		sys.io.File.saveContent(dialogPath, content);

		return dialogPath;
	}

	public inline function getSvgData(scale:Float) {
		return ICON_SVG_DATA.replace(WATER_FILL_TPL_NAME, '${WATER_MAX_FILL * scale}');
	}
}
