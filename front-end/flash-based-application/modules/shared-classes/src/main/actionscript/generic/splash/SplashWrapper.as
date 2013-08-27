/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 17.01.13
 * Time: 11:53
 * To change this template use File | Settings | File Templates.
 */
package generic.splash {
import flash.display.MovieClip;

import game.ApplicationHelper;

public class SplashWrapper extends InitiableMovieClip{

    public static var TargetClass:Class;

    private var instance:MovieClip;

    public function SplashWrapper() {
        instance = new TargetClass();
        this.addChild(instance);
    }


    override protected function addedToStateHandler():void {
        super.addedToStateHandler();
        ApplicationHelper.registerActivity(this);
    }

    override public function suspend():void {
        super.suspend();
        instance.stop();
    }

    override public function resume():void {
        super.resume();
        instance.play();
    }
}
}
