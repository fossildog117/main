package com.brumhack.asteroids;


import org.newdawn.slick.*;
import org.newdawn.slick.state.StateBasedGame;



/**
 * @author Iridann.
 */

public class Engine extends StateBasedGame {


    public Engine(String name) {
        super(name);
    }

    @Override
    public void initStatesList(GameContainer container) throws SlickException {
        this.addState(new Start_Screen());
        this.addState(new Game_Screen());
        this.addState(new Pause_Screen());
        this.addState(new Game_Over());
    }

    public static void main(String[] args) throws SlickException {
        AppGameContainer gameContainer  = new AppGameContainer(new Engine("Stockstroids"));
        gameContainer.setDisplayMode(800,600,false);
        gameContainer.setTargetFrameRate(120);
        gameContainer.setAlwaysRender(true);
        gameContainer.setShowFPS(false);
        gameContainer.start();
    }
}
