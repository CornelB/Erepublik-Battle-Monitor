package battle
{
	import events.ReadApiEvent;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.Float;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.utils.ObjectUtil;
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

		public var lblAttackBO:Label;
		public var lblDefendBO:Label;
		
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
			
			lblAttackBO = new Label();
			lblAttackBO.text='1/1';
			lblAttackBO.x=27;
			lblAttackBO.y=4;
			lblAttackBO.visible=false;
			this.addChildAt(lblAttackBO,1);
			
			lblDefendBO = new Label();
			lblDefendBO.text='1/1';
			lblDefendBO.right=27;
			lblDefendBO.y=4;
			lblDefendBO.visible=false;
			this.addChildAt(lblDefendBO,1);

			clockImage = new Image();
			clockImage.horizontalCenter=0;
			clockImage.y=0;
			clockImage.source=clockImageClass;
			this.addChildAt(clockImage,0);
					
			lblTime=new Label();
			lblTime.text='0:00:00';
			lblTime.toolTip="Show/Hide Battle Heros";
		    lblTime.setStyle("color","0xffffff");
			lblTime.horizontalCenter=9;
			lblTime.y=4;
			lblTime.name='lblTime';
			this.addChildAt(lblTime,1);
			
			showHideHerosImage = new Image();
			showHideHerosImage.horizontalCenter=6;
			showHideHerosImage.y=34;
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
			if(battleVars.attacker!='' && battleVars.defender!=''){
				this.lblAttack.text = sf.skroc(battleVars.attacker,11);
				this.lblDefend.text = sf.skroc(battleVars.defender,11);
				
				this.attackerImg.source = "flags/" + (sf.spaceChange(battleVars.attacker)) + ".gif";
				this.defenderImg.source = "flags/" + (sf.spaceChange(battleVars.defender)) + ".gif";
			}
		

		}
		
		public function showOrders(oData:Array, battleVars:BattleVars):void {
			this.bv = battleVars;
			this.bv.attOrders = new Array();
			this.bv.defOrders = new Array();
			
			 trace (oData.toString());
			
			for(var i:int = 0; i<oData.length; i++){
				if(oData[i]["side_country_id"] == this.bv.attackerID){
					this.bv.attOrders.push(oData[i]);
				} else {
					this.bv.defOrders.push(oData[i]);
				}
			}
			
			if(this.bv.attOrders.length == 0){
				this.hideOrders(true, bv);
			} else {
				
				if(this.bv.attOrders[this.bv.attOrdersCurr] != undefined){
					this.showOrder(this.bv.attOrders[this.bv.attOrdersCurr], true);
				} else {
					this.bv.attOrdersCurr = 0;
					this.showOrder(this.bv.attOrders[0], true);
				}
				this.lblAttackBO.visible = true;
				this.lblAttackBO.text = (this.bv.attOrdersCurr + 1) + "/" + this.bv.attOrders.length;
			}
			
			if(this.bv.defOrders.length == 0){
				this.hideOrders(false, this.bv);
			} else {
				
				if(this.bv.defOrders[bv.defOrdersCurr] != undefined){
					this.showOrder(this.bv.defOrders[this.bv.defOrdersCurr], false);
				} else {
					this.bv.defOrdersCurr = 0;
					this.showOrder(this.bv.defOrders[0], false);
				}
				this.lblDefendBO.visible = true;
				this.lblDefendBO.text = (this.bv.defOrdersCurr + 1) + "/" + this.bv.defOrders.length;
			}
		}
		
		protected function showOrder(oData:Object, bIsAttacker:Boolean):void{
			var text:String =  oData["threshold"] + " " + oData["reward"] + "/" + int(oData["budget"]);
			var pc:Number;
			if(bIsAttacker){
				
				
				this.lblAttack.text = text;
				this.lblAttack.toolTip="threshold% reward/budget";
				pc = Math.round((100-bv.defenderPercent[int(oData["division"])-1])*100)/100;

				if(pc < int(oData["threshold"])){
					if(int(oData["reward"]) > int(oData["budget"])){
						this.lblAttack.setStyle("color","0x330066");
					} else {
						this.lblAttack.setStyle("color","0x005500");
					}
				} else {
					this.lblAttack.setStyle("color","0xdd3000");
				}
				if(this.bv.attOrders.length > 0) {
					if(!this.lblAttack.hasEventListener(MouseEvent.CLICK)){
						this.lblAttack.addEventListener(MouseEvent.CLICK,nextAttacker);
						this.lblAttack.buttonMode = true;
					}
				}
			} else {
				this.lblDefend.text = text;
				this.lblDefend.toolTip="threshold% reward/budget";
				pc = Math.round((bv.defenderPercent[int(oData["division"])-1])*100)/100;
				if(pc < int(oData["threshold"])){
					if(int(oData["reward"]) > int(oData["budget"])){
						this.lblDefend.setStyle("color","0x330066");
					} else {
						this.lblDefend.setStyle("color","0x005500");
					}
				} else {
					this.lblDefend.setStyle("color","0xdd3000");
				}
				if(this.bv.defOrders.length > 0) {
					if(!this.lblDefend.hasEventListener(MouseEvent.CLICK)){
						this.lblDefend.addEventListener(MouseEvent.CLICK,nextDeffender);
						this.lblDefend.buttonMode = true;
					}
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
				this.lblAttackBO.visible = false;
				this.lblAttack.text = sf.skroc(battleVars.attacker,11);
				this.lblAttack.setStyle("color","0x000000");
				this.lblAttack.removeEventListener(MouseEvent.CLICK,nextAttacker);
				this.lblAttack.buttonMode = false;
			} else {
				this.lblDefendBO.visible = false;
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
			
			if(shortMessage == "API error")
			{
				lblMessage.addEventListener(MouseEvent.CLICK,read_api_again);
				lblMessage.buttonMode = true;
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