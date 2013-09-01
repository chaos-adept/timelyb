/**
 * Created by WORKSATION on 01.09.13.
 */
package scenes {
import flash.events.Event;
import flash.events.MouseEvent;

import game.core.BaseGame;

import insfrastructure.Context;

public class ProjectScene extends BaseGame {

    private var projectSmb:ProjectsSmb;

    public function ProjectScene() {
        projectSmb = new ProjectsSmb();
        addChild(projectSmb);

        projectSmb.btn1.addEventListener(MouseEvent.MOUSE_DOWN, btn1ClickHandler);
    }

    private function btn1ClickHandler(e:MouseEvent):void {
        Context.instance.register("activeProject", "туториал по зебре");
        dispatchEvent(new Event("showTimer", true));
    }
}
}
