package infrastructure.impl  {
	import game.IEnveromentSpeaker;
	
	public class NullEnvSpeaker implements IEnveromentSpeaker {
		public function newSetBukaSpeakerStereotypeFn():Function {
			return function ():void {};
		}
		public function newSetWaryaSpeakerStereotypeFn():Function {
			return function ():void {};
		}
		public function isNextGameSound(soundKey:String):Boolean {
			return true;
		}
		public function congratulations():void {
		}
	}
}