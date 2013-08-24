package events
{
	import flash.events.Event;
	public class ChangeSizeEvent extends Event
	{
		public static const CHANGE_SIZE_EVENT:String = "ChangeSizeEvent";
		
		public var heightChanged:int;
		
		public function ChangeSizeEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}			