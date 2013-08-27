package insfrastructure.content {
	
	public interface IImageContentResolver {
		function requestImage(key:String, setDisplayObjectHandler:Function):void;	
	}
}