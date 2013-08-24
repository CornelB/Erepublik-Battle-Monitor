package stratus
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.utils.Timer;
	
	import lib.MyMessage;
	
	
	public class StratusConnection extends EventDispatcher
	{
		private const SERVER:String = "rtmfp://stratus.adobe.com/";
		private const DEVKEY:String = "5cea326a0f17cf0496c1631e-38ff280b7826";
		[Bindable]
		private var nc:NetConnection;
		
		[Bindable]
		public var netGroup:NetGroup;
		
		[Bindable]
		public var connected:Boolean=false;
		
		[Bindable]
		private var _nearID:String;
		
		private var timer:Timer = new Timer(4000);
		
		
		
		
		public function StratusConnection()
		{
			
		}
		
		
		public function connect():void{
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS,netStatus);
			nc.maxPeerConnections=100;
			nc.connect(SERVER+DEVKEY);	
			
		}
		
		public function disconnect():void{
			nc.removeEventListener(NetStatusEvent.NET_STATUS,netStatus);
			nc.close();
		}
		
		
		private function setupGroup():void{
			
			var groupspec:GroupSpecifier = new GroupSpecifier("erep_bm");
			groupspec.serverChannelEnabled = true;
			groupspec.postingEnabled = true;
			
			netGroup = new NetGroup(nc,groupspec.groupspecWithAuthorizations());
			netGroup.addEventListener(NetStatusEvent.NET_STATUS,netStatus);
		}
		
		
		private function netStatus(event:NetStatusEvent):void{
			trace(event.info.code);
			
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					_nearID = nc.nearID;
					setupGroup();
					
					break;
				
				case "NetGroup.Connect.Success":
					
					connected = true;
					trace('connected');
					
					timer.addEventListener(TimerEvent.TIMER, netGroupIsConnected);
					timer.start();
					
					break;
				
				case "NetGroup.Posting.Notify":
					receiveMessage(new MyMessage(event.info.message.user,event.info.message.type,event.info.message.text,event.info.message.sender,event.info.message.color));
					break;
				// FYI: More NetGroup event info codes
				case "NetGroup.Neighbor.Connect":
					
				case "NetGroup.LocalCoverage.Notify":
				case "NetGroup.SendTo.Notify": // event.info.message, event.info.from, event.info.fromLocal
				case "NetGroup.MulticastStream.PublishNotify": // event.info.name
				case "NetGroup.MulticastStream.UnpublishNotify": // event.info.name
				case "NetGroup.Replication.Fetch.SendNotify": // event.info.index
				case "NetGroup.Replication.Fetch.Failed": // event.info.index
				case "NetGroup.Replication.Fetch.Result": // event.info.index, event.info.object
				case "NetGroup.Replication.Request": // event.info.index, event.info.requestID
				default:
				{
					break;
				}
			}
			
		}
		
		private function netGroupIsConnected(e:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER, netGroupIsConnected);
			timer.stop();
			
			var stratusConnectedEvent:StratusConnectedEvent = new StratusConnectedEvent(StratusConnectedEvent.STATUS_CONNECTED_EVENT);
			dispatchEvent(stratusConnectedEvent);
		}
		
		public function sendMessage(message:MyMessage):void
		{
			
			message.sender = netGroup.convertPeerIDToGroupAddress(nc.nearID);
			
			trace(message.user+' s '+message.text+' cr '+message.color);
			
			
			netGroup.post(message);
			receiveMessage(message);
			
		}
		
		private function receiveMessage(message:MyMessage):void{
			
			trace(message.user+' r '+message.text+' cr '+message.color);
			
			var messageEvent:NewMessageEvent = new NewMessageEvent(NewMessageEvent.NEW_MESSAGE_EVENT);
			messageEvent.msg=message;
			dispatchEvent(messageEvent);
			
		}
		
		
		
	}
}
