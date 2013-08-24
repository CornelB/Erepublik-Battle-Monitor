package battle
{
	import events.ReadApiEvent;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	
	import spark.components.Label;

	public class BattleCountries extends Canvas
	{

		
		private var lblAttack:Label;
		private var lblDefend:Label;
		public var attackerImg:Image;
		public var defenderImg:Image;

		private var lblMessage:Label;
		private var warningTimer:Timer=new Timer(8000);
		
		[Embed(source='img/clock.png')] 
		private var clockImageClass:Class; 
		
		[Embed(source='img/showHeros.png')] 
		public var showHerosImageClass:Class; 
		
		[Embed(source='img/hideHeros.png')] 
		public var hideHerosImageClass:Class; 
		
		public var clockImage:Image;  //listener is adding
		public var showHideHerosImage:Image;  //listener is adding
		
		[Embed(source='img/attackTot.png')] 
		private var attackTotImageClass:Class; 
		private var attackTotImage:Image;		
		 
		[Embed(source='img/defendTot.png')] 
		private var defendTotImageClass:Class; 
		private var defendTotImage:Image;
		
		[Embed(source='img/warning.png')] 
		private var warningImageClass:Class; 
		
		[Embed(source='img/ok.png')] 
		private var okImageClass:Class; 
		
		private var messageImage:Image;
		 
		
		public var lblAttackTot:Label;
		public var lblDefendTot:Label;
		
		public var lblTime:Label;
		private var sf:ShareFunctions=new ShareFunctions();
		
		public function BattleCountries()
		{

			this.percentWidth=100;
			this.verticalScrollPolicy="off";
			this.horizontalScrollPolicy="off";
			
			attackerImg = new Image();
			attackerImg.x=2;
			attackerImg.y=0;
			this.addChildAt(attackerImg,0);
			
			defenderImg = new Image();
			defenderImg.right=2;
			defenderImg.y=0;
			this.addChildAt(defenderImg,0);
			
			
			lblAttack = new Label();
			lblAttack.text='attacker';
			lblAttack.x=2;
			lblAttack.y=18;
			this.addChildAt(lblAttack,1);
			
			lblDefend = new Label();
			lblDefend.text='defender';
			lblDefend.right=2;
			lblDefend.y=18;
			this.addChildAt(lblDefend,1);
			

			clockImage = new Image();
			clockImage.horizontalCenter=4;
			clockImage.y=0;
			clockImage.source=clockImageClass;
			this.addChildAt(clockImage,0);
					
			lblTime=new Label();
			lblTime.text='0:00:00';
			lblTime.toolTip="Show/Hide Battle Heros";
		    lblTime.setStyle("color","0xffffff");
			lblTime.horizontalCenter=11;
			lblTime.y=4;
			lblTime.name='lblTime';
			this.addChildAt(lblTime,1);
			
			showHideHerosImage = new Image();
			showHideHerosImage.horizontalCenter=6;
			showHideHerosImage.y=20;
			showHideHerosImage.toolTip="Show/Hide Battle Heros";
			showHideHerosImage.source=this.showHerosImageClass;
			this.addChildAt(showHideHerosImage,0);

			attackTotImage = new Image();
			attackTotImage.y=28;
			attackTotImage.x=0;
			attackTotImage.height=20;
			attackTotImage.source=attackTotImageClass;
			this.addChildAt(attackTotImage,0);
			
			lblAttackTot = new Label();
			lblAttackTot.text='tot';
			lblAttackTot.setStyle("color","0xffffff");
			lblAttackTot.x=10;
			lblAttackTot.y=34;
			this.addChildAt(lblAttackTot,1);
			
			defendTotImage = new Image();
			defendTotImage.y=28;
			defendTotImage.right=-10;
			defendTotImage.height=20;
			defendTotImage.source=defendTotImageClass;
			this.addChildAt(defendTotImage,0);
			
			lblDefendTot = new Label();
			lblDefendTot.text='tot';
			lblDefendTot.setStyle("color","0xffffff");
			lblDefendTot.right=11;
			lblDefendTot.y=34;
			this.addChildAt(lblDefendTot,1);
			
			
		}
		
		public function updateData(battleVars:BattleVars):void
		{

			this.lblAttack.text = sf.skroc(battleVars.attacker,11);
			this.lblDefend.text = sf.skroc(battleVars.defender,11);
			
			this.attackerImg.source = "flags/" + (sf.spaceChange(battleVars.attacker)) + ".gif";
			this.defenderImg.source = "flags/" + (sf.spaceChange(battleVars.defender)) + ".gif";
		

		}
		
		public function showMessage(shortMessage:String,message:String,type:String):void
		{
			if(!warningTimer.running)
			{
				messageImage=new Image();
				
				
				messageImage.x=42;
				messageImage.y=29;
				messageImage.width=16;
				messageImage.height=16;
				messageImage.toolTip=message;
				
				
				lblMessage=new Label();
				lblMessage.text=shortMessage;
				lblMessage.toolTip=message;
				lblMessage.y=33;
				lblMessage.x=59;
				
				if(type=="warning")
				{
					messageImage.source=warningImageClass;
					lblMessage.setStyle("color","0xdd3000");
				}
				else
				{
					messageImage.source=okImageClass;
					lblMessage.setStyle("color","0x006600");
				
				}
				
				
				
				this.addChild(messageImage);
				this.addChild(lblMessage);

			}
			else
			{
				warningTimer.stop();
				lblMessage.text=shortMessage;
				lblMessage.toolTip=message;
				
			}
			
			if(shortMessage == "Check domin")
			{
				lblMessage.addEventListener(MouseEvent.CLICK,read_api_again);
				lblMessage.buttonMode = true;
				warningTimer = new Timer(15000);
				warningTimer.addEventListener(TimerEvent.TIMER, hideWarning);
				
				warningTimer.start();
			}
			else
			{
				warningTimer = new Timer(8000);
				warningTimer.addEventListener(TimerEvent.TIMER, hideWarning);
				warningTimer.start();
				lblMessage.buttonMode = false;
			}
		}
		
		private function read_api_again(e:MouseEvent):void
		{
			this.removeChild(messageImage);
			this.removeChild(lblMessage);
			var read_api_Event:ReadApiEvent = new ReadApiEvent(ReadApiEvent.READ_API_EVENT);
			dispatchEvent(read_api_Event);
		}
		
		private function hideWarning(param1:TimerEvent):void
		{
			this.removeChild(messageImage);
			this.removeChild(lblMessage);
			warningTimer.stop();
			
		}
		


	}
}