/**
 * author: chaos-encoder
 * Date: 23.09.12 Time: 18:36
 */
package controls {
import com.furusystems.logging.slf4as.ILogger;
import com.furusystems.logging.slf4as.Logging;

import flash.display.MovieClip;
import flash.utils.getQualifiedClassName;

public class GameHolder extends InitiableMovieClip {
    private var LOG:ILogger = Logging.getLogger(GameHolder);
    private var currentGame:MovieClip;

    public function GameHolder() {
    }

    public function setGame(gameClass:Class):void {

        if (currentGame != null) {
			currentGame.stop();
            this.removeChild(currentGame);
        }

        currentGame = new gameClass();
        LOG.debug("setup game {}", getQualifiedClassName(gameClass));
        this.addChild(currentGame);
    }


    public function getCurrentGame():Object {
        return currentGame;
    }
}
}
