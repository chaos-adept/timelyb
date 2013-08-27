/**
 * Created by WORKSATION on 07.07.13.
 */
package utils {
import flash.utils.ByteArray;

public class BeanUtils {
    public function BeanUtils() {
    }

    public static function clone(source:Object):* {
        var copier:ByteArray = new ByteArray();
        copier.writeObject(source);
        copier.position = 0;
        return(copier.readObject());
    }
}
}
