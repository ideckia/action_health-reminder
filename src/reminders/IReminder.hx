package reminders;

import api.IdeckiaApi.IdeckiaCore;

interface IReminder {
	public function createDialog(title:String, body:String):String;
	public function getSvgData(scale:Float):String;
}
