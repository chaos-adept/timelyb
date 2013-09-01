/**
 * Created by WORKSATION on 01.09.13.
 */
package scenes {
import game.core.BaseGame;

import insfrastructure.Context;

public class TimerScene extends BaseGame {

    private var timerSmb:TimerSmb;

    public function TimerScene() {
        timerSmb = new TimerSmb;
        addChild(timerSmb);
    }


    override protected function addedToStateHandler():void {
        super.addedToStateHandler();
        timerSmb.projectNameTxt.text = Context.instance.locate("activeProject") as String;
    }
}
}
