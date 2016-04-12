package com.brumhack.asteroids;

import org.newdawn.slick.*;
import org.newdawn.slick.state.BasicGameState;
import org.newdawn.slick.state.StateBasedGame;
import org.newdawn.slick.state.transition.FadeInTransition;
import org.newdawn.slick.state.transition.FadeOutTransition;

/**
 * Created by Soviet on 24/10/15.
 */
public class Start_Screen extends BasicGameState {
    public static Image backGround;

    @Override
    public int getID() {
        return 0;
    }

    @Override
    public void init(GameContainer container, StateBasedGame game) throws SlickException {
        Start_Screen.backGround = new Image("res/starMap.001.png");

    }


    @Override
    public void update(GameContainer container, StateBasedGame game, int delta) throws SlickException {
        if(container.getInput().isKeyPressed(Input.KEY_SPACE)){
            container.reinit();
            game.enterState(1, new FadeOutTransition(), new FadeInTransition());
        }
    }

    @Override
    public void render(GameContainer container, StateBasedGame game, Graphics g) throws SlickException {
        Start_Screen.backGround.drawCentered(400, 300);
        g.setColor(Color.white);
        g.drawString("To start game,press \"SpaceBar\"",260,280);
        g.drawString("To pause during the game, press \"Esc\"", 240,300);
    }

}
