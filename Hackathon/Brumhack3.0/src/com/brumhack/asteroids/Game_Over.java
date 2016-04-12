package com.brumhack.asteroids;

import org.newdawn.slick.*;
import org.newdawn.slick.state.BasicGameState;
import org.newdawn.slick.state.StateBasedGame;
import org.newdawn.slick.state.transition.FadeInTransition;
import org.newdawn.slick.state.transition.FadeOutTransition;


/**
 * Created by Soviet on 24/10/15.
 */
public class Game_Over extends BasicGameState {
    @Override
    public int getID() {
        return 3;
    }

    @Override
    public void init(GameContainer container, StateBasedGame game) throws SlickException {
    }

    @Override
    public void update(GameContainer container, StateBasedGame game, int delta) throws SlickException {
        if (container.getInput().isKeyPressed(Input.KEY_R)) {
            container.reinit();
            game.enterState(1, new FadeOutTransition(), new FadeInTransition());
        }
    }

    @Override
    public void render(GameContainer container, StateBasedGame game, Graphics g) throws SlickException {
        Start_Screen.backGround.drawCentered(400, 300);
        g.drawString("Score: " + Game_Screen.score, 350,280);
        g.drawString("Press \"R\" to restart.", 300, 300);
    }


}
