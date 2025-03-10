package;

import api.data.Data;

using StringTools;

class Water {
	static var SVG_DATA = Data.embedContent('./glass_tpl.svg');
	static inline var UP_Y = 10;
	static inline var DOWN_Y = 75;
	static inline var UP_X_LEFT = 10;
	static inline var DOWN_X_LEFT = 30;
	static inline var UP_X_RIGHT = 80;
	static inline var DOWN_X_RIGHT = 60;

	public function new() {}

	public function getWaterSvg(scale:Float) {
		var xDiff = DOWN_X_LEFT - UP_X_LEFT;
		var yDiff = DOWN_Y - UP_Y;

		var upY = UP_Y + Math.round(yDiff * scale);
		var downY = DOWN_Y;
		var upXLeft = UP_X_LEFT + Math.round(xDiff * scale);
		var downXLeft = DOWN_X_LEFT;
		var upXRight = UP_X_RIGHT - Math.round(xDiff * scale);
		var downXRight = DOWN_X_RIGHT;

		var d = 'M$upXLeft $upY L$downXLeft $downY L$downXRight $downY L$upXRight $upY Z';

		return SVG_DATA.replace('::water_fill::', d);
	}
}
