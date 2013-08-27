package utils.content {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import insfrastructure.content.IImageContentResolver;
	
	public class UrlImageContentResolver implements IImageContentResolver {
		public function UrlImageContentResolver() {
		}
		
		public function requestImage(key:String, setDisplayObjectHandler:Function):void {
			var i:Loader = new Loader();
			i.contentLoaderInfo.addEventListener( Event.COMPLETE, loadComplete, false, 0, true); 
			i.load(new URLRequest(key));	
			
			function loadComplete(event:Event):void {
				var image:Bitmap = Bitmap(event.target.content);
				image.smoothing = true;
				setDisplayObjectHandler(image);
			}			
		}
	}
}