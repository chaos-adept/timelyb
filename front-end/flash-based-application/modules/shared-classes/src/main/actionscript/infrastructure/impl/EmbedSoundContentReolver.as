package infrastructure.impl  {
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	import game.IEnveromentSpeaker;
	
	import insfrastructure.content.ISoundContentResolver;
	
	import org.as3commons.lang.StringUtils;
	
	public class EmbedSoundContentReolver implements ISoundContentResolver {
		
		private var keys:Dictionary;
		
		public function EmbedSoundContentReolver(keys:Dictionary) {
			this.keys = keys;	
		}
		
		public function newSound(key:String):Sound {
			key = StringUtils.removeEnd(key, ".mp3");
			var classRef:Class = keys["sounds/" + key];
			if (!classRef) {
				throw new Error("Embed sound resource coould not be found by '" + key + "'");
			}
			return new classRef as Sound;	
		}
	}
}