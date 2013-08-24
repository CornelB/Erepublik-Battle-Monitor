package lib
{
	public class MyMessage
	{
		
		public var text:String='';
		public var type:String='';
		public var sender:String='';
		public var user:String='';
		public var random:Number;
		public var color:int;
		
		public function MyMessage(user:String, type:String, text:String, sender:String='no sender', color:int=0)
		{
			this.text = text;
			this.type = type;
			this.user = user;
			this.sender = sender;
			this.color = color;
			this.random = Math.random();
		}
		
	}
}