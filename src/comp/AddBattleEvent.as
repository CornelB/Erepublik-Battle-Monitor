package comp
{
	import flash.events.Event;
	public class AddBattleEvent extends Event
	{
		public static const ADD_BATTLE_EVENT:String = "AddBattleEvent";
		
		public var wybraneID:int;
		
		public function AddBattleEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}