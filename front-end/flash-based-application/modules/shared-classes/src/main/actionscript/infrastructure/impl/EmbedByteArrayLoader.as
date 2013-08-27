package infrastructure.impl
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import insfrastructure.content.IByteArrayDataLoader;
	
	public class EmbedByteArrayLoader implements IByteArrayDataLoader
	{
		private var keys:Dictionary;
		
		public function EmbedByteArrayLoader(keys:Dictionary) {
			this.keys = keys;
		}
		
		public function requestData(url:String, acceptResultHandler:Function):void {
			var extensionIndex:Number = url.lastIndexOf( '.' );
			var extensionless:String = url.substr( 0, extensionIndex ); 
			
			var byteArrClass:Class = keys[extensionless];
			
			if (!byteArrClass) {
				throw new Error("Embed bitmapdata resource coould not be found by '" + extensionless + "'");
			}			
			
			var byteArr:ByteArray = new byteArrClass;
			
			acceptResultHandler(byteArr);			
		}
	}
}