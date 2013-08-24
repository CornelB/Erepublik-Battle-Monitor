package comp
{
	import events.SaveSettingsEvent;
	
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.core.Window;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.DropDownList;
	import spark.components.Label;
	import spark.components.NumericStepper;
	import spark.components.RadioButton;
	import spark.components.TextInput;

	public class SettingsWindow extends Window
	{
		
		private var btn_close:Button,btn_save:Button;
		private var lbl_title:Label,lbl_drr:Label,lbl_country:Label,lbl_MainWindowMaxHeight:Label,lbl_ActiveBattlesMaxHeight:Label,lbl_bsurl:Label,lbl_userID:Label,lbl_nick:Label;
		private var ddl_country:ComboBox,ddl_drr:DropDownList;
		private var tin_bsurl:TextInput,tin_nick:TextInput,tin_email:TextInput,tin_pass:TextInput;
		private var countries_arl:ArrayList,drr_arl:ArrayList;
	//	private var country_name:String,mwog:int,mwab:int,drr:int;
		private var ns_MainWindowMaxHeight:NumericStepper,ns_ActiveBattlesMaxHeight:NumericStepper,ns_userID:NumericStepper;
		private var use_server_rb:RadioButton, use_login_rb:RadioButton;
	//	private var czy_server:Boolean;
		private var chb_chat_autostart:CheckBox;
		private var sv:SettingsVars;
		private var drr_arr:Array = new Array(		
			"3",
			"6",
			"10",
			"15",
			"20",
			"30",
			"60",
			"120",
			"300"
		);
		private var countries_arr:Array = new Array(
			"Albania",
			"Argentina", 
			"Australia", 
			"Austria", 
			"Belarus", 
			"Belgium", 
			"Bolivia", 
			"Bosnia and Herzegovina", 
			"Brazil", 
			"Bulgaria", 
			"Canada", 
			"Chile", 
			"China", 
			"Colombia", 
			"Croatia", 
			"Cyprus", 
			"Czech Republic", 
			"Denmark", 
			"Egypt", 
			"Estonia", 
			"Finland", 
			"France", 
			"Germany", 
			"Greece", 
			"Hungary", 
			"India", 
			"Indonesia", 
			"Iran", 
			"Ireland", 
			"Israel", 
			"Italy", 
			"Japan", 
			"Latvia", 
			"Lithuania", 
			"Malaysia", 
			"Mexico", 
			"Montenegro", 
			"Netherlands", 
			"New Zealand", 
			"North Korea", 
			"Norway", 
			"Pakistan", 
			"Paraguay", 
			"Peru", 
			"Philippines", 
			"Poland", 
			"Portugal", 
			"Republic of China (Taiwan)", 
			"Republic of Macedonia (FYROM)", 
			"Republic of Moldova", 
			"Romania", 
			"Russia", 
			"Saudi Arabia", 
			"Serbia", 
			"Singapore", 
			"Slovakia", 
			"Slovenia", 
			"South Africa", 
			"South Korea", 
			"Spain", 
			"Sweden", 
			"Switzerland", 
			"Thailand", 
			"Turkey", 
			"USA", 
			"Ukraine", 
			"United Arab Emirates", 
			"United Kingdom", 
			"Uruguay", 
			"Venezuela");

		
		public function SettingsWindow(sv:SettingsVars)
		{
			this.systemChrome=NativeWindowSystemChrome.STANDARD;
			//this.showTitleBar = false;
			this.showStatusBar = false;
			this.width = 270;
			this.height = 370;
			this.type = NativeWindowType.UTILITY;
			this.title="Settings";
			
			this.layout="absolute";
			this.resizable=false;
			this.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
			
			this.sv=sv;


			lbl_nick = new Label();
			lbl_nick.text = 'Nick:';
			lbl_nick.setStyle("fontSize",12); 
			lbl_nick.y = 17;
			lbl_nick.x = 10;
			lbl_nick.toolTip="Your chat nickname";
			this.addChild(lbl_nick);
			
			tin_nick = new TextInput();
			tin_nick.text=sv.nick;
			tin_nick.y = 10;
			tin_nick.width = 195;
			tin_nick.right = 10;
			tin_nick.toolTip="Your chat nickname";
			this.addChild(tin_nick);
			
			chb_chat_autostart = new CheckBox();
			chb_chat_autostart.selected = this.sv.chat_autostart;
			chb_chat_autostart.label = "Run chat on BM start";
			chb_chat_autostart.y = 35;
			chb_chat_autostart.x = 65;
			this.addChild(chb_chat_autostart);
			
			lbl_country = new Label();
			lbl_country.text = 'Country:';
			lbl_country.setStyle("fontSize",12); 
			lbl_country.y = 67;
			lbl_country.x = 10;
			this.addChild(lbl_country);
			
			ddl_country = new ComboBox();
			ddl_country.y = 60;
			ddl_country.right = 10;
			ddl_country.width = 195;
			ddl_country.setStyle("fontWeight","bold");
			countries_arl= new ArrayList(countries_arr);
			ddl_country.dataProvider=countries_arl;
			
			var i:int;
			for(i=0;i<countries_arr.length;i++)if(countries_arr[i]==this.sv.country_name)break;
			
			ddl_country.selectedIndex=i;  				
			this.addChild(ddl_country);
			
			lbl_userID = new Label();
			lbl_userID.text = 'User ID:';
			lbl_userID.setStyle("fontSize",12); 
			lbl_userID.y = 97;
			lbl_userID.x = 10;
			lbl_userID.toolTip="It's using for mark your damage";
			this.addChild(lbl_userID);
			
			
			ns_userID = new NumericStepper();
			ns_userID.minimum=0;
			ns_userID.maximum=9999999;
			ns_userID.y=90;
			ns_userID.right=10;
			ns_userID.value=sv.userID;
			ns_userID.width=195;
			ns_userID.toolTip="It's using for mark your damage";
			this.addChild(ns_userID);
			
			var lbl_use_server:Label = new Label();
			lbl_use_server.text = 'Use BS URL';
			lbl_use_server.setStyle("fontSize",12); 
			lbl_use_server.y = 127;
			lbl_use_server.x = 30;
			this.addChild(lbl_use_server);
			
			this.use_server_rb = new RadioButton();
			use_server_rb.groupName = 'server_type';
			use_server_rb.y=127;
			use_server_rb.x=10;
			use_server_rb.selected = sv.use_xampp;
			use_server_rb.addEventListener(Event.CHANGE,server_type_change);
			this.addChild(use_server_rb);
			
			var lbl_use_login:Label = new Label();
			lbl_use_login.text = 'Use Email & Pass';
			lbl_use_login.setStyle("fontSize",12); 
			lbl_use_login.y = 127;
			lbl_use_login.horizontalCenter = 60;
			this.addChild(lbl_use_login);
			
			this.use_login_rb = new RadioButton();
			use_login_rb.groupName = 'server_type';
			use_login_rb.y=127;
			use_login_rb.selected = !sv.use_xampp;
			use_login_rb.horizontalCenter=0;
			use_login_rb.addEventListener(Event.CHANGE,server_type_change);
			this.addChild(use_login_rb);
			
			lbl_bsurl = new Label();
			lbl_bsurl.text = 'BS URL:';
			lbl_bsurl.setStyle("fontSize",12); 
			lbl_bsurl.y = 157;
			lbl_bsurl.x = 10;
			lbl_bsurl.toolTip="battle-stats url e.g. http://localhost/battle-stats.php";
			this.addChild(lbl_bsurl);
			
			tin_bsurl = new TextInput();
			tin_bsurl.text=sv.bsurl;
			tin_bsurl.enabled = sv.use_xampp;
			tin_bsurl.y = 150;
			tin_bsurl.width = 195;
			tin_bsurl.right = 10;
			tin_bsurl.toolTip="battle-stats url e.g. http://localhost/battle-stats.php";
			this.addChild(tin_bsurl);
			
			var lbl_email:Label = new Label();
			lbl_email.text = 'Email:';
			lbl_email.setStyle("fontSize",12); 
			lbl_email.y = 187;
			lbl_email.x = 10;
			lbl_email.toolTip="Erep email";
			this.addChild(lbl_email);
			
			tin_email = new TextInput();
			tin_email.text=sv.email;
			tin_email.y = 180;
			tin_email.width = 195;
			tin_email.right = 10;
			tin_email.enabled = !sv.use_xampp;
			tin_email.toolTip="Erep email";
			this.addChild(tin_email);
			
			var lbl_pass:Label = new Label();
			lbl_pass.text = 'Pass:';
			lbl_pass.setStyle("fontSize",12); 
			lbl_pass.y = 217;
			lbl_pass.x = 10;
			lbl_pass.toolTip="Erep pass";
			this.addChild(lbl_pass);
			
			tin_pass = new TextInput();
			tin_pass.text=sv.pass;
			tin_pass.y = 210;
			tin_pass.width = 195;
			tin_pass.right = 10;
			tin_pass.displayAsPassword=true;
			tin_pass.enabled = !sv.use_xampp;
			tin_pass.toolTip="Erep pass";
			this.addChild(tin_pass);
			

			lbl_drr = new Label();
			lbl_drr.text = 'Default refresh rate [s]:';
			lbl_drr.setStyle("fontSize",12); 
			lbl_drr.y = 247;
			lbl_drr.x = 10;
			this.addChild(lbl_drr);
			
			ddl_drr = new DropDownList();
			ddl_drr.setStyle("fontWeight","bold");
			ddl_drr.y = 240;
			ddl_drr.right = 10;
			ddl_drr.width = 80;
			drr_arl= new ArrayList(drr_arr);
			ddl_drr.dataProvider=drr_arl;
			
			
			for(i=0;i<drr_arr.length;i++)if(int(drr_arr[i])==this.sv.default_refresh_rate)break;
			
			ddl_drr.selectedIndex=i;  				
			this.addChild(ddl_drr);
			
			lbl_MainWindowMaxHeight = new Label();
			lbl_MainWindowMaxHeight.text = 'Main window max height [px]:';
			lbl_MainWindowMaxHeight.setStyle("fontSize",12); 
			lbl_MainWindowMaxHeight.x = 10;
			lbl_MainWindowMaxHeight.y = 277;
			this.addChild(lbl_MainWindowMaxHeight);
			
			ns_MainWindowMaxHeight = new NumericStepper();
			ns_MainWindowMaxHeight.minimum=120;
			ns_MainWindowMaxHeight.maximum=1600;
			ns_MainWindowMaxHeight.y=270;
			ns_MainWindowMaxHeight.right=10;
			ns_MainWindowMaxHeight.value=this.sv.main_window_max_height;
			ns_MainWindowMaxHeight.width = 50;
			this.addChild(ns_MainWindowMaxHeight);
			
			
			lbl_ActiveBattlesMaxHeight = new Label();
			lbl_ActiveBattlesMaxHeight.text = 'Active battles max height [px]:';
			lbl_ActiveBattlesMaxHeight.setStyle("fontSize",12); 
			lbl_ActiveBattlesMaxHeight.x = 10;
			lbl_ActiveBattlesMaxHeight.y = 307;
			this.addChild(lbl_ActiveBattlesMaxHeight);
			
			ns_ActiveBattlesMaxHeight = new NumericStepper();
			ns_ActiveBattlesMaxHeight.minimum=120;
			ns_ActiveBattlesMaxHeight.maximum=1600;
			ns_ActiveBattlesMaxHeight.y=300;
			ns_ActiveBattlesMaxHeight.right=10;
			ns_ActiveBattlesMaxHeight.value=this.sv.active_battles_max_height;
			ns_ActiveBattlesMaxHeight.width=50;
			this.addChild(ns_ActiveBattlesMaxHeight);
			
			btn_save = new Button();
			btn_save.label='Save';
			btn_save.y = 340;
			btn_save.width = 70;
			btn_save.horizontalCenter = -50;
			btn_save.addEventListener(MouseEvent.CLICK,save);
			this.addChild(btn_save);
			
			btn_close = new Button();
			btn_close.label='Cancel';
			btn_close.y = 340;
			btn_close.width = 70;
			btn_close.horizontalCenter = 50;
			btn_close.addEventListener(MouseEvent.CLICK,closeWindow);
			this.addChild(btn_close);
			
			
		}
		
		private function server_type_change(e:Event):void
		{
				this.sv.use_xampp = !this.sv.use_xampp;
				this.tin_email.enabled = !this.sv.use_xampp;
				this.tin_pass.enabled = !this.sv.use_xampp;
				this.tin_bsurl.enabled = this.sv.use_xampp;

		}
		
		private function closeWindow(param1:MouseEvent):void
		{
			this.close();
		}
		
		private function moveWindow(e:MouseEvent):void
		{
				
			if(e.target is SettingsWindow || e.target is Label)	
				this.stage.nativeWindow.startMove();

	
		}
		
		private function save(param1:MouseEvent):void
		{
			var saveEvent:SaveSettingsEvent = new SaveSettingsEvent(SaveSettingsEvent.SAVE_SETTINGS_EVENT);

			this.sv.country_name=String(ddl_country.selectedItem);
			this.sv.active_battles_max_height=this.ns_ActiveBattlesMaxHeight.value;
			this.sv.main_window_max_height=this.ns_MainWindowMaxHeight.value;
			this.sv.default_refresh_rate=int(this.ddl_drr.selectedItem);
			this.sv.bsurl=this.tin_bsurl.text;
			this.sv.userID=this.ns_userID.value;
			this.sv.nick=this.tin_nick.text;
			this.sv.email = this.tin_email.text;
			this.sv.pass = this.tin_pass.text;
			this.sv.chat_autostart = chb_chat_autostart.selected;
			saveEvent.sv=this.sv;
			dispatchEvent(saveEvent);
			this.close();
		}
	}
}