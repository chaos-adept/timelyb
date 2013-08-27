package  {
	
	import flash.display.MovieClip;
	
	
	public dynamic class Parovoz extends MovieClip {
		
		private var _wagonCount:int = 6;
		
		public function get wagonCount():int {
			return _wagonCount;	
		}
		
		public function set wagonCount(count:int):void {
			trace("set wagon count", count);
			this._wagonCount = count;
			updateWagonVisibleState();
		}
		
		public function updateWagonVisibleState():void {
			if (wagonCount == 5) {
				this.vagon_6.visible = false;
			} else {
				this.vagon_6.visible = true;
			}
			
			trace("updateWagonVisibleState", wagonCount, this.vagon_6.visible);
		}
		public function Parovoz() {
			// constructor code
		}
	}
	
}
