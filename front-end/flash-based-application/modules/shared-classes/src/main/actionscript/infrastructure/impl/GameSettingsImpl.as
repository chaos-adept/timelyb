package infrastructure.impl {
	import insfrastructure.IGameSettings;

	public class GameSettingsImpl implements IGameSettings {
		
		public static const TARGET_MARKET:String = "market";
		public static const TARGET_BILINGVO:String = "bilingvo";
		
		public var _target:String;
		
		public function GameSettingsImpl(target:String) {
			this._target = target;
		}
		
		public function get target():String {
			return _target;
		}
		
		public function get isMarketTarget():Boolean {
			return this.target == TARGET_MARKET;
		}
		
		public function get isBiLingvoTarget():Boolean {
			return this.target == TARGET_BILINGVO;
		}
		
		public static function newMarketSettings():GameSettingsImpl {
			return new GameSettingsImpl(TARGET_MARKET)	
		}

		public static function newBiLingvoSettings():GameSettingsImpl {
			return new GameSettingsImpl(TARGET_BILINGVO)	
		}		
		
	}
}