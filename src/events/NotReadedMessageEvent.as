package events
{
	import flash.events.Event;
	
	import lib.MyMessage;

	public class NotReadedMessageEvent extends Event
	{
		public static const NOT_READED_MESSAGE_EVENT:String = "NotReadedMessageEvent";
		public var n_r_m_count:int;
		
		public function NotReadedMessageEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}			