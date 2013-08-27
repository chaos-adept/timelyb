package game.core {
import com.furusystems.dconsole2.DConsole;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import game.*;

import insfrastructure.Context;
import insfrastructure.IGameSettings;
import insfrastructure.content.IImageContentResolver;

public class BaseGame extends InitiableMovieClip {
		
		protected var _gameSettings:IGameSettings;
		protected var _imgContentResolver:IImageContentResolver;
		protected var _envSpeakerProvider:IEnveromentSpeaker;	
		
		public function BaseGame() {
			super();
			injectFromContext();
		}
		
		protected function injectFromContext():void {
			_imgContentResolver = Context.instance.locate(IImageContentResolver) as IImageContentResolver;
			_envSpeakerProvider = Context.instance.locate(IEnveromentSpeaker) as IEnveromentSpeaker;	
			_gameSettings = Context.instance.locate(IGameSettings) as IGameSettings;
		}


    override protected function addedToStateHandler():void {
        super.addedToStateHandler();
    }

    public function resetGame():void {

        }

        public function getHelpMessage():String {
            return null;
        }
	}
}