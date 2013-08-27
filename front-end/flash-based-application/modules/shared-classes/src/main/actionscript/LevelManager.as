package  
{
import events.EventUtils;

import flash.events.EventDispatcher;

import utils.SoundManager;

/**
	 * ...
	 * @author DES
	 */
	public class LevelManager extends EventDispatcher
	{
		
		private static var _instance:LevelManager;
		
		public function LevelManager() 
		{
			
		}
		
		public static function get instance():LevelManager {
			if (!_instance) {
				_instance = new LevelManager();
			}
			return _instance;
		}
		
		private var _isAdvanced:Boolean;

        public function get isSimple():Boolean {
            return !_isAdvanced;
        }

        public function get isAdvanced():Boolean {
            return _isAdvanced;
        }

        public function set isAdvanced(value:Boolean):void {
            if (value == _isAdvanced) {
                return;
            }
            _isAdvanced = value;

            if (!_isAdvanced) {
                SoundManager.play("1st_level_varya", false);
            } else {
                SoundManager.play("2nd_level_varya", false);
            }

            EventUtils.newCustomEvent(this, Cnst.EVENT_TYPE_MODE_UPDATED, null);
        }
    }

}