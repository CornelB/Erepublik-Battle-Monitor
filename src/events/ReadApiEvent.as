package events
{
	import flash.events.Event;
	
	import lib.MyMessage;

	public class ReadApiEvent extends Event
	{
		public static const READ_API_EVENT:String = "RaeadApiEvent";
		
		public function ReadApiEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}			