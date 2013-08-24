package battle
{
	import mx.containers.Canvas;
	import flash.events.MouseEvent;
	import spark.components.Label;

	public class BattleHeader extends Canvas
	{
		
		public var lblBattle:Label;
		public var lblRefresh:Label;
		
		public function BattleHeader()
		{
			this.height=16;
			this.percentWidth=100;
			
		
			lblBattle = new Label();
			lblBattle.text='';
			lblBattle.x=0;
			lblBattle.y=3;
			lblBattle.height=24;
			lblBattle.name="lblBattle";
			lblBattle.addEventListener(MouseEvent.MOUSE_OVER,labelMouseOver);
			lblBattle.addEventListener(MouseEvent.MOUSE_OUT,labelMouseOut);
			this.addChildAt(lblBattle,0);
			
			lblRefresh = new Label();
			lblRefresh.text='';
			lblRefresh.right=3;
			lblRefresh.y=3;
			lblRefresh.name="lblRefresh";
			this.addChildAt(lblRefresh,0);
			
		}
		
		private function labelMouseOver(event:MouseEvent):void
		{
			event.target.setStyle("color","#800000");
			return;
		}
		
		private function labelMouseOut(event:MouseEvent):void
		{
			event.target.setStyle("color","#000000");
			return;
		}
		

	}
}