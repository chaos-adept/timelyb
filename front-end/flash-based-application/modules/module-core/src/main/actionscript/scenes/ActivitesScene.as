/**
 * Created by WORKSATION on 01.09.13.
 */
package scenes {
import game.core.BaseGame;

public class ActivitesScene extends BaseGame {

    private var activitesSmb:ActivitesSmb;

    public function ActivitesScene() {
        activitesSmb = new ActivitesSmb();
        addChild(activitesSmb);
    }
}
}
