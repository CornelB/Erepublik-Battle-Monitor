package battle
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.events.CloseEvent;
	
	public class BattleButtons extends Canvas
	{
		
		[Embed(source='img/close16.png')] 
		private var close_image:Class; 
		
		[Embed(source='img/stats16.png')] 
		private var stats_image:Class; 
		
		[Embed(source='img/gotoapp16.png')] 
		private var gotoapp_image:Class; 
		
		[Embed(source='img/refresh.png')]
		private var refresh_image:Class
		
		
		private var battleID:int;
		public var openUpdateImg:Image; //listener jest w battle.as
		
		public function BattleButtons(battleID:int)
		{
			

			this.battleID=battleID;

			var closeImg:Image = new Image();
			closeImg.toolTip="Close";
			closeImg.source=close_image;
			closeImg.buttonMode=true;
			closeImg.right=2;
			closeImg.y=30;
			closeImg.addEventListener(MouseEvent.CLICK, this.battleClose);
			this.addChildAt(closeImg,0);
	 		
			openUpdateImg= new Image();
			openUpdateImg.toolTip="Change update frequency";
			openUpdateImg.source=stats_image;
			openUpdateImg.buttonMode=true;
			openUpdateImg.right=2;
			openUpdateImg.y=0;
			openUpdateImg.name="openUpdate";
		
		 	this.addChildAt(openUpdateImg,0);
			 
			var openBattleImg:Image = new Image();
			openBattleImg.toolTip="Go to battle";
			openBattleImg.source=gotoapp_image;
			openBattleImg.buttonMode=true;
			openBattleImg.right=2;
			openBattleImg.y=15;
		 	openBattleImg.addEventListener(MouseEvent.CLICK, this.jumpToBattle);
			this.addChildAt(openBattleImg,0);
			
			
		}
		private function battleClose(param1:Event):void
		{

			dispatchEvent(new CloseEvent(Event.CLOSE));
			return;
		}// end function
		
		public function jumpToBattle(param1:Event):void
		{
			
			navigateToURL(new URLRequest("http://www.erepublik.com/en/military/battlefield/" + this.battleID));
			return;
		}// end function	

		
	}
}