package stratus
{
	import flash.events.Event;
	
	import lib.MyMessage;

	public class NewMessageEvent extends Event
	{
		public static const NEW_MESSAGE_EVENT:String = "NewMessageEvent";
		public var msg:MyMessage;
		
		public function NewMessageEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}			