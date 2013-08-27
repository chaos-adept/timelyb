package insfrastructure.content
{
	public interface IByteArrayDataLoader {
	
		function requestData(key:String, acceptResultHandler:Function):void;
	}
}