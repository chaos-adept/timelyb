package game {
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.DataEvent;
	
	import game.license.LicenseManager;
	
	import infrastructure.impl.GameSettingsImpl;
	
	import insfrastructure.Context;
	import insfrastructure.IGameSettings;
	import insfrastructure.content.IImageContentResolver;
	import insfrastructure.content.ISoundContentResolver;
	
	import utils.content.UrlImageContentResolver;
	import utils.content.UrlSoundContentResolver;

	public class BaseModulDocument extends InitiableMovieClip {

		protected var _envSpeaker:IEnveromentSpeaker; 
		
		public function BaseModulDocument() {
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;			
			
			initContext();
		}
		
		protected function initContext():void {
			_envSpeaker = new EnviromentSpeaker();
			Context.instance.register(IEnveromentSpeaker, _envSpeaker);
			Context.instance.register(ISoundContentResolver, new UrlSoundContentResolver());
			Context.instance.register(IImageContentResolver, new UrlImageContentResolver());
			Context.instance.register(IGameSettings, newGameSettings());
		}
		
		protected function newGameSettings():IGameSettings {
			return GameSettingsImpl.newBiLingvoSettings();
		}
	}
}