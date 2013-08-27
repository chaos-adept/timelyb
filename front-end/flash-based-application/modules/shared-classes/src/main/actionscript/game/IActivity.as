/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 17.01.13
 * Time: 10:56
 * To change this template use File | Settings | File Templates.
 */
package game {
import flash.display.Stage;

public interface IActivity {
    function exit():void;
    function suspend():void;
    function resume():void;
    function get stage():Stage;
    function addAddedToStageListener(handler:Function):void;
    function removeAddedToStageListener(handler:Function):void;

    function addRemovedFromStageListener(handler:Function):void;
    function removeRemovedFromStageListener(handler:Function):void;
}
}
