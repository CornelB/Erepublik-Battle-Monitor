package stratus
{
	import flash.events.Event;
	
	public class StratusConnectedEvent extends Event
	{
		public static const STATUS_CONNECTED_EVENT:String = "StrausConnectedEvent";
		
		public var nb_of_users:int = 0;
		
		public function StratusConnectedEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}			