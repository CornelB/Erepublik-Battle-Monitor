package events
{
	import flash.events.Event;
	public class ChangeRefreshEvent extends Event
	{
		public static const MY_CUSTOM_EVENT:String = "myCustomEvent";
		
		public var wybor:String;
		
		public function ChangeRefreshEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}