package infrastructure.impl {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import insfrastructure.content.IImageContentResolver;
	
	public class EmbedImageContentResolver implements IImageContentResolver {
		
		private var keys:Dictionary;
		
		public function EmbedImageContentResolver(keys:Dictionary) {
			this.keys = keys;
		}
		
		public function requestImage(url:String, setDisplayObjectHandler:Function):void {
			var extensionIndex:Number = url.lastIndexOf( '.' );
			var extensionless:String = url.substr( 0, extensionIndex ); 
			
			var imgClass:Class = keys[extensionless];
			
			if (!imgClass) {
				throw new Error("Embed image resource coould not be found by '" + extensionless + "'");
			}			
			
			var image:Bitmap = new imgClass;
			image.smoothing = true;
			setDisplayObjectHandler(image);
		}
	}
}