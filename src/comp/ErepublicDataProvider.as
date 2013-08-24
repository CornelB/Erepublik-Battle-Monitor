package comp
{
	import events.ErepublikDataProviderEvent;
	
	import flash.events.Event;

	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import mx.core.UIComponent;
	

	public class ErepublicDataProvider extends UIComponent
	{
		public var email:String, pass:String;
		public var bsurl:String;
		
		public var use_xampp:Boolean;
		
		public function ErepublicDataProvider(email:String = '', pass:String = '', bsurl:String = 'http://localhost/battle-stats.php', use_xampp:Boolean = false)
		{
			this.email = email;
			this.pass = pass;
			this.bsurl = bsurl;
			this.use_xampp = use_xampp;
		}
		
		public function changeData(email:String = '', pass:String = '', bsurl:String = 'http://localhost/battle-stats.php', use_xampp:Boolean = false):void
		{
			this.email = email;
			this.pass = pass;
			this.bsurl = bsurl;
			this.use_xampp = use_xampp;
		}
		
		public function getActiveBattles():void
		{
			var _loc_1:URLLoader = new URLLoader();
			
			if(this.use_xampp)
			{
				_loc_1.load(new URLRequest(this.bsurl + "?campaigns=1"));
				_loc_1.addEventListener(Event.COMPLETE, getActiveBattles2Complete);
			}
			else 
			{
				_loc_1.load(new URLRequest("http://www.erepublik.com/en"));
				_loc_1.addEventListener(Event.COMPLETE, getActiveBattles2Step1);
				
			}
		}
		
		private function getActiveBattles2Step1(param1:Event) : void
		{
			var pattern:RegExp = /name="_token" value="([a-z0-9]+)"/i;
			
			var regex_token:Array = pattern.exec(param1.currentTarget.data);

			
			var request:URLRequest = new URLRequest("http://www.erepublik.com/en/login");
			
			request.data = '_token='+regex_token[1]+'&citizen_email='+this.email+'&citizen_password='+this.pass+'&commit=Login';
			request.method = URLRequestMethod.POST;
			
			var _loc_1:* = new URLLoader();
			_loc_1.load(request);
			_loc_1.addEventListener(Event.COMPLETE, getActiveBattles2Step2);
			
		}
		
		private function  getActiveBattles2Step2(param1:Event) : void
		{
			var _loc_1:* = new URLLoader();
			_loc_1.load(new URLRequest("http://www.erepublik.com/en/military/campaigns"));
			_loc_1.addEventListener(Event.COMPLETE, this.getActiveBattles2Complete);
			
		}
		
		private function  getActiveBattles2Complete(param1:Event) : void
		{
			var edpEvent:ErepublikDataProviderEvent = new  ErepublikDataProviderEvent( ErepublikDataProviderEvent.EDP_EVENT);
			edpEvent.data = param1.currentTarget.data
			dispatchEvent(edpEvent);
		
		}
		
		
	}
}