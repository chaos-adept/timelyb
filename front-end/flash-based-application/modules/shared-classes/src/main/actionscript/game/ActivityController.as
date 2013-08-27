/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 17.01.13
 * Time: 11:32
 * To change this template use File | Settings | File Templates.
 */
package game {
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

public class ActivityController extends EventDispatcher {

    private var activity:IActivity;

    public function ActivityController(activity:IActivity) {
        this.activity = activity;
        var stage:Stage = activity.stage;
        if (stage) { //already added to stage
            assignToStage(stage);
        } else {
            activity.addAddedToStageListener(addedToStageHandler);
        }



    }

    private function removedFromStageHandler(e:Event):void {
        if (this.activity.stage) {
            this.activity.stage.removeEventListener(Event.ACTIVATE, handleActivate);
            this.activity.stage.removeEventListener(Event.DEACTIVATE, handleDeactivate);
            this.activity.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
        }
        activity.removeRemovedFromStageListener(removedFromStageHandler);
    }

    private function keyDownListener(event:KeyboardEvent):void {
        if (event.keyCode == Keyboard.MENU) {

        } else if (event.keyCode == Keyboard.BACK) {
            exitFromApplication();
        }
    }

    protected function exitFromApplication():Boolean {
        var exitRequest:Event = new Event(Cnst.EVENT_ACTIVITY_EXIT_REQUEST, false, true);
        dispatchEvent(exitRequest);
        if (exitRequest.isDefaultPrevented()) {
            return false;
        }

        removedFromStageHandler(null);// remove listeners , app will be destroyed
        activity.exit();
        return true;
    }

    private function handleDeactivate(event:Event):void {
        doDeactivate();
    }

    protected function doDeactivate():void {
        activity.suspend();
    }

    private function handleActivate(event:Event):void {
        doResume();
    }

    protected function doResume():void {
        activity.resume();
    }

    private function addedToStageHandler(e:Event):void {
        assignToStage(activity.stage);
    }

    private function assignToStage(stage:Stage):void {
        this.activity.stage.addEventListener(Event.ACTIVATE, handleActivate);
        this.activity.stage.addEventListener(Event.DEACTIVATE, handleDeactivate);
        this.activity.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
        activity.addRemovedFromStageListener(removedFromStageHandler);
    }
}
}
