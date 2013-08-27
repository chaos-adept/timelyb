package {

import flash.display.MovieClip;
import flash.events.MouseEvent;

public class PrototypeDocument extends MovieClip {
		public function PrototypeDocument() {
			trace("PrototypeDocument was created")
			this.gotoAndStop(1, "start");
		}
}

}