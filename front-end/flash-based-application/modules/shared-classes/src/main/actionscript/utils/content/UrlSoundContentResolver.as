package utils.content {
import flash.media.Sound;
import flash.net.URLRequest;

import insfrastructure.content.ISoundContentResolver;

import org.as3commons.lang.StringUtils;

public class UrlSoundContentResolver implements ISoundContentResolver {
		public function UrlSoundContentResolver() {
		
		}
		
		public function newSound(key:String):Sound {
			var sound:Sound = new Sound();
            var url:String = StringUtils.endsWith(key, ".mp3") ? key : key + ".mp3";
			var urlRequest:URLRequest = new URLRequest(Cnst.FOLDER_SOUNDS + url);
			//sound.addEventListener(Event.COMPLETE, soundLoadCompleteHandler);
			sound.load(urlRequest);
			return sound;
		}
		
	}
}