/**
 * Created by WORKSATION on 01.09.13.
 */
package scenes {
import events.EventUtils;

import flash.events.MouseEvent;

import game.core.BaseGame;

public class SplashScene extends BaseGame {
    public function SplashScene() {
        addChild(new SplashSmb);
        addEventListener(MouseEvent.MOUSE_DOWN, EventUtils.newGameFinishedFn(this));
    }
}
}
