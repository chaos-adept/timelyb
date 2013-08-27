/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 17.01.13
 * Time: 11:33
 * To change this template use File | Settings | File Templates.
 */
package game {
import utils.SoundManager;

public class DocumentActivityController extends ActivityController {

    public function DocumentActivityController(activity:game.IActivity) {
        super(activity);
    }

    override protected function exitFromApplication():Boolean {
        var isBaseExit:Boolean =
                super.exitFromApplication();
        if (isBaseExit) {
            ApplicationHelper.exit();
            return true;
        } else {
            return false;
        }
    }


    override protected function doDeactivate():void {
        super.doDeactivate();
        SoundManager.instance.suspendAll();
    }


    override protected function doResume():void {
        super.doResume();
        SoundManager.instance.resumeAll();

    }
}
}
