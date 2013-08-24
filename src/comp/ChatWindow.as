package comp
{
	import com.vibrantapps.comps.smileytextarea.SmileyPopup;
	import com.vibrantapps.comps.smileytextarea.SmileyTextArea;
	
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	
	import lib.MyMessage;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.containers.HDividedBox;
	import mx.controls.Button;
	import mx.controls.ColorPicker;
	import mx.controls.DataGrid;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Window;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.RichText;
	import spark.components.VGroup;
	
	import stratus.*;
	import events.*;
	
	
	public class ChatWindow extends Window
	{
		private var sc:StratusConnection;
		
		private var is_connected:Boolean = false;
		private var user_name:String;
		private var usersAC:ArrayCollection = new ArrayCollection();
		
		private var history_ta:SmileyTextArea;
		private var users_dg:DataGrid;
		private var message_ti:TextArea, name_ti:TextInput;
		private var global_hdb:HDividedBox;
		private var left_vg:VGroup, right_vg:VGroup;
		private var inputs_hg:HGroup, super_global_hg:HGroup, buttons_hg:HGroup;
		private var send_btn:Button, hide_btn:Button, clear_btn:Button, smile_btn:Button;
		private var myColor:ColorPicker;
		
		
		private var ping_timer:Timer = new Timer(30000);
		private var timeout:int = 35;
		private var mySo:SharedObject;
		
		
		public var popupWindowRoot:SmileyPopup;		
		public var popupVisible:Boolean =false;
		public var text_color:uint=0;
		
		[Embed(source='assets/lib.swf#smi_smile')] 
		private var smile_cls:Class; 
		
		
		private var not_readed:int = 0;
		
		public function ChatWindow(user_name:String)
		{
			this.showStatusBar = false;
			this.user_name = user_name;
			this.create_interface();
			
			popupWindowRoot= new SmileyPopup();
			popupWindowRoot.myParent=this;
			popupWindowRoot.myTextField=message_ti;
			
			this.esatblish_connection();
			this.addEventListener(Event.CLOSE,close_connection);
			this.addEventListener(MouseEvent.CLICK, reset_not_readed);			
		}
		
		
		private function close_connection(e:Event):void
		{
			this.stopTimers();
			sc.removeEventListener(StratusConnectedEvent.STATUS_CONNECTED_EVENT,stratus_is_connected);
			sc.removeEventListener(NewMessageEvent.NEW_MESSAGE_EVENT,read_new_message);
			sc.disconnect();
			
			
		}
		
		public function changeColor(event:Event):void {
			
			text_color = myColor.selectedColor;
			
			focus();
		}
		
		public function focus(): void {
			message_ti.setFocus();
			message_ti.selectionBeginIndex=message_ti.text.length;
			message_ti.selectionEndIndex=message_ti.text.length;
		}
		
		public function showPopup(event:MouseEvent):void {
			if (popupVisible) PopUpManager.removePopUp(popupWindowRoot);
			PopUpManager.addPopUp(popupWindowRoot,this,false);
			popupWindowRoot.move(event.target.x - 10, event.target.y-10);
			popupVisible=true;
			
		}
		
		public function hidePopup() :void {
			if (popupVisible) PopUpManager.removePopUp(popupWindowRoot);
			PopUpManager.addPopUp(popupWindowRoot,this,false);
		}
		
		public function typing(event:KeyboardEvent) : void {
			if (event.keyCode == 13) { 
				submitText();	
			}
		}
		
		private function submitText(event:MouseEvent = null) :void {
			if (message_ti.text=="") {
				message_ti.setFocus();
				return;
			}
			trace('message_ti.text:'+message_ti.text);
			var s:String = message_ti.text;
			var re: RegExp = new RegExp("\r|\n","gi");
			s = s.replace(re,"");
			
			message_ti.text="";
			
			send_msg(s);
			trace('wysylam: '+s);
		}
		
		
		private function addReceivedText(s:String):void
		{
			/*var re: RegExp = new RegExp("\r|\n","gi");
			s = s.replace(re,"");*/
			
			//and submit to server
			history_ta.addText(s);
			trace('dodaje: '+s);
		}
		
		private function clear(event:MouseEvent = null) : void {
			history_ta.clear(true);
		}
		
		private function toggleSize() : void {
			if (history_ta.width==465) {
				history_ta.setActualSize(300,200);
			} else {
				history_ta.setActualSize(465,295);
			}
		}
		
		private function start():void
		{
			
			this.user_name = 'anonym'+Math.round(Math.random()*1000);
			try
			{
				mySo = SharedObject.getLocal("chat");
				if(mySo.data.user_name)
				{
					this.user_name = mySo.data.user_name;
					trace('name: '+mySo.data.user_name);
				}
				if(mySo.data.text_color)
				{
					this.text_color = mySo.data.text_color;
					
					trace('col: '+mySo.data.text_color);
				}
				
				
			}
			catch(e:Error)
			{
				trace('cant read '+e.toString());
			}
			this.create_interface();
			
			popupWindowRoot= new SmileyPopup();
			popupWindowRoot.myParent=this;
			popupWindowRoot.myTextField=message_ti;
			
			
			this.esatblish_connection();
			
		}
		
		
		
		
		private function addToUsers(name:String, sender:String="nie ma sendera"):void
		{
			var at_list:Boolean=false;
			var dateNow:Date = new Date(); 
			var i:int = 0;
			//trace(i+' '+dateNow.time);
			var obj:Object=new Object(), sen:Object=new Object();
			var sort:Sort = new Sort(); 
			
			for each (sen in usersAC)
			{
				//trace(i+' '+sen.timeout+' '+dateNow.time);
				if(sen.timeout < dateNow.time)
				{
					addReceivedText(getTime()+" <i>"+sen.name+' has left the room</i>'); 
					
					this.usersAC.removeItemAt(i);
					this.usersAC.refresh();
					
				}
				i++;
			}
			
			i=0;
			for each (sen in usersAC)
			{
				if(sen.sender==sender)
				{
					//trace(i+' '+sen.sender+' = ');
					at_list = true;
					obj = this.usersAC.getItemAt(i);
					obj.timeout = dateNow.time+this.timeout*1000;
					obj.name = name;
					this.usersAC.setItemAt(obj,i);
					
					sort.fields = [ new SortField("name", false) ]; 
					usersAC.sort = sort; 
					this.usersAC.refresh();
				}
				//else trace(i+' '+sen.sender+' != ');
				
				
				i++;
			}
			
			if(!at_list)
			{
				//trace(' '+name+' not at list ');
				obj.name = name;
				obj.sender = sender;
				
				
				obj.timeout = dateNow.time+this.timeout*1000;
				
				this.usersAC.addItem(obj);
				
				
				
				sort.fields = [ new SortField("name", false) ]; 
				usersAC.sort = sort; 
				usersAC.refresh();
			}
			
			this.title='Chat ('+usersAC.length+')';
			var chatUsersEvent:ChatUsersEvent = new ChatUsersEvent(ChatUsersEvent.CHAT_USERS_EVENT);
			chatUsersEvent.numer_of_users = usersAC.length;
			dispatchEvent(chatUsersEvent);
			
		}
		
		private function esatblish_connection(e:Event = null):void
		{
			sc = new StratusConnection();
			sc.addEventListener(StratusConnectedEvent.STATUS_CONNECTED_EVENT,stratus_is_connected);
			sc.addEventListener(NewMessageEvent.NEW_MESSAGE_EVENT,read_new_message);
			sc.connect();
		}
		
		private function stratus_is_connected(e:StratusConnectedEvent):void
		{
			this.is_connected = true;
			
			this.sc.sendMessage(new MyMessage(this.user_name,'enter',''));
			
			ping_timer.addEventListener(TimerEvent.TIMER, send_ping);
			ping_timer.start();
			
		}
		
		private function send_ping(e:TimerEvent):void
		{
			if(is_connected)
			{
				try{
					this.sc.sendMessage(new MyMessage(this.user_name,'ping',''+Math.random()));
				}catch(e:Error)
				{
					this.sending_error();
				}
			}
		}
		private function new_not_readed():void
		{
			this.not_readed++;
			
			var notReadedMessageEvent:NotReadedMessageEvent = new NotReadedMessageEvent(NotReadedMessageEvent.NOT_READED_MESSAGE_EVENT);
			notReadedMessageEvent.n_r_m_count = this.not_readed;
			dispatchEvent(notReadedMessageEvent);
		}
		
		
		private function read_new_message(e:NewMessageEvent):void
		{
			
			e.msg.user = parse(e.msg.user);
			e.msg.text = parse(e.msg.text);
			
			
			if(e.msg.type == 'enter')
				addReceivedText(getTime()+" <i>"+e.msg.user+' has joined the room</i>');
			
			if(e.msg.type == "chat")
			{
				
				//addReceivedText(getTime()+' <b>'+e.msg.user+":</b> "+e.msg.text);
				addReceivedText("<font color='#" +  e.msg.color.toString(16) +"'>"+getTime()+' '+e.msg.user+': '+e.msg.text+'</font>');
				new_not_readed();
			}
			
			addToUsers(e.msg.user,e.msg.sender);
			
			//validateNow();
			
			
			trace('rec:'+e.msg.type+' from:'+e.msg.user+' msg:'+e.msg.text);
		} 
		
		
		private function reset_not_readed(event:Event = null):void
		{
			this.not_readed = 0;
			
			var notReadedMessageEvent:NotReadedMessageEvent = new NotReadedMessageEvent(NotReadedMessageEvent.NOT_READED_MESSAGE_EVENT);
			notReadedMessageEvent.n_r_m_count = this.not_readed;
			dispatchEvent(notReadedMessageEvent);
			
			
		}
		
		private function sending_error():void
		{
			/*this.connected_img.source = this.not_connected;
			this.connected_img.buttonMode = true;
			this.connected_img.addEventListener(MouseEvent.CLICK, this.esatblish_connection);*/
		}
		
		
		
		private function create_interface():void
		{
			
			this.height = 360;
			this.width = 480;
			

			this.global_hdb = new HDividedBox();
			this.global_hdb.percentWidth = 100;
			this.global_hdb.percentHeight = 100;
			this.global_hdb.bottom = 3;
			this.global_hdb.top = 3;
			this.global_hdb.left = 3;
			this.global_hdb.right = 3;
			
			this.left_vg = new VGroup();
			this.left_vg.percentHeight = 100;
			this.left_vg.percentWidth = 70;
			
			this.right_vg = new VGroup();
			this.right_vg.percentHeight = 100;
			this.right_vg.percentWidth = 30;
			
			this.history_ta = new SmileyTextArea();
			this.history_ta.styleName = 'fwnormal';
			//this.history_ta.editable = false;
			
			this.history_ta.percentWidth = 100;
			this.history_ta.percentHeight = 100;
			
			this.left_vg.addElement(this.history_ta);
			
			var dgc:DataGridColumn = new DataGridColumn('name');
			dgc.dataField = 'name';
			/*	
			var dgc2:DataGridColumn = new DataGridColumn('sender');
			dgc2.dataField = 'sender';
			*/
			/*	var dgc3:DataGridColumn = new DataGridColumn('timeout');
			dgc3.dataField = 'timeout';
			*/
			var cols:Array = new Array(dgc);
			
			this.users_dg = new DataGrid;
			
			this.users_dg.showHeaders = false;
			this.users_dg.percentWidth = 100;
			this.users_dg.percentHeight = 100;
			this.users_dg.dataProvider = usersAC;
			this.users_dg.columns = cols;
			
			this.right_vg.addElement(this.users_dg);
			
			this.buttons_hg = new HGroup();
			this.buttons_hg.percentWidth = 100;
			
			this.myColor = new ColorPicker();
			this.myColor.percentWidth = 49; 
			this.myColor.selectedColor = this.text_color;
			this.myColor.addEventListener(Event.CLOSE, changeColor);
			this.buttons_hg.addElement(myColor);
			
			this.smile_btn = new Button();
			this.smile_btn.percentWidth = 49; 
			
			this.smile_btn.setStyle("icon", smile_cls);
			this.smile_btn.addEventListener(MouseEvent.CLICK,showPopup);
			this.buttons_hg.addElement(this.smile_btn);
			
			this.right_vg.addElement(buttons_hg);
			
			this.buttons_hg = new HGroup();
			this.buttons_hg.percentWidth = 100; 
			
	/*		this.send_btn = new Button();
			this.send_btn.percentWidth = 49; 
			this.send_btn.label = 'Send';
			//this.send_btn.addEventListener(MouseEvent.CLICK,send_msg);
			this.send_btn.addEventListener(MouseEvent.CLICK,submitText);
			this.buttons_hg.addElement(this.send_btn);*/
			
			this.clear_btn = new Button();
			this.clear_btn.percentWidth = 49; 
			this.clear_btn.label = 'Clear';
			this.clear_btn.addEventListener(MouseEvent.CLICK,clear);
			this.buttons_hg.addElement(this.clear_btn);
			
			this.hide_btn = new Button();
			this.hide_btn.percentWidth = 49; 
			this.hide_btn.label = 'Hide';

			this.hide_btn.addEventListener(MouseEvent.CLICK,hide_window);
			this.buttons_hg.addElement(this.hide_btn);
			
			
			this.right_vg.addElement(buttons_hg);
			
			
			this.message_ti = new TextArea();
			this.message_ti.height = 22;
			this.message_ti.percentWidth = 100;
			this.message_ti.addEventListener(KeyboardEvent.KEY_UP,typing);
			
			this.left_vg.addElement(this.message_ti);
			
			this.global_hdb.addElement(this.left_vg);
			this.global_hdb.addElement(this.right_vg);
			
			this.addElement(this.global_hdb);

		}
		
		
		private function send_msg(msg:String):void
		{
			try{
				trace('send_msg:'+myColor.selectedColor.toString());
				this.sc.sendMessage(new MyMessage(this.user_name,'chat',msg,'sender',text_color));
				reset_not_readed();
			}catch(e:Error)
			{
				this.sending_error();
			}
		}
		
		
		
		private function getTime():String
		{
			var now:Date = new Date(); 
			var h:int = now.hours; 
			var m:int = now.minutes;
			var min:String = ''+m;
			if (m<10)min = '0'+m;
			var s:int = now.seconds;
			var sek:String = ''+s;
			if (s<10)sek = '0'+s;
			return h+':'+min+':'+sek;
			
		}
		
		public function parse(s : String='') : String {
			
			var removeHtmlRegExp:RegExp = new RegExp("<[^<]+?>", "gi");
			
			s = s.replace(removeHtmlRegExp, "");
			/*
			for each(var em:XML in this.emotyXML.r)
			{
			s = s.replace(em.z, '<img src="http://rlip.linuxpl.info/gu/chat/emoty/'+(em.p)+'.gif">');
			}
			
			*/
			/*
			var bold : RegExp = /\[b\](.*?)\[\/b\]/gi;
			var italic : RegExp = /\[i\](.*?)\[\/i\]/gi;
			var underline : RegExp = /\[u\](.*?)\[\/u\]/gi;
			///var img : RegExp = /\[img](.*?)\[\/img\]/gi;
			var url1 : RegExp = /\[url\](.*?)\[\/url\]/gi;
			var url2 : RegExp = /\[url=(.*?)\](.*?)\[\/url\]/gi;
			var color : RegExp = /\[color=(.*?)\](.*?)\[\/color\]/gi;
			var size : RegExp = /\[size=(.*?)\](.*?)\[\/size\]/gi;      
			var search : Array = new Array(bold, italic, underline, url1, url2, color, size);
			var replace : Array = new Array("<b>$1</b>", "<i>$1</i>", "<u>$1</u>", "<a href='$1'>$1</a>", "<a href='$1'>$2</a>", "<font color='$1'>$2</font>", "<font size='$1'>$2</font>");
			
			for (var i : int = 0;i < search.length; i++) {
			s = s.replace(search[i], replace[i]);
			}*/
			return s;
		}
		
		private function stopTimers(e:Event=null):void
		{
			ping_timer.stop();
			ping_timer.removeEventListener(TimerEvent.TIMER,send_ping);
			ping_timer=null;
			
		}
		
		private function hide_window(e:MouseEvent):void
		{
			this.visible = false;	
		}
		
		public function change_nick(nick:String):void
		{
			
			this.user_name = nick;
			this.sc.sendMessage(new MyMessage(this.user_name,'ping',''));
		}
		
		
		
		
	}
}