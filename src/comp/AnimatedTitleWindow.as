package comp
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.containers.TitleWindow;
    import mx.controls.Image;
    import mx.effects.Effect;
    import mx.effects.Iris;
    import mx.effects.Move;
    import mx.effects.Resize;
    import mx.events.CloseEvent;
    import mx.events.EffectEvent;
    import mx.events.ItemClickEvent;
    
    import spark.components.RadioButton;
    import spark.components.RadioButtonGroup;
    import events.ChangeRefreshEvent;
	
	public class AnimatedTitleWindow extends TitleWindow
	{
		
		
		/**
		 * the AnimatedTitleWindow class allows users to specify animations for opening a pop up/title window as well as when it is closed
		 */
		
		/**
		 * @private the start effect
		 */
		private var openEffect:Effect;
		
		/**
		 * @private the end effect
		 */
		private var closeEffect:Effect;
		
		/**
		 * @private the open duration
		 */
		private var defaultOpenDuration:int;
		
		/**
		 * @private the close duration
		 */
		private var defaultCloseDuration:int;
		
		
		/**
		 * @private nWidth
		 */
		private var w:Number;
		
		/**
		 * @private the height
		 */
		private var h:Number;
		private var odIlu:int;
		/**
		 * constructor
		 * @param effect the effect that the pop up will use to animate the opening of the title window
		 * @param closeEffect the effect that the pop up will use when closing
		 * @param openDuration the duration for the opening effect if it has not been set on the openEffect
		 * @param closeDuration the duration of the close effect if it has not been set;
		 * both parameters are defaulted to null and if either is null the default behavior will animate the title window on open and close
		 * when the component animates itself closing it will reverse the close effect so if you use a wipe effect it will
		 * do the exact opposite, e.g. a WipeUpInstance will behave like a WipeDown
		 */
		public function AnimatedTitleWindow(odIlu:int,defaultOpenDuration:int =  500, defaultCloseDuration:int = 500)
		{
			
			//call the base class constructor

			super();
			this.odIlu=odIlu;
			//set the instance vars
			try
			{
				this.defaultOpenDuration = defaultOpenDuration;
				this.defaultCloseDuration = defaultCloseDuration;
				openEffect == null ? setOpenEffectDefault() : this.openEffect = openEffect;
				closeEffect == null ? setCloseEffectDefault() : this.closeEffect = closeEffect;
				//play the effect
				this.openEffect.play([this]);
				//add the event listener for the close
				this.addEventListener(CloseEvent.CLOSE,onClose); 
			}
			catch(error:Error)
			{
				throw new Error("Error in constructor " + error.message);
			}
			
		}
		
		private var rbArray:Array=new Array;
		
				
		private static var OPOZNIENIE_ARRAY:Array= 
			[
				{label:"3", data:3},
				{label:"6", data:6},
				{label:"10", data:10},
				{label:"15", data:15},
				{label:"20", data:20},
				{label:"30", data:30},
				{label:"60", data:60},
				{label:"120", data:120},
				{label:"300", data:300}
			];
		override protected function createChildren():void
		{
			super.createChildren();
			
		 	super.titleBar.percentHeight=100;
			
			
			var _i:int=0,x:int=10,y:int=20;
			for(_i=0;_i<9;_i++)
			{
				this.rbArray[_i]=new RadioButton;
				rbArray[_i].label=OPOZNIENIE_ARRAY[_i].label;
				rbArray[_i].x=x;
				rbArray[_i].y=y;
				rbArray[_i].width=60;
				rbArray[_i].height=30;
				rbArray[_i].addEventListener(MouseEvent.CLICK,this.RBGHandle);
				if(OPOZNIENIE_ARRAY[_i].data==this.odIlu)rbArray[_i].selected=true;
				
				super.titleBar.addChild(rbArray[_i]);
				
				
				if(_i%3==2){x+=60;y=20;}
				else y+=15;
			}
			
			
         
		}

		private function RBGHandle(event:MouseEvent):void {
			
			var messageEvent:ChangeRefreshEvent = new ChangeRefreshEvent(ChangeRefreshEvent.MY_CUSTOM_EVENT);
			messageEvent.wybor=event.currentTarget.label;
			dispatchEvent(messageEvent);
			dispatchEvent(new mx.events.CloseEvent(CloseEvent.CLOSE));
		}

		/**
		 * @private set the default open effect if the open effect is null
		 */
		private function setOpenEffectDefault():void
		{
			try
			{
				this.openEffect = new Iris();
				this.openEffect.duration = this.defaultOpenDuration;
			}
			catch(error:Error)
			{
				throw new Error("Error in setOpenEffectDefault() " + error.message);
			}
		}
		
		/**
		 * @private set the default close effect if the close effect is null
		 */
		private function setCloseEffectDefault():void
		{
			try
			{
				var rsz:Resize = new Resize();
				rsz.duration = defaultCloseDuration;
				rsz.heightTo = 0;
				rsz.widthTo = 0;
				//prevent scroll policy
				this.horizontalScrollPolicy = "off";
				this.verticalScrollPolicy = "off";
				this.closeEffect = rsz;
			}
			catch(error:Error)
			{
				throw new Error("Error in setCloseEffectDefault() " + error.message);
			}
			
		}
		
		/**
		 * @protected the close handler for the close event
		 * @param event an instance of a close event
		 */
		protected function onClose(event:CloseEvent):void
		{
			try
			{
				//stop the propagation of the close event and don&apos;t dispatch it until the effect has finished playing
				event.stopImmediatePropagation();
				//determine if we should play the reverse of the animation (resize, wipes, move?)
				var playReverse:Boolean = true;
				if(this.closeEffect is Resize || this.closeEffect is Move)
				{
					playReverse = false;
				}
				//set the width and height of the winodw if it is 0 based on its children
				setWidthHeight();
				//play the close effect and add an event listener for the effect end
				//if the effect is not a resize effect then play the close effect in reverse
				this.closeEffect.play([this], playReverse);
				this.closeEffect.addEventListener(EffectEvent.EFFECT_END,onCloseEffectEnd);
			}
			catch(error:Error)
			{
				throw new Error("Error in onClose() " + error.message);
			}
		}
		
		/**
		 * @private the event handler for when the close effect has finished playing
		 * @param event an instance of an effectEvent
		 * re-dispatch the close event once the effect has completed playing so that the developer using this component can handle
		 * the close event the way they choose
		 */
		private function onCloseEffectEnd(event:EffectEvent):void
		{
			try
			{
				//first remove the event listener for the close event so that this component doesn&apos;t replay the animation and stop the close event
				this.removeEventListener(CloseEvent.CLOSE,onClose);
				dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			}
			catch(error:Error)
			{
				throw new Error("Error in onCloseEffectEnd " + error.message);
			}
		}
		
		/**
		 * @private if the AnimatedTitleWindow width or height is 0 we set it here so that the close effect can play properly
		 * loop over children and get the greatest height and width from them and set the window width according to those
		 */
		private function setWidthHeight():void
		{
			try
			{
				if(this.width == 0 || this.height == 0)
				{
					for(var i:int = 0; i < this.getChildren().length; i ++)
					{
						this.getChildAt(i).width > this.w ? this.w = getChildAt(i).width : this.w = this.w;
						this.getChildAt(i).height > this.h ? this.h = getChildAt(i).height : this.h = this.h;
					}
					//just in case there is a 0 give the component a default height and width
					this.w == 0 ? this.w = 500 : this.w = this.w;
					this.h == 0 ? this.h = 500 : this.h = this.h;
					//now set the width and height of this component
					this.width = w;
					this.height = h;
				}
			}
			catch(error:Error)
			{
				throw new Error("Error in setWidthHeight " + error.message);
			}
		}
		
	}
	}