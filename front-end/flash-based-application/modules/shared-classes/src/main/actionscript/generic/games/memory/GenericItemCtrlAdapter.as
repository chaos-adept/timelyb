/**
 * author: chaos-encoder
 * Date: 24.10.12 Time: 7:20
 */
package generic.games.memory {

import flash.display.MovieClip;

public class GenericItemCtrlAdapter implements IMemoryItemCtrl {
    protected var targetMovie:MovieClip;

    public function GenericItemCtrlAdapter(targetMovie:MovieClip) {
        this.targetMovie = targetMovie;
    }

    public function get name():String {
        return targetMovie.name;
    }

    public function wait():void {
        targetMovie.wait();
    }

    public function open():void {
        targetMovie.open();
    }

    public function get key():String {
        return targetMovie.key;
    }


    public function set key(value:String):void {
        targetMovie.key = value;
    }

    public function get isTextMode():Boolean {
        return targetMovie.isTextMode;
    }

    public function set mouseEnabled(value:Boolean):void {
        targetMovie.mouseEnabled = value;
    }

    public function get mouseEnabled():Boolean {
        return targetMovie.mouseEnabled;
    }

    public function set mouseChildren(value:Boolean):void {
        targetMovie.mouseChildren = value;
    }

    public function get mouseChildren():Boolean {
        return targetMovie.mouseChildren;
    }

    public function isOpenned():Boolean {
        return targetMovie.isOpenned();
    }

    public function set isTextMode(value:Boolean):void {
        targetMovie.isTextMode = value;
    }
}
}
