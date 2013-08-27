package scripts {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class GameMenuBtn extends MovieClip {
		
		
		public function GameMenuBtn() {
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		protected function mouseDownHandler(e:Event):void {
			this.gotoAndStop(2);
		}
		
		protected function mouseUpHandler(e:Event):void {
			this.gotoAndStop(1);
			
			var gameName:String = name.substr(0, name.indexOf('_'));
			var eventType:String = "request_game_" + gameName;
			trace("eventType: " + eventType);
			dispatchEvent(new Event(eventType, true));
		}
	}
	
}
