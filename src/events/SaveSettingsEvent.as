package events
{
	import comp.SettingsVars;
	
	import flash.events.Event;

	public class SaveSettingsEvent extends Event
	{
		public static const SAVE_SETTINGS_EVENT:String = "SaveSettingsEvent";
		
		public var sv:SettingsVars;
		public function SaveSettingsEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}			