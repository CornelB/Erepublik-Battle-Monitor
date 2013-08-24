package comp
{
	[RemoteClass]
	public class SettingsVars
	{
		public var use_xampp:Boolean,chat_autostart:Boolean;
		public var country_name:String,bsurl:String,nick:String,email:String,pass:String;
		public var active_battles_max_height:int, main_window_max_height:int,default_refresh_rate:int,userID:int;

		public var active_battles_x:int=200,active_battles_y:int=50,main_window_x:int=50,main_window_y:int=50;
		public var ns_battle_id:int=99999;
		
		public function SettingsVars(use_xampp:Boolean=false,chat_autostart:Boolean=false,country_name:String='Poland',bsurl:String='http://localhost/battle-stats.php',nick:String='anonym',email:String='',pass:String='',active_battles_max_height:int=500, main_window_max_height:int=500,default_refresh_rate:int=60,userID:int=0)
		{
			this.use_xampp=use_xampp;
			this.chat_autostart=chat_autostart;
			this.country_name=country_name;
			this.bsurl=bsurl;
			this.nick=nick;
			this.email=email;
			this.pass=pass;
			this.active_battles_max_height=active_battles_max_height;
			this.main_window_max_height=main_window_max_height;
			this.default_refresh_rate=default_refresh_rate;
			this.userID=userID;
		}
	}
}