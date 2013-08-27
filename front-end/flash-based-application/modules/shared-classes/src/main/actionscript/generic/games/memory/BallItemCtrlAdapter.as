/**
 * author: chaos-encoder
 * Date: 24.10.12 Time: 7:28
 */
package generic.games.memory {
import flash.display.MovieClip;

import generic.games.memory.GenericItemCtrlAdapter;

public class BallItemCtrlAdapter extends GenericItemCtrlAdapter {

    public function BallItemCtrlAdapter(movie:MovieClip) {
        super (movie);
    }

    public function set imageUrl(imageUrl:String):void {
        this.targetMovie.imageUrl = imageUrl;
    }

    public function set itemName(itemName:String):void {
        this.targetMovie.itemName = itemName;
    }

    public function get imageScale():Number {
        return this.targetMovie.imageScale;
    }

    public function set imageScale(value:Number):void {
        this.targetMovie.imageScale = value;
    }
}
}
