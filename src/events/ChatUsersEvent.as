package events
{
	import flash.events.Event;
	public class ChatUsersEvent extends Event
	{
		public static const CHAT_USERS_EVENT:String = "ChatUsersEvent";
		
		public var numer_of_users:int;
		
		public function ChatUsersEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}			