package events
{
	import flash.events.Event;
	public class ErepublikDataProviderEvent extends Event
	{
		public static const EDP_EVENT:String = "erepublikDataProviderEvent";
		
		public var data:String;
		
		public function  ErepublikDataProviderEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}