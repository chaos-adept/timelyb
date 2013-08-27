/**
 * author: chaos-encoder
 * Date: 30.09.12 Time: 16:15
 */
package controls {
import flash.display.MovieClip;

public class RepeatController {

    private var container:MovieClip;
    private var animation:RepeatControlAnimation;
    public function RepeatController(container:MovieClip) {
        animation = new RepeatControlAnimation();
        container.addChild(animation);
    }

    public function toGameOverState():void {
        animation.toGameOverState();
    }

    public function toTaskState():void {
        animation.toTaskState();
    }

    public function hide():void {
        animation.visible = false;
    }

    public function show():void {
        animation.visible = true;
    }
}
}
