package controls 
{
	import events.EventFactory;
	import events.EventTypes;
	import events.EventUtils;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 * ...
	 * @author DES
	 */
	public class SelectableArea extends InitiableMovieClip
	{
		
		public var selectEventType:String;
		
		public var lastMouseClickEvent:MouseEvent;
		
		public function SelectableArea() 
		{
			selectEventType = Cnst.EVENT_TYPE_SELECT;
			
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			
		}
		
		override protected function addedToParentHandler(e:Event):void {
			super.addedToParentHandler(e);
			if (Object(parent).hasOwnProperty("registerHitArea")) {
				Object(parent).registerHitArea(this);
			}
			
		}
		
		override protected function addedToStateHandler():void 
		{
			super.addedToStateHandler();
		}
		
		protected function clickHandler(e:MouseEvent):void 
		{
            trace("clickHandler", this);
			lastMouseClickEvent = e;
			EventUtils.newCustomEvent(this, selectEventType, generateSelectableAreaName());
		}
		
		public function generateSelectableAreaName():String {
			return !(new RegExp("^instance([0-9])+$").test(this.name)) ? this.name : getQualifiedClassName(this);
		}
		
	}

}