/**
 * Created by WORKSATION on 01.09.13.
 */
package scenes {
import flash.events.TimerEvent;
import flash.utils.Timer;

import game.core.BaseGame;

import insfrastructure.Context;

public class TimerScene extends BaseGame {

    private var timerSmb:TimerSmb;
    private var timer:Timer;

    public function TimerScene() {
        timerSmb = new TimerSmb;
        timer = new Timer(1000);
        addChild(timerSmb);
    }


    override protected function addedToStateHandler():void {
        super.addedToStateHandler();
        timerSmb.projectNameTxt.text = Context.instance.locate("activeProject") as String;

        timer.addEventListener(TimerEvent.TIMER, timerTickHandler);
        timer.start();
    }

    private function timerTickHandler(event:TimerEvent):void {
        trace("таймер работает");
    }
}
}
