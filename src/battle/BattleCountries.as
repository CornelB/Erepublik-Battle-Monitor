package battle
{
	import events.ReadApiEvent;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.Float;
	
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
		private var bv:BattleVars;
		
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
		
		public function showOrders(oData:Object, battleVars:BattleVars):void {
			this.bv = battleVars;
			this.bv.attOrders = new Array();
			this.bv.defOrders = new Array();
			
			for(var i:int = 0; i<oData.length; i++){
				if(oData[i]["side_country_id"] == this.bv.attackerID){
					this.bv.attOrders.push(oData[i]);
				} else {
					bv.defOrders.push(oData[i]);
				}
			}
			
			if(bv.attOrders.length == 0){
				this.hideOrders(true, bv);
			} else {
				if(bv.attOrders[bv.attOrdersCurr] != undefined){
					this.showOrder(bv.attOrders[bv.attOrdersCurr], true);
				} else {
					bv.attOrdersCurr = 0;
					this.showOrder(bv.attOrders[0], true);
				}
			}
			
			if(bv.defOrders.length == 0){
				this.hideOrders(false, bv);
			} else {
				if(bv.defOrders[bv.defOrdersCurr] != undefined){
					this.showOrder(bv.defOrders[bv.defOrdersCurr], false);
				} else {
					bv.defOrdersCurr = 0;
					this.showOrder(bv.defOrders[0], false);
				}
			}
		}
		
		protected function showOrder(oData:Object, bIsAttacker:Boolean):void{
			var text:String =  oData["threshold"] + "% " + oData["reward"] + "/" + int(oData["budget"]);
			var pc:Number;
			if(bIsAttacker){
				this.lblAttack.text = text;
				this.lblAttack.toolTip="threshold% reward/budget";
				pc = Math.round((100-bv.defenderPercent[int(oData["division"])-1])*100)/100;

				if(pc < int(oData["threshold"])){
					this.lblAttack.setStyle("color","0x005500");
				} else {
					this.lblAttack.setStyle("color","0xdd3000");
				}
				if(bv.attOrders.length > 1) {
					this.lblAttack.addEventListener(MouseEvent.CLICK,nextAttacker);
					this.lblAttack.buttonMode = true;
				}
			} else {
				this.lblDefend.text = text;
				this.lblDefend.toolTip="threshold% reward/budget";
				pc = Math.round((bv.defenderPercent[int(oData["division"])-1])*100)/100;
				if(pc < int(oData["threshold"])){
					this.lblDefend.setStyle("color","0x005500");
				} else {
					this.lblDefend.setStyle("color","0xdd3000");
				}
				if(bv.defOrders.length > 1) {
					this.lblDefend.addEventListener(MouseEvent.CLICK,nextDeffender);
					this.lblDefend.buttonMode = true;
				}
			}
			
		}
		
		private function nextAttacker(e:MouseEvent):void{
			this.bv.attOrdersCurr++;
			this.bv.licznikOdswierzen = 0;
		}
		private function nextDeffender(e:MouseEvent):void{
			this.bv.defOrdersCurr++;
			this.bv.licznikOdswierzen = 0;
		}
		
		public function hideOrders(bIsAttacker:Boolean, battleVars:BattleVars):void{
			if(bIsAttacker){
				this.lblAttack.text = sf.skroc(battleVars.attacker,11);
				this.lblAttack.setStyle("color","0x000000");
				this.lblAttack.removeEventListener(MouseEvent.CLICK,nextAttacker);
				this.lblAttack.buttonMode = false;
			} else {
				this.lblDefend.text = sf.skroc(battleVars.defender,11);
				this.lblDefend.setStyle("color","0x000000");
				this.lblDefend.removeEventListener(MouseEvent.CLICK,nextDeffender);
				this.lblDefend.buttonMode = false;
			}
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
				this.messageImage.visible = true;
				this.lblMessage.visible = true;
				
				
				this.addChild(messageImage);
				this.addChild(lblMessage);

			}
			else
			{
				warningTimer.stop();
				lblMessage.text=shortMessage;
				lblMessage.toolTip=message;
				
			}
			
			if(shortMessage == "Check domi")
			{
				trace('Check domin');
				lblMessage.addEventListener(MouseEvent.CLICK,read_api_again);
				lblMessage.buttonMode = true;
				
				this.attackerImg.buttonMode = true;
				this.attackerImg.addEventListener(MouseEvent.CLICK,attackerImgClick);
				this.attackerImg.toolTip = 'Hide warning';

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
			this.messageImage.visible = false;
			this.lblMessage.visible = false;
			var read_api_Event:ReadApiEvent = new ReadApiEvent(ReadApiEvent.READ_API_EVENT);
			dispatchEvent(read_api_Event);
		}
		
		public function hideWarning(param1:TimerEvent = null):void
		{
			try{
			this.removeChild(messageImage);
			this.removeChild(lblMessage);
			warningTimer.stop();
			}catch(e:Error)
			{
			
			}
			if(attackerImg.hasEventListener(MouseEvent.CLICK))
			{
				attackerImg.buttonMode = false;
				attackerImg.toolTip='';
				attackerImg.removeEventListener(MouseEvent.CLICK,attackerImgClick);
			}
		}
		
		private function attackerImgClick(e:MouseEvent):void
		{
			try{
				this.removeChild(messageImage);
				this.removeChild(lblMessage);
			}catch(e:Error)
			{
				
			}
			if(attackerImg.hasEventListener(MouseEvent.CLICK))
			{
				attackerImg.buttonMode = false;
				attackerImg.toolTip='';
				attackerImg.removeEventListener(MouseEvent.CLICK,attackerImgClick);
			}
		}
		


	}
}