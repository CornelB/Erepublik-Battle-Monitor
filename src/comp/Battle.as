package comp
{

	import battle.*;
	
	import comp.AnimatedTitleWindow;
	
	import events.ChangeRefreshEvent;
	import events.ChangeSizeEvent;
	import events.ReadApiEvent;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.TitleWindow;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectUtil;
	
	import spark.components.BorderContainer;
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.RadioButton;
	import spark.effects.Resize;
	
	
	public class Battle  extends Canvas
	{
		private var battleButtons:BattleButtons;
		private var battleVars:BattleVars;
		private var battleHeader:BattleHeader;
		private var battleDetails:BattleDetails;
		private var battleCountries:BattleCountries;
		private var battleHeros:BattleHeros;
		public var sf:ShareFunctions=new ShareFunctions();
		
		private var anTW:AnimatedTitleWindow;
		
		private var vboxGlobal:VBox;
		private var hboxContent:HBox;
		
		private var t1:Timer;
		private var timerLabel:Timer;
	
		private var czy_server:Boolean = false;
		private var first_login:Boolean = true;
		private var dominacja_odwrotna:Boolean = false;
		
		public function Battle(batId:int,batRef:int,width:int,height:int,sv:SettingsVars)
		{


			this.width=width;
			this.height=height;
			this.verticalScrollPolicy="off";
			this.horizontalScrollPolicy="off";
			this.setStyle("borderStyle","solid");
			this.setStyle("borderThickness","5");
			this.setStyle("borderColor", 0x333333);
			this.czy_server = sv.use_xampp;
			//this.dominacja_odwrotna = dominacja_odwrotna; //z tym jak się zmieni strony i zamknie BM to później sie źle otworzy
			
			battleVars = new BattleVars(batId,batRef,sv.bsurl,sv.userID,sv.email,sv.pass);
			
			battleButtons = new BattleButtons(batId);
			battleButtons.addEventListener(Event.CLOSE,this.battleClose); 
			battleButtons.openUpdateImg.addEventListener(MouseEvent.CLICK, openUpdateWindow);
			
			
			battleDetails = new BattleDetails();
			battleCountries = new BattleCountries();
		/*	this.battleCountries.attackerImg.addEventListener(MouseEvent.CLICK,switchAll);
			this.battleCountries.attackerImg.buttonMode = true;
			this.battleCountries.attackerImg.toolTip = 'Switch All';*/
			
			battleHeader = new BattleHeader();
			battleHeader.lblBattle.text=battleVars.battleId.toString();
						
			vboxGlobal = new VBox()
			hboxContent = new HBox();
	
			vboxGlobal.setStyle("horizontalGap","0");
			vboxGlobal.setStyle("verticalGap","0");
			
			hboxContent.setStyle("horizontalGap","0");
			hboxContent.setStyle("verticalGap","0");
		
			vboxGlobal.width=width;
			hboxContent.width=width;
			
			hboxContent.addChild(battleCountries);
			hboxContent.addChild(battleButtons);
					
			vboxGlobal.addChild(battleHeader);
			vboxGlobal.addChild(hboxContent);
			vboxGlobal.addChild(battleDetails);
			this.addChild(vboxGlobal);
				
			setTimers();
			readApi();

			return;
		}// end function
		

		public function getDominacja_odwrotna():Boolean
		{
			return this.dominacja_odwrotna;
		}

		
		private function battleClose(param1:Event):void
		{
			t1.stop();
			this.removeAllElements();
			dispatchEvent(new Event(Event.CLOSE));
			return;
		}// end function
		

		public function getBattleID():int
		{
			return battleVars.battleId;
		}
		
		public function setBSUrl(bsurl:String):void
		{
			this.battleVars.bsurl=bsurl;
			this.battleCountries.showMessage("SettsSaved","Settings are saved","info");
		}
		
		public function setCzyServer(czy_server:Boolean):void
		{
			this.czy_server=czy_server;
			if(!czy_server)this.first_login = true;
		}
		
		public function setEmail(email:String):void
		{
			this.battleVars.email=email;
			
		}
		public function setPass(pass:String):void
		{
			this.battleVars.pass=pass;
			
		}
		
		public function setUserID(userID:int):void
		{
			this.battleVars.userID=userID;
		
		}
		
		public function getOdIluOdliczacOdswierzenia():int
		{
			return battleVars.odIluOdliczacOdswierzenia;
		}
		
		private function setWhiteLabels(e:TimerEvent):void
		{
			timerLabel.stop();
			this.battleDetails.setWhiteLabels();
		}
		
		private function aktualizujOdswierzenia(param1:TimerEvent):void
		{

			if(battleVars.licznikOdswierzen<=0)
			{
				if(battleVars.czyMoznaOdswierzac){battleVars.czyMoznaOdswierzac=false;readBattleLog();}
				this.battleHeader.lblRefresh.text='now';
				
			}else this.battleHeader.lblRefresh.text=battleVars.licznikOdswierzen.toString();
			
			battleVars.licznikOdswierzen--;
			
			var _loc_3:Number;
			var _loc_4:Number;
			var _loc_5:Number;
			var _loc_6:Number;	
			
			_loc_3 = this.battleVars.ileSekundTrwaJuzMini;
			
			_loc_4 = Math.floor(_loc_3 / (3600));
			_loc_5 = Math.floor(_loc_3 % (3600) / (60));
			_loc_6 = Math.floor(_loc_3 % 60);
			if (_loc_3>=0)this.battleCountries.lblTime.text = (_loc_4) + ":" + (_loc_5 < 10 ? ("0" + _loc_5) : (_loc_5)) + ":" + (_loc_6 < 10 ? ("0" + _loc_6) : (_loc_6));
			
		
			battleVars.ileSekundTrwaJuzMini++;

			
			return;
			
		}// end function
		
		private function timeUpdate(pts:int):int
		{
		//	trace("pts:"+pts);
			if(pts<=300)return Math.round(pts/10);
			if(pts>300&&pts<=900)return 30+Math.round((pts-300)/20);
			if(pts>900&&pts<=1800)return 60+Math.round((pts-900)/30);
			if(pts>1800)return 90+Math.round((pts-1800)/60);
			return 0;
			
		}
		
		private function setTimers():void
		{
			t1 = new Timer(1000);
			t1.addEventListener(TimerEvent.TIMER, aktualizujOdswierzenia);
			
			
			this.timerLabel = new Timer(4800);
			this.timerLabel.addEventListener(TimerEvent.TIMER, setWhiteLabels);
			
			
		}
		
		public function readApi(e:ReadApiEvent = null):void
		{
		 	trace(this.battleVars.battleId+': Reading API');
			var _loc_1:* = new URLLoader();
			_loc_1.load(new URLRequest("http://api.erpk.org/battle/" + this.battleVars.battleId+'.json?key=ecvgbLriaG' ));
			_loc_1.addEventListener(Event.COMPLETE, this.readApiComplete);
			_loc_1.addEventListener(IOErrorEvent.IO_ERROR, this.readApiError);
		}// end function
		
		private function readApiError(param1:Event=null):void
		{
			trace(this.battleVars.battleId+': Reading API ERROR');
			
			this.battleCountries.showMessage("Check domi","Click to try again or click flag","warning");
			this.battleCountries.addEventListener(ReadApiEvent.READ_API_EVENT,  readApi);
			
			t1.start();
				
		}
		
		
		
		
		private function readApiComplete(param1:Event) : void
		{
		//	trace("read API Complete");
			
			try
			{
			var jsonData:Object;
			jsonData = JSON.parse(''+param1.currentTarget.data);
			this.battleVars.attacker =  jsonData['attacker']['name'];
			this.battleVars.defender =  jsonData['defender']['name'];
			this.battleVars.attackerID =  jsonData['attacker']['id'];
			this.battleVars.defenderID =  jsonData['defender']['id'];
			this.battleVars.region= jsonData['region']['name'];
			this.battleVars.isResistance= jsonData['is_resistance'];
			this.battleCountries.showMessage("Connected","API connect success","ok");
			}
			catch (e:Error)
			{
				readApiError();
			}
			updateBattleData();
	/*		var xml:XML = new XML(param1.currentTarget.data);
			
			this.battleVars.attacker =  xml.attacker.name;
			this.battleVars.defender =  xml.defender.name;
			this.battleVars.attackerID =  xml.attacker.id;
			this.battleVars.defenderID =  xml.defender.id;
			this.battleVars.region= xml.region.name;
			this.battleVars.isResistance= xml['is-resistance'];
			updateBattleData();*/
			
			if(this.battleCountries.defenderImg.hasEventListener(MouseEvent.CLICK))
			{
				this.battleCountries.defenderImg.removeEventListener(MouseEvent.CLICK,switchDomination);
				this.battleCountries.defenderImg.buttonMode = false;			
				this.battleCountries.defenderImg.toolTip = '';
			}

		}
		
		public function updateBattleData():void
		{
			this.battleCountries.updateData(battleVars);
		
			
			if(this.battleVars.isResistance=='false')this.battleHeader.lblBattle.text=this.battleVars.battleId+'.'+sf.skroc(this.battleVars.region,17)
			else this.battleHeader.lblBattle.text=this.battleVars.battleId+'.'+sf.skroc(this.battleVars.region,12)+'(RW)';
			this.battleHeader.lblBattle.toolTip=this.battleVars.region;
			this.battleHeader.lblBattle.buttonMode=true;
			this.battleHeader.lblBattle.addEventListener(MouseEvent.CLICK,jumpToRegion);
			
			battleHeros = new BattleHeros(this.battleVars);
			vboxGlobal.addChild(battleHeros);
			
			this.battleCountries.lblTime.addEventListener(MouseEvent.CLICK,showHeros);
			this.battleCountries.lblTime.buttonMode=true;
			this.battleCountries.clockImage.addEventListener(MouseEvent.CLICK,showHeros);
			this.battleCountries.clockImage.buttonMode=true;
			this.battleCountries.showHideHerosImage.addEventListener(MouseEvent.CLICK,showHeros);
			this.battleCountries.showHideHerosImage.buttonMode=true;
			

			if(t1.running)battleVars.licznikOdswierzen=1;
			else t1.start();
			
		}// end function
		
		private function switchDomination(e:MouseEvent):void
		{
			dominacja_odwrotna = !dominacja_odwrotna;
			battleVars.licznikOdswierzen = 0;
			this.battleCountries.hideWarning();
		}
		
		
		private function showHeros(event:Event):void
		{
			var changeSizeEvent:ChangeSizeEvent = new ChangeSizeEvent (ChangeSizeEvent.CHANGE_SIZE_EVENT);
			
			if(this.battleVars.battleHerosAreHidden)
			{
				this.height+=battleHeros.height;
				

				changeSizeEvent.heightChanged=battleHeros.height;
				this.battleVars.battleHerosAreHidden=false;
				this.battleCountries.showHideHerosImage.source=this.battleCountries.hideHerosImageClass;
			}
			else
			{
				this.height-=battleHeros.height;
				changeSizeEvent.heightChanged=-battleHeros.height;
				this.battleVars.battleHerosAreHidden=true;
				this.battleCountries.showHideHerosImage.source=this.battleCountries.showHerosImageClass;
			}
			dispatchEvent(changeSizeEvent);
			
		}
		
		private function readBattleLog():void
		{
			var _loc_1:URLLoader = new URLLoader();
			if(czy_server)
			{
				
			//	trace(this.battleVars.bsurl + "?bid=" + this.battleVars.battleId);
				_loc_1.load(new URLRequest(this.battleVars.bsurl + "?bid=" + this.battleVars.battleId ));
				_loc_1.addEventListener(Event.COMPLETE, this.readBattleLogComplete);
				_loc_1.addEventListener(IOErrorEvent.IO_ERROR, this.readBattleLogError);
			}
			else
			{
				if(first_login)
				{
			//	trace('bez xampp');
				_loc_1.load(new URLRequest("http://www.erepublik.com/en"));
				_loc_1.addEventListener(Event.COMPLETE, this.readBattleLogStep1);
				_loc_1.addEventListener(IOErrorEvent.IO_ERROR, this.readBattleLogError);
				first_login = false;
				}
				else
				{
					//var _loc_1:* = new URLLoader();
				//	trace('kolejne');
					_loc_1.load(new URLRequest("http://www.erepublik.com/en/military/battle-stats/" + this.battleVars.battleId ));
					_loc_1.addEventListener(Event.COMPLETE, this.readBattleLogComplete);
					_loc_1.addEventListener(IOErrorEvent.IO_ERROR, this.readBattleLogError);
				
				}
				
			}
	
			

		}// end function
	
	private function readBattleLogStep1(param1:Event) : void
	{
		
		var pattern:RegExp = /name="_token" value="([a-z0-9]+)"/i;

		var regex_token:Array = pattern.exec(param1.currentTarget.data);

		var request:URLRequest = new URLRequest("http://www.erepublik.com/en/login");
		
		request.data = '_token='+regex_token[1]+'&citizen_email='+this.battleVars.email+'&citizen_password='+this.battleVars.pass+'&commit=Login';
		request.method = URLRequestMethod.POST;
		
		var _loc_1:* = new URLLoader();
		_loc_1.load(request);
		_loc_1.addEventListener(Event.COMPLETE, readBattleLogStep2);
		_loc_1.addEventListener(IOErrorEvent.IO_ERROR, this.readBattleLogError);
		
	}
	
	private function readBattleLogStep2(param1:Event) : void
	{
		var _loc_1:* = new URLLoader();
		_loc_1.load(new URLRequest("http://www.erepublik.com/en/military/battle-stats/" + this.battleVars.battleId ));
		_loc_1.addEventListener(Event.COMPLETE, this.readBattleLogComplete);
		_loc_1.addEventListener(IOErrorEvent.IO_ERROR, this.readBattleLogError);
	}
		
	public function getRegion():void
	{
		//	trace(this.battleVars.battleId+': Reading API');
		var _loc_1:* = new URLLoader();
		
		if(this.czy_server)
		{
			_loc_1.load(new URLRequest(this.battleVars.bsurl + "?campaigns=1"));
		}
		else
		{
			_loc_1.load(new URLRequest("http://www.erepublik.com/en/military/campaigns"));
			
		}
		_loc_1.addEventListener(Event.COMPLETE, this.readRegionComplete);
	}// end function
	
	private function readRegionComplete(param1:Event) : void
	{
	//	trace('region'+param1.currentTarget.data);
		
		var pattern:RegExp = new RegExp('[<li class="mpp"|<li] id="battle-'+this.battleVars.battleId+'">(.+?)<\/li>');
		

		var li:Array = pattern.exec(param1.currentTarget.data);
		
		pattern = /<span>(.+?)<\/span>/;
		var region:Array = pattern.exec(li[1]);
		
		this.battleVars.region = region[1];

		
		pattern = /resistance_sign/;

		if(pattern.test(li[1]))this.battleHeader.lblBattle.text=this.battleVars.battleId+'.'+sf.skroc(this.battleVars.region,12)+'(RW)';
		else this.battleHeader.lblBattle.text=this.battleVars.battleId+'.'+sf.skroc(this.battleVars.region,17)

		this.battleHeader.lblBattle.toolTip=this.battleVars.region;
		this.battleHeader.lblBattle.buttonMode=true;
		this.battleHeader.lblBattle.addEventListener(MouseEvent.CLICK,jumpToRegion);

	}
	
		
		private function readBattleLogComplete(param1:Event) : void
		{
			
	 	 try{
			var jsonData:Object, i:int;
			jsonData = JSON.parse(''+param1.currentTarget.data);

			if(t1.running)
			{
				var battleLogAC:ArrayCollection = new ArrayCollection();
				if(jsonData["division"][battleVars.attackerID])
				{
					battleLogAC.addItem(jsonData["division"][battleVars.attackerID]);
					battleLogAC.addItem(jsonData["division"][battleVars.defenderID]);
					
				}
				else
				{
					battleVars.region ='';
					this.battleVars.isResistance = 'false';
					getRegion();

					
					for(i = 1; i<200; i++)
					{
						if(jsonData["division"][i])
						{
							battleLogAC.addItem(jsonData["division"][i]);
							battleVars.attackerID = i;
							battleVars.attacker = id2country(battleVars.attackerID);
							
							while(i<200)
							{
								i++;
								if(jsonData["division"][i])
								{
									battleLogAC.addItem(jsonData["division"][i]);
									battleVars.defenderID = i;
									battleVars.defender = id2country(battleVars.defenderID);
									break;
									
								}
							}
							break;
						}
	
					}
										this.battleCountries.defenderImg.addEventListener(MouseEvent.CLICK,switchDomination);
					this.battleCountries.defenderImg.buttonMode = true;			
					this.battleCountries.defenderImg.toolTip = 'Switch Percent domination';
					
					updateBattleData();
					
				}
				
				battleLogAC.addItem(jsonData["division"]["domination"]);
	
				//time update
				if(battleLogAC[0][1]["domination"]<battleVars.attackerDomin[0]||battleLogAC[1][1]["domination"]<battleVars.defenderDomin[0])
					this.battleVars.ileSekundTrwaJuzMini=timeUpdate(
						Math.max(
							int(battleLogAC[0][1]["domination"])+int(battleLogAC[1][1]["domination"]),
							int(battleLogAC[0][2]["domination"])+int(battleLogAC[1][2]["domination"]),
							int(battleLogAC[0][3]["domination"])+int(battleLogAC[1][3]["domination"]),
							int(battleLogAC[0][4]["domination"])+int(battleLogAC[1][4]["domination"])
							)
						)*60;
				

				
				this.battleVars.attackerDomin=
				[
					int(battleLogAC[0][1]["domination"]),
					int(battleLogAC[0][2]["domination"]),
					int(battleLogAC[0][3]["domination"]),
					int(battleLogAC[0][4]["domination"])
				];
				
				this.battleVars.defenderDomin=
				[
					int(battleLogAC[1][1]["domination"]),
					int(battleLogAC[1][2]["domination"]),
					int(battleLogAC[1][3]["domination"]),
					int(battleLogAC[1][4]["domination"])
				];
				
				if(!dominacja_odwrotna)
				{
					this.battleVars.defenderPercent=
					[
						Number(battleLogAC[2][1]),
						Number(battleLogAC[2][2]),
						Number(battleLogAC[2][3]),
						Number(battleLogAC[2][4])
					];
				}
				else
				{
					this.battleVars.defenderPercent=
						[
							(Math.round((100-Number(battleLogAC[2][1]))*100)/100),
							(Math.round((100-Number(battleLogAC[2][2]))*100)/100),
							(Math.round((100-Number(battleLogAC[2][3]))*100)/100),
							(Math.round((100-Number(battleLogAC[2][4]))*100)/100)

						];
				}
				
				//heros update
				this.battleHeros.updateHeros(jsonData["stats"]["current"],jsonData["fightersData"]);
				
				//total points update
				aktualizujPunktyTotal(battleLogAC[0]["total"],battleLogAC[1]["total"]);
					
				//domination update
				battleDetails.aktualizujDominacje(battleVars);
				
				//battle orders
				this.battleCountries.showOrders(jsonData["campaigns"], this.battleVars);
				
				this.battleVars.attackerDominOld=this.battleVars.attackerDomin;
				this.battleVars.defenderDominOld=this.battleVars.defenderDomin;
				this.battleVars.defenderPercentOld=this.battleVars.defenderPercent;
				
				
				timerLabel.start();

			}
	 	   }catch(e:Error)
			{

				trace("sll"+ObjectUtil.toString(jsonData));
				this.battleCountries.showMessage("BS NotCorrect","BattleStats are not correct","warning");
			}  
			battleVars.licznikOdswierzen=battleVars.odIluOdliczacOdswierzenia;
			battleVars.czyMoznaOdswierzac=true;
			
		}
		
		
		private function readBattleLogError(param1:Event):void
		{
			trace('readBattleLogError');
			if(! this.first_login)                     //////////////////////////////sprawdzc
			{
				this.first_login = true;
				battleVars.licznikOdswierzen=2;
				battleVars.czyMoznaOdswierzac=true;
				
			}
			else
			{
			
				this.battleCountries.showMessage("BS Error!","BattleStats Error","warning");
				battleVars.licznikOdswierzen=battleVars.odIluOdliczacOdswierzenia;
				battleVars.czyMoznaOdswierzac=true;
			}
		}
		
		
		
		private function openUpdateWindow(event:Event):void{
			//	trace('openUpdateWindow');

			var anTW:AnimatedTitleWindow = new AnimatedTitleWindow(this.battleVars.odIluOdliczacOdswierzenia);
			anTW.title = "Choose update freq."
			anTW.showCloseButton = true;
			anTW.width=this.width;
			anTW.height=80;
			anTW.isPopUp=false;
			anTW.addEventListener(CloseEvent.CLOSE,onClose);
			anTW.addEventListener(ChangeRefreshEvent.MY_CUSTOM_EVENT,RefChange);
			
			PopUpManager.addPopUp(anTW,this);
			PopUpManager.centerPopUp(anTW);

		}
		
		public function onClose(event:Event):void
		{
			PopUpManager.removePopUp(AnimatedTitleWindow(anTW));
		}
		
		private function RefChange(event:ChangeRefreshEvent):void
		{
			
			this.battleVars.odIluOdliczacOdswierzenia=int(event.wybor);
			this.battleVars.licznikOdswierzen=0;
			PopUpManager.removePopUp(AnimatedTitleWindow(anTW));
			return;
			
		}// end function
		
		private function aktualizujPunktyTotal(atakujacyTotal:int,obroncaTotal:int):void
		{
			this.battleCountries.lblAttackTot.text=atakujacyTotal.toString();
			this.battleCountries.lblDefendTot.text=obroncaTotal.toString();
			
			if(atakujacyTotal>=83)finishBattle(true);
			if(obroncaTotal>=83)finishBattle(false);
			
		}
		private function finishBattle(isAttacker:Boolean):void
		{
			this.t1.stop();
			this.battleHeader.lblRefresh.visible=false;
			this.battleCountries.lblTime.text="Finished";
			if(isAttacker)this.battleDetails.finishBattleDet(this.battleVars.attacker);
			else this.battleDetails.finishBattleDet(this.battleVars.defender);
		}
		
		private function jumpToRegion(param1:Event):void
		{
			
			if(this.battleVars.region!='')navigateToURL(new URLRequest("http://www.erepublik.com/en/region/" + sf.spaceChange(this.battleVars.region)));

			return;
		}// end function
		
		private function id2country(country_id:int):String
		{
			var countries_arr:Array = new Array();
			countries_arr[167] = 'Albania';
			countries_arr[27] = 'Argentina'; 
			countries_arr[50] = 'Australia'; 
			countries_arr[33] = 'Austria'; 
			countries_arr[83] = 'Belarus'; 
			countries_arr[32] = 'Belgium'; 
			countries_arr[76] = 'Bolivia'; 
			countries_arr[69] = 'Bosnia and Herzegovina'; 
			countries_arr[9] = 'Brazil'; 
			countries_arr[42] = 'Bulgaria'; 
			countries_arr[23] = 'Canada'; 
			countries_arr[64] = 'Chile'; 
			countries_arr[14] = 'China'; 
			countries_arr[78] = 'Colombia'; 
			countries_arr[63] = 'Croatia'; 
			countries_arr[82] = 'Cyprus'; 
			countries_arr[34] = 'Czech Republic'; 
			countries_arr[55] = 'Denmark'; 
			countries_arr[165] = 'Egypt'; 
			countries_arr[70] = 'Estonia'; 
			countries_arr[39] = 'Finland'; 
			countries_arr[11] = 'France'; 
			countries_arr[12] = 'Germany'; 
			countries_arr[44] = 'Greece'; 
			countries_arr[13] = 'Hungary'; 
			countries_arr[48] = 'India'; 
			countries_arr[49] = 'Indonesia'; 
			countries_arr[56] = 'Iran'; 
			countries_arr[54] = 'Ireland'; 
			countries_arr[58] = 'Israel'; 
			countries_arr[10] = 'Italy'; 
			countries_arr[45] = 'Japan'; 
			countries_arr[71] = 'Latvia'; 
			countries_arr[72] = 'Lithuania'; 
			countries_arr[66] = 'Malaysia'; 
			countries_arr[26] = 'Mexico'; 
			countries_arr[80] = 'Montenegro'; 
			countries_arr[52] = 'Moldova';
			countries_arr[31] = 'Netherlands'; 
			countries_arr[84] = 'New Zealand'; 
			countries_arr[73] = 'North Korea'; 
			countries_arr[37] = 'Norway'; 
			countries_arr[57] = 'Pakistan'; 
			countries_arr[75] = 'Paraguay'; 
			countries_arr[77] = 'Peru'; 
			countries_arr[67] = 'Philippines'; 
			countries_arr[35] = 'Poland'; 
			countries_arr[53] = 'Portugal'; 
			countries_arr[81] = 'Republic of China (Taiwan)'; 
			countries_arr[79] = 'Republic of Macedonia (FYROM)'; 
			countries_arr[52] = 'Republic of Moldova'; 
			countries_arr[1] = 'Romania'; 
			countries_arr[41] = 'Russia'; 
			countries_arr[164] = 'Saudi Arabia'; 
			countries_arr[65] = 'Serbia'; 
			countries_arr[68] = 'Singapore'; 
			countries_arr[36] = 'Slovakia'; 
			countries_arr[61] = 'Slovenia'; 
			countries_arr[51] = 'South Africa'; 
			countries_arr[47] = 'South Korea'; 
			countries_arr[15] = 'Spain'; 
			countries_arr[38] = 'Sweden'; 
			countries_arr[30] = 'Switzerland'; 
			countries_arr[59] = 'Thailand'; 
			countries_arr[43] = 'Turkey'; 
			countries_arr[24] = 'USA'; 
			countries_arr[40] = 'Ukraine'; 
			countries_arr[166] = 'United Arab Emirates'; 
			countries_arr[29] = 'United Kingdom'; 
			countries_arr[74] = 'Uruguay'; 
			countries_arr[28] = 'Venezuela';
			
			return countries_arr[country_id];
		}

	}
}