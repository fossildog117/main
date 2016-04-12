package com.brumhack.asteroids;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by janospotecki on 25/10/15.
 */
public class AstroidAbstract {

    private final List<AObserver> aAstroidList = new ArrayList<>();

    public void register(AObserver newAstroid){
        this.aAstroidList.add(newAstroid);
        System.out.println("Astroid add");

    }

    public void checkForDeletions() {
        for (Astroid a : getAstroidPositions()) {
            if ((a.getX() < -200) || (a.getX() > 1000)) {
                unregister(a);
                break;
            } else if ((a.getY() < -200) || (a.getY() > 800)) {
                unregister(a);
                break;
            }
        }
    }

    public void unregister(AObserver removeAstroid){
        this.aAstroidList.remove(removeAstroid);
    }

    public ArrayList<Astroid> getAstroidPositions(){
        ArrayList<Astroid> arr = new ArrayList<>();
        for(AObserver a : aAstroidList) {
            arr.add(a.getData());
        }
        return arr;
    }

    protected void moveAsteroids(){
        for(AObserver a : aAstroidList) a.move();
    }

}
