package comp
{

	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.events.CloseEvent;
	
	import spark.components.Button;
	import spark.components.HGroup;
	import spark.components.Label;

	
	
	
	public class BattleInList extends Canvas
	{

		private var lblRefresh:Label,lblBattle:Label,lblTime:Label,lblAttack:Label,lblDefend:Label;
		private var attacker:String,defender:String;
		private var TIMER_INTERVAL1:int = 1000;
		public var t:Timer;
		private var licz:int=1;
		private var addImg:Image,openBattleImg:Image,hospitalImg:Image;
		private var attackerImg:Image,defenderImg:Image;

		private var rbArray:Array=new Array;
		

		[Embed(source='img/h.png')] 
		public var h_image:Class; 
		
		[Embed(source='img/gotoapp16.png')] 
		public var gotoapp_image:Class; 
		
		[Embed(source='img/add16.png')] 
		public var add_image:Class; 
		
		private var bid:int;
		private var region:String;
		private var is_rw:Boolean;
		
		public function BattleInList(width:int,height:int, bid:int, region:String, attacker:String, defender:String, is_rw:Boolean)
		{
			this.width=width;
			this.height=height;
			this.verticalScrollPolicy="off";
			this.setStyle("borderStyle","solid");
			this.setStyle("borderThickness","10");
			this.setStyle("borderColor", 0x333333);
			
			this.region = region;
			this.bid = bid;
			this.attacker = attacker;
			this.defender = defender;
			this.is_rw = is_rw;
		
			interfaceInit();

		
			
			return;
		}// end function
		
		
		
		public function interfaceInit():void
		{
			
			var hbox:HBox=new HBox();
			hbox.y=3;
			var cv:Canvas=new Canvas();
			
			lblBattle = new Label();
			
			lblBattle.addEventListener(MouseEvent.CLICK,jumpToRegion);
			lblBattle.buttonMode=true;
			lblBattle.height=24;
			lblBattle.toolTip=this.region;
		 	lblBattle.x=0;
			lblBattle.y=1;
			
			
			
			cv.addChild(lblBattle);
			hbox.addChild(cv);
			

			if(!is_rw)lblBattle.text=this.bid+'.'+skroc(this.region,16)
			else lblBattle.text=this.bid+'.'+skroc(this.region,12)+'(RW)';
	
			this.addChild(hbox);
			
			lblTime=new Label();
			lblTime.text='vs.';
			lblTime.horizontalCenter=-10;
			lblTime.y=20;
			this.addChild(lblTime);
			
			openBattleImg = new Image();
			openBattleImg.toolTip="Go to battle";
			openBattleImg.source=gotoapp_image;
			openBattleImg.buttonMode=true;
			openBattleImg.right=0;
			openBattleImg.y=20;
			openBattleImg.addEventListener(MouseEvent.CLICK, this.jumpToBattle);
			this.addChild(openBattleImg);
			
			addImg = new Image();
			addImg.toolTip="Add to monitor";
			addImg.source=add_image;
			addImg.buttonMode=true;
			addImg.right=0;
			addImg.y=5;
			addImg.addEventListener(MouseEvent.CLICK, this.addBattle);
			this.addChild(addImg);
			
			attackerImg = new Image();
			attackerImg.x=27;
			attackerImg.y=17;

			this.attackerImg.source = "flags/" + (spaceChange(this.attacker)) + ".gif";
			this.attackerImg.toolTip =this.attacker;
			this.addChild(attackerImg);
			
			defenderImg = new Image();
			defenderImg.right=45;
			defenderImg.y=17;
		
			this.defenderImg.source = "flags/" + (spaceChange(this.defender)) + ".gif";
			this.defenderImg.toolTip = this.defender;
			this.addChild(defenderImg);
			return;
			
			
		}// end function
		



		
		public function jumpToBattle(param1:Event):void
		{
			navigateToURL(new URLRequest("http://www.erepublik.com/en/military/battlefield/" + this.bid));
			return;
		}// end function	
		
		public function jumpToRegion(param1:Event):void
		{
			navigateToURL(new URLRequest("http://www.erepublik.com/en/region/" + spaceChange(this.region)));
			return;
		}// end function
		
		

		
		private function spaceChange(s:String):String
		{
			if(s.search(' ')!=-1)return (spaceChange(s.replace(' ','-')))
			else return s;
			
		}
		
		public function addBattle(param1:Event):void
		{
			var addEvent:AddBattleEvent = new AddBattleEvent(AddBattleEvent.ADD_BATTLE_EVENT);
			addEvent.wybraneID=this.bid;
			dispatchEvent(addEvent);
			
		}
		
		private function skroc(s:String, doIlu:int):String
		{
			if(s.length<=doIlu)
				if(int(is_rw)==0)return s
				else return s+' ';
			else{
				var l1:String=s.substr(0,doIlu);
				if(l1.charAt(l1.length-1)==' ')l1=s.substr(0,doIlu-1);
				return l1+'.';
				
			}
		}
		

		
	}
}