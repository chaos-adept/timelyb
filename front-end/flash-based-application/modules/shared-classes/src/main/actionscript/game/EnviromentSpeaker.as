package game {
	import utils.MathUtils;
	import utils.SoundManager;

	public class EnviromentSpeaker implements IEnveromentSpeaker {
		
		private static const SPEAKER_STEREO_TYPE_WARYA:String =  "varya"
		private var speakerStereotype:String = SPEAKER_STEREO_TYPE_WARYA;		
		
		public function EnviromentSpeaker()
		{
		}
		
		public function isNextGameSound(soundKey:String):Boolean {
			var regExp:RegExp = /^(all_next_[0-9]+_(.)+)|(all_final_(.)+)$/i;
			return soundKey.match(regExp);
		}
		
		public function newSetBukaSpeakerStereotypeFn():Function {
			return function ():void {
				setSpeakerStereotype("buka");
			}
		}
		
		private function setSpeakerStereotype(stereoType:String):void {
			this.speakerStereotype = stereoType;
		}
		
		public function newSetWaryaSpeakerStereotypeFn():Function {
			return function ():void {
				setSpeakerStereotype(SPEAKER_STEREO_TYPE_WARYA);
			}
		}
		
		public function congratulations():void {
			var rndSoundKey:String = "all_next_" + MathUtils.randRange(1, 8) + "_" + speakerStereotype;
			SoundManager.play(rndSoundKey, false);
		}		
	}
}