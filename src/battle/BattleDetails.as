package battle
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	
	import spark.components.Label;
	
	public class BattleDetails extends Canvas
	{

		
		private var lblproc1:Label;
		private var lblproc2:Label;
		private var lblproc3:Label;
		private var lblproc4:Label;
		
		[Embed(source='img/domia.png')] 
		public var domiaImageClass:Class; 
		[Embed(source='img/domid.png')] 
		public var domidImageClass:Class; 
		[Embed(source='img/middle.png')] 
		public var middleImageClass:Class; 
		
		private var middleImage:Image;
		private var domiBD:BitmapData;
		private var domiImgArr:Array=new Array();
		

		
		
		private var labels:Array=new Array();
		
		public function BattleDetails()
		{
			this.percentWidth=100;
			var i:int,j:int;
			
			middleImage=new Image();
			middleImage.source=middleImageClass;
			middleImage.horizontalCenter=-3;
			middleImage.y=0;
			
			middleImage.height=68;
			this.addChildAt(middleImage,0);
			
			
			for(i=0;i<4;i++)
			{
				labels[i]=new Array();
				
				domiImgArr[i] = new Image();
				domiBD = new domiaImageClass().bitmapData;
				domiBD.scroll(-93,0);
				domiImgArr[i].y=17*i;
				domiImgArr[i].source=new Bitmap(domiBD);
				domiImgArr[i].width=180;
				domiImgArr[i].height=17;
				domiImgArr[i].scaleContent=false;
				this.addChildAt(domiImgArr[i],0);
			}


			for(i=0;i<4;i++)
			{
				for(j=0;j<4;j++)
				{
					labels[i][j]= new Label();
					
					
					labels[i][j].setStyle("color","0xFFFFFF");
					
					if(j==0||j==3)
					{
						labels[i][j].text="0";
					}
					else 
					{
						labels[i][j].text="xx.x%";
					}
						
					labels[i][j].y=17*i+2;
					
					if(j==0)labels[i][j].left=0;
					if(j==1)labels[i][j].horizontalCenter=-30;
					if(j==2)labels[i][j].horizontalCenter=30;
					if(j==3)labels[i][j].right=2;
					
					this.addChild(labels[i][j]);
				}
			}

		}

	 	public function aktualizujDominacje(bv:BattleVars):void
		{
			
			for(var i:int=0;i<4;i++)
			{

				if(bv.attackerDomin[i]>bv.attackerDominOld[i]&&bv.attackerDomin[i]<bv.attackerDominOld[i]+200)
				{
					labels[i][0].setStyle("color","0xaaffaa");
					this.animate(labels[i][0],bv.attackerDominOld[i],bv.attackerDomin[i],2);
				}
				else
				{
				  labels[i][0].text=bv.attackerDomin[i];
				  labels[i][0].setStyle("color","0xffffff");
				}
				
				
				if(bv.defenderDomin[i]>bv.defenderDominOld[i]&&bv.defenderDomin[i]<bv.defenderDominOld[i]+200)
				{
					labels[i][3].setStyle("color","0xaaffaa");
					this.animate(labels[i][3],bv.defenderDominOld[i],bv.defenderDomin[i],2);
				}
				else
				{
					labels[i][3].text=bv.defenderDomin[i];
					labels[i][3].setStyle("color","0xffffff");
					
				}
				
				
				labels[i][1].text=(Math.round((100-bv.defenderPercent[i])*100)/100)+"%";
				if(Math.round((100-bv.defenderPercent[i])*100)/100>Math.round((100-bv.defenderPercentOld[i])*100)/100)labels[i][1].setStyle("color","0xaaffaa");
				if(Math.round((100-bv.defenderPercent[i])*100)/100<Math.round((100-bv.defenderPercentOld[i])*100)/100)labels[i][1].setStyle("color","0xffdddd");
				if(Math.round((100-bv.defenderPercent[i])*100)/100==Math.round((100-bv.defenderPercentOld[i])*100)/100)labels[i][1].setStyle("color","0xffffff");
	
				labels[i][2].text=(Math.round(bv.defenderPercent[i]*100)/100)+"%";
				if(Math.round(bv.defenderPercent[i]*100)/100>Math.round(bv.defenderPercentOld[i]*100)/100)labels[i][2].setStyle("color","0xaaffaa");
				if(Math.round(bv.defenderPercent[i]*100)/100<Math.round(bv.defenderPercentOld[i]*100)/100)labels[i][2].setStyle("color","0xffdddd");
				if(Math.round(bv.defenderPercent[i]*100)/100==Math.round(bv.defenderPercentOld[i]*100)/100)labels[i][2].setStyle("color","0xffffff");
		 		
				if(bv.defenderPercent[i]<=50)
				{
				 	domiBD = new domiaImageClass().bitmapData;
				}
				else
				{
					domiBD = new domidImageClass().bitmapData;
				}
				domiBD.scroll(-bv.defenderPercent[i]*180/100-3,0);
				domiImgArr[i].source=new Bitmap(domiBD);
				
				
				
			}
			
		}
		
		private function animate(l:Label,odIlu:int,doIlu:int,ileSekundTrwa:int):void
		{
			
			var diff:int=doIlu-odIlu;


			var t:Timer = new Timer(int(ileSekundTrwa*1000/diff));
			
			t.addEventListener(TimerEvent.TIMER, 
			function animation(e:Event):void{
				l.text=String(int(l.text)+1);
				if(int(l.text)>=doIlu)t.stop();
				return;
			}
			);
			t.start();
			
		}
		
		public function setWhiteLabels():void
			
		{
			for(var i:int=0;i<4;i++)
			{
				for(var j:int=0;j<4;j++)
				{
					labels[i][j].setStyle("color","0xffffff");
				}
			}
		}
		
		public function finishBattleDet(winner:String):void
		{
			
			var i:int,j:int;
			var sf:ShareFunctions=new ShareFunctions;
			for(i=0;i<4;i++)
			{
				domiImgArr[i].visible=false;
				for(j=0;j<4;j++)
				{
					labels[i][j].visible=false;
				}
			}
			
			var lblTheWinner:Label = new Label();
			lblTheWinner.horizontalCenter=0;
			lblTheWinner.y=10;
			lblTheWinner.text="THE WINNER IS:";
			lblTheWinner.setStyle("color","0x006600");
			this.addChild(lblTheWinner);
			
			var imgTheWinner:Image = new Image();
			imgTheWinner.y=25;
			imgTheWinner.horizontalCenter=0;
			imgTheWinner.source = "flags/" + (sf.spaceChange(winner)) + ".gif";
			this.addChild(imgTheWinner);
			
			var lblTheWinnerCountry:Label = new Label();
			lblTheWinnerCountry.y=45;
			lblTheWinnerCountry.setStyle("color","0x006600");
			lblTheWinnerCountry.horizontalCenter=0;
			lblTheWinnerCountry.text=sf.skroc(winner,26);
			this.addChild(lblTheWinnerCountry);

		}
	}
}