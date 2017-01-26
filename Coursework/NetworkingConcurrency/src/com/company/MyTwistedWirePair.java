package com.company;

import java.util.HashMap;

/**
 * Created by nathanliu on 31/12/2016.
 */
public class MyTwistedWirePair implements TwistedWirePair {

    private double voltage = 0.0;
    private HashMap<String, Double> currentVoltages = new HashMap<String, Double>();

    public synchronized void setVoltage(String device, double voltage) {
        currentVoltages.put(device, voltage);
        updateWireVoltage();
    }

    /*
     * Update current voltage on the wire.
     */
    private void updateWireVoltage(){

        voltage = 0.0;

        // Add all the currently set voltages together.
        for (double currentVoltage: currentVoltages.values()) {
            voltage += currentVoltage;
        }
    }

    public synchronized double getVoltage(String device) {
        return voltage;
    }

}



