package game {
	
	public interface IEnveromentSpeaker {
		function newSetBukaSpeakerStereotypeFn():Function;
		function newSetWaryaSpeakerStereotypeFn():Function;		
		function isNextGameSound(soundKey:String):Boolean;
		function congratulations():void;
	}
}