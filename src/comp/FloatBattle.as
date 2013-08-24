package comp
{
	import events.ErepublikDataProviderEvent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.core.Window;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	public class FloatBattle extends Window
	{
		private var vbox1:VBox=new VBox();
		private var battleXML:XML;
		private var bil:Array=new Array();
		
		[Bindable]
		private var myBattleXML:ArrayCollection;
		//private var battlesURL:String;
		
		//private var email:String,pass:String;
		
	
		
		public function FloatBattle(edp:ErepublicDataProvider)
		{

			//mx_internal::_document = this;
			var fedp:ErepublicDataProvider = new ErepublicDataProvider(edp.email, edp.pass, edp.bsurl, edp.use_xampp);

			this.showStatusBar = false;
			this.maximizable = false;
			this.minimizable = false;

			this.horizontalScrollPolicy="off";

			
			vbox1.verticalScrollPolicy="off";
			vbox1.styleName="containerVBox";
			this.addChild(vbox1);

			fedp.addEventListener(ErepublikDataProviderEvent.EDP_EVENT, this.getActiveBattles2Complete);
			fedp.getActiveBattles();
			return;
		}// end function
		

		private function  getActiveBattles2Complete(param1:ErepublikDataProviderEvent) : void
		{
			//trace('region'+param1.currentTarget.data);

			var battles:Array = new Array();
			
			var pattern:RegExp = new RegExp('[<li class="mpp"|<li] id="battle-(.+?)<\/li>','gm');
			var str:String = param1.data;
			
			var result:Array = pattern.exec(str);
			
			while (result != null) {
		//	 trace (result.index, "\t", result[1]);
			
			var pattern2:RegExp = new RegExp('(.+?)">');
			var bid:Array = pattern2.exec(result[1]);
			
			
			pattern2 = /<span>(.+?)<\/span>/;
			var region:Array = pattern2.exec(result[1]);
			

			pattern2 = /resistance_sign/;
			var rw:Boolean = pattern2.test(result[1]);
			
			pattern2 = /alt="(.+?)" title="/g;
			var att:Array = pattern2.exec(result[1]);
			
			
			
			pattern2 = /.png" title="(.+?)"/g;
			var def:Array =  pattern2.exec(result[1]);
			while (att[1]==def[1]){
				def =  pattern2.exec(result[1]);
			}
			//trace (def[1]);
			
			//vbox1.addChild(bil[bil.push(new BattleInList(170,38,bid[1],region[1],att[1],def[1],rw))-1]);

			
			
			battles.push({bid:bid[1],region:region[1],att:att[1],def:def[1],rws:rw});

			result = pattern.exec(str);
		}
			battles.sortOn("bid", Array.DESCENDING); 
			
		for (var i:int = 0; i < battles.length; ++i) 
		{ 
			if(!battles[i].rws)
			vbox1.addChild(new BattleInList(170,38,battles[i].bid,battles[i].region,battles[i].att,battles[i].def,battles[i].rws));
		}
		for (i = 0; i < battles.length; ++i) 
		{ 
			if(battles[i].rws)
				vbox1.addChild(new BattleInList(170,38,battles[i].bid,battles[i].region,battles[i].att,battles[i].def,battles[i].rws));
		}
		
		this.height=(vbox1.numChildren)*38+2;
		if(this.height>=this.maxHeight)this.width=187;
		this.title="Active battles: "+vbox1.numChildren;

		}
	

		private function activeBattlesError(param1:Event):void
		{
			trace('activeBattlesError');
		}
		

	}
}
