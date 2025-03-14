package;

import api.data.Data;

using StringTools;

class Water {
	static inline var WATER_MAX_FILL = 70;
	static inline var WATER_FILL_TPL_NAME = '::water_missing::';
	static var ICON_SVG_DATA = Data.embedContent('./glass_tpl.svg');

	public function new() {}

	public inline function getWaterSvg(scale:Float) {
		return ICON_SVG_DATA.replace(WATER_FILL_TPL_NAME, '${WATER_MAX_FILL * scale}');
	}
}
