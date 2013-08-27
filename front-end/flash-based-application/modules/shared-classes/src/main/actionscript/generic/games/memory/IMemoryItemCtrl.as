/**
 * author: chaos-encoder
 * Date: 24.10.12 Time: 7:08
 */
package generic.games.memory {
public interface IMemoryItemCtrl {
    function get name():String;

    function wait():void;

    function open():void;

    function get key():String;
    function set key(value:String):void;

    function get isTextMode():Boolean;
    function set isTextMode(value:Boolean):void;

    function set mouseEnabled(mouseEnabled:Boolean):void;
    function get mouseEnabled():Boolean;

    function set mouseChildren(mouseChildren:Boolean):void;
    function get mouseChildren():Boolean;

    function isOpenned():Boolean;
}
}
