package insfrastructure {
	import flash.utils.Dictionary;
	
	public class Context {
		
		private static var _context:Context;
		
		private var _dict:Dictionary;
		
		public function Context() {
			_context = this;
			_dict = new Dictionary();
		}
		
		public static function get instance():Context {
			if (!_context) {
				new Context();
			}
			
			return _context;
		}
		
		public function register(key:Object, value:Object):Context {
			_dict[key] = value	
			return this;
		}
		
		public function locate(key:Object, failIfNotExist:Boolean = true):Object {
			var result:Object = _dict[key];
			if (!result && failIfNotExist) {
				throw new Error("object can be found by key '" + key + "'");
			}
			
			return result;
		}

        public function locateOrNew(key:Object, classRef:Class):* {
            var existed:Object = locate(key, false);
            return existed ? existed : new classRef;
        }

        public function locateOrDefault(key:Object, defaultValue:Object):Object {
            var existed:Object = locate(key, false);
            if (!existed) {
                return defaultValue;
            } else {
                return existed;
            }
        }
	}
	
}