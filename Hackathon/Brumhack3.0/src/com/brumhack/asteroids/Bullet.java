package com.brumhack.asteroids;

import java.lang.Math;

/**
 * Created by Fraser Savage on 25/10/2015.
 */
public class Bullet {
    public static float velocity;

    public float getX() {
        return x;
    }

    public float getY() {
        return y;
    }

    private float x;
    private float y;
    private float angle;

    public Bullet(float startx, float starty, float v, float theta) {
        x = startx;
        y = starty;
        angle = theta;
        velocity = v;
    }

    public void update(float delta) {
        x += (Math.sin(Math.toRadians(angle)) * velocity);
        y -= (Math.cos(Math.toRadians(angle)) * velocity);
    }


}
