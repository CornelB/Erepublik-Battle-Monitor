package battle
{
	import battle.ShareFunctions;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.formatters.NumberFormatter;
	import mx.utils.ObjectUtil;
	
	import org.osmf.events.TimeEvent;
	
	import spark.components.Label;
	import spark.components.TabBar;
	
	public class BattleHeros extends Canvas
	{
		
		private var bgImgL:Image;
		private var bgImgR:Image;
		private var divTabVew:TabBar;
		private var sf:ShareFunctions=new ShareFunctions();;
		private var nicksArrA:Array=new Array();
		private var nicksArrD:Array=new Array();
		private var herosOb:Object=new Object();
		private var herosObOld:Object=new Object();
		private var bv:BattleVars;
		private var batHeros:Object=new Object();
		private var labelsTimer:Timer=new Timer(4900);
		private var currStage:int=1;
		
	
		
		public function BattleHeros(bv:BattleVars)
		{
			
			this.percentWidth=100;
			this.height=103;
			this.verticalScrollPolicy="off";
			this.horizontalScrollPolicy="off";
			this.bv=bv;
			this.labelsTimer.addEventListener(TimerEvent.TIMER, labelsToBlackTimer);
			this.buttonMode=true;

			

			bgImgL = new Image();
			bgImgL.width=44;
			bgImgL.height=32;
			bgImgL.x=2;
			bgImgL.bottom=0;
			bgImgL.source = "flags/" + (sf.spaceChange(bv.attacker)) + ".gif";
			bgImgL.alpha=0.2;

			this.addChildAt(bgImgL,0);
			
			bgImgR = new Image();
			bgImgR.width=44;
			bgImgR.height=32;
			bgImgR.right=5;
			bgImgR.bottom=0;
			bgImgR.source = "flags/" + (sf.spaceChange(bv.defender)) + ".gif";
			bgImgR.alpha=0.2;

			this.addChildAt(bgImgR,0);
			
			
			var divArr:Array=["Div1", "Div2", "Div3", "Div4"]
			divTabVew=new TabBar();
			divTabVew.percentWidth=100;
			divTabVew.height=15;
			divTabVew.selectedIndex=3;
			divTabVew.addEventListener(Event.CHANGE,this.changeDivision);
			divTabVew.dataProvider=new ArrayList(divArr);
			this.addChild(divTabVew);
			

			for(var i:int=0;i<5;i++)
			{
				nicksArrA[i]=new Label();
				nicksArrA[i].right=92;
				nicksArrA[i].y=17*i+3+17;
				nicksArrA[i].text=(i+1)+".";
				nicksArrA[i].id="at_-"+(i+1);
				nicksArrA[i].buttonMode=true;
				nicksArrA[i].addEventListener(MouseEvent.CLICK,jumpToCitizen);
				nicksArrA[i].addEventListener(MouseEvent.MOUSE_OVER,labelMouseOver);
				nicksArrA[i].addEventListener(MouseEvent.MOUSE_OUT,labelMouseOut);
				this.addChild(nicksArrA[i]);
				
				nicksArrD[i]=new Label();
				nicksArrD[i].right=3;
				nicksArrD[i].y=17*i+3+17;
				nicksArrD[i].text=(i+1)+".";
				nicksArrD[i].id="de_-"+(i+1);
				nicksArrD[i].buttonMode=true;
				nicksArrD[i].addEventListener(MouseEvent.CLICK,jumpToCitizen);
				nicksArrD[i].addEventListener(MouseEvent.MOUSE_OVER,labelMouseOver);
				nicksArrD[i].addEventListener(MouseEvent.MOUSE_OUT,labelMouseOut);
				this.addChild(nicksArrD[i]);
				
			}
			
			this.addEventListener(MouseEvent.CLICK,fightersOrDamage);
			
			return;
		}
		
		public function switchSites(bv:BattleVars):void
		{
			this.bv = bv;
			
			bgImgL.source = "flags/" + (sf.spaceChange(bv.attacker)) + ".gif";
			bgImgR.source = "flags/" + (sf.spaceChange(bv.defender)) + ".gif";
			
		}
		
		private function labelMouseOver(event:MouseEvent):void
		{
			event.target.setStyle("color","#800000");
			return;
		}
		
		private function labelMouseOut(event:MouseEvent):void
		{
			event.target.setStyle("color","#000000");
			findUser();
			return;
		}
		
		private function fightersOrDamage(event:Event):void
		{
			if(!(event.target is Label))
			{
				this.setStage(++this.currStage);
			}
			
		}
		
		protected function setStage(iStage: int):void{
			if(iStage > 3){
				iStage = iStage - 3;
			}
			this.currStage = iStage;
			if(iStage == 1){
				this.toolTip="Show fighters";
			} else if(iStage == 2) {
				this.toolTip="Show kills";
			} else {
				this.toolTip="Show damage";
			}
			this.updateLabels();
		}
		
		private function jumpToCitizen(event:MouseEvent):void
		{
		 	try{
				var lab_id:String=(event.target as Label).id;
			 	var cit_id:int=int(lab_id.substr(3,lab_id.length));
			 	if(cit_id>0)navigateToURL(new URLRequest("http://www.erepublik.com/en/citizen/profile/" + cit_id));
			}
			catch(e:Error)
			{
				
			};
			
			
			return;
		}// end function
		
		public function updateHeros(batHeros:Object,fightersData:Object):void
		{
			var i:int;
		
			for( var curBat:* in batHeros); //curent battle
						
			herosOb=new Object();
			
		 	for(var div:* in batHeros[curBat]) //for each division
			{

				var top5:Object=new Object();
				
				var top5cit:Object=new Object();
				for(var plr:* in batHeros[curBat][div][this.bv.attackerID]['top_damage']) //for each player -attacker
				{
				
				    var cit:Object=new Object();
					cit["damage"]=batHeros[curBat][div][this.bv.attackerID]['top_damage'][plr]["damage"];
					cit["kills"]=batHeros[curBat][div][this.bv.attackerID]['top_damage'][plr]["kills"];
					cit["citizen_id"]=batHeros[curBat][div][this.bv.attackerID]['top_damage'][plr]["citizen_id"];
				 	cit["citizen_name"]=fightersData[cit["citizen_id"]]["name"];
					top5cit[plr]=cit;

				}
			 	top5["attacker"]=top5cit;
				
				top5cit=new Object();
				for(plr in batHeros[curBat][div][this.bv.defenderID]['top_damage']) //for each player -attacker
				{
										
					cit=new Object();
					cit["damage"]=batHeros[curBat][div][this.bv.defenderID]['top_damage'][plr]["damage"];
					cit["kills"]=batHeros[curBat][div][this.bv.defenderID]['top_damage'][plr]["kills"];
					cit["citizen_id"]=batHeros[curBat][div][this.bv.defenderID]['top_damage'][plr]["citizen_id"];
				 	cit["citizen_name"]=fightersData[cit["citizen_id"]]["name"];
					top5cit[plr]=cit;
					
				}
				top5["defender"]=top5cit;
				herosOb[div]=top5;
		 	}

			 //trace ("ac"+ObjectUtil.toString(fightersData));

			 updateLabels();
			 findUser();
			 labelsTimer.start();
			 
			
		}
		private function changeDivision(e:Event):void
		{

			this.setStage(this.currStage+2);
			labelsToBlack();
			updateLabels();
			findUser();
			labelsTimer.start();
			
			
		}
		
		private function updateLabels():void
		{
			var source:String = "damage";
			var nf:NumberFormatter=new NumberFormatter();
			nf.thousandsSeparatorTo=" ";

			switch(this.currStage){
				case 1 :{
					source = 'damage';
					break;
				}
				case 2: {
					source = 'citizen_name';
					break;
				}
				case 3: {
					source = 'kills';
					break;
				}
			}
			
			for(var i:int=0;i<5;i++)
			{
				try{
					if(int(herosObOld[this.divTabVew.selectedIndex+1]["attacker"][i]["damage"])<int(herosOb[this.divTabVew.selectedIndex+1]["attacker"][i]["damage"]))
					{
						nicksArrA[i].setStyle("color","0x006600");
					}
					
				}catch(e:Error){};
				
				try{
					if(this.currStage == 2){
						nicksArrA[i].text=sf.skroc(herosOb[this.divTabVew.selectedIndex+1]["attacker"][i][source],11);
					} else {
						nicksArrA[i].text=nf.format(herosOb[this.divTabVew.selectedIndex+1]["attacker"][i][source]);
					}
					
				 	nicksArrA[i].toolTip=herosOb[this.divTabVew.selectedIndex+1]["attacker"][i]["citizen_name"];
					nicksArrA[i].id="at_"+herosOb[this.divTabVew.selectedIndex+1]["attacker"][i]["citizen_id"];
					
				}catch(e:Error){
					nicksArrA[i].text="";
				};
				
				try{
					if(int(herosObOld[this.divTabVew.selectedIndex+1]["defender"][i]["damage"])<int(herosOb[this.divTabVew.selectedIndex+1]["defender"][i]["damage"]))
					{
						nicksArrD[i].setStyle("color","0x006600");
					}	
					
					
				}catch(e:Error){};
				try{	
					if(this.currStage == 2){
						nicksArrD[i].text=sf.skroc(herosOb[this.divTabVew.selectedIndex+1]["defender"][i][source],11);
					} else {
						nicksArrD[i].text=nf.format(herosOb[this.divTabVew.selectedIndex+1]["defender"][i][source]);
					}
					nicksArrD[i].toolTip=herosOb[this.divTabVew.selectedIndex+1]["defender"][i]["citizen_name"];
					nicksArrD[i].id="de_"+herosOb[this.divTabVew.selectedIndex+1]["defender"][i]["citizen_id"];
				}catch(e:Error){
					nicksArrD[i].text="";
				};
				
			}
			herosObOld=this.herosOb;
			
		}
		private function labelsToBlackTimer(e:TimerEvent):void
		{
			labelsToBlack();
			findUser();
			labelsTimer.stop();
		}
		
		private function labelsToBlack():void
		{
			for(var i:int=0;i<5;i++)
			{
				nicksArrA[i].setStyle("color","0x000000");
				nicksArrD[i].setStyle("color","0x000000");
			}
		}
		
		private function findUser():void
		{
			for(var i:int=0;i<5;i++)
			{
				try
				{
					if(int(herosOb[this.divTabVew.selectedIndex+1]["defender"][i]["citizen_id"])==this.bv.userID)
						nicksArrD[i].setStyle("color","0xbb0000");
					
				}catch(e:Error){/*trace("defender_blad bid:"+this.bv.battleId);*/};//gdy nie ma jescze wszystkich herosow
				
				try
				{
					
					if(int(herosOb[this.divTabVew.selectedIndex+1]["attacker"][i]["citizen_id"])==this.bv.userID)
						nicksArrA[i].setStyle("color","0xbb0000");
					
				}catch(e:Error){/*trace("attacker_blad bid:"+this.bv.battleId);*/};//gdy nie ma jescze wszystkich herosow
				
			}
		}
		
			
	}
}
