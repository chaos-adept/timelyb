/**
 * Created by WORKSATION on 6/13/13.
 */
package utils {
import flash.utils.Dictionary;

public class DictonaryUtils {
    public function DictonaryUtils() {
    }

    public static function concate(...dicts):Dictionary {
        var result:Dictionary = new Dictionary();
        for each (var dic:Dictionary in dicts) {
            for (var itemKey:String in dic) {
                result[itemKey] = dic[itemKey];
            }
        }
        return result;
    }
}
}
