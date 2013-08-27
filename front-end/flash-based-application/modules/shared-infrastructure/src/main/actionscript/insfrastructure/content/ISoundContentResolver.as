package insfrastructure.content {
	import flash.media.Sound;
	
	public interface ISoundContentResolver {
		function newSound(key:String):Sound;	
	}
}