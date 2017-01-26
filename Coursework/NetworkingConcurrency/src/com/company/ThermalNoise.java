package com.company;

import org.jfree.ui.RefineryUtilities;
import java.util.Date;

import javax.swing.SwingUtilities;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.NumberTickUnit;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.jfree.ui.ApplicationFrame;
/**
 * Created by nathanliu on 31/12/2016.
 */

public class ThermalNoise extends Thread {

    // Device name.
    private final String deviceName;

    // Thermal noise level in volts.
    private final double noiseLevel;

    // Shared wire object to add the thermal noise to.
    private final TwistedWirePair wire;


    /**
     * @param deviceName This provides the name of this device, i.e. "Network Card A".
     * @param noiseLevel The peak-to-peak noise level to set in volts.
     * @param wire       This is the shared wire that this network card is connected to.
     */
    public ThermalNoise(String deviceName, double noiseLevel, TwistedWirePair wire) {
        this.deviceName = deviceName;
        this.noiseLevel = noiseLevel;
        this.wire = wire;
    }

    /**
     * Start sending random noise to the wire between -1/2 noiseLevel to 1/2 noiseLevel.
     */

    @Override
    public void run() {

        while (true) {
            wire.setVoltage(deviceName, (Math.random() - 0.5) * noiseLevel);
        }

    }
}

class OscilloscopePanel extends ApplicationFrame {

    private static final long serialVersionUID = 1L;

    private Date startDate = new Date();
    private long startTime = startDate.getTime();
    private XYSeries voltages = new XYSeries("Voltages");

    public OscilloscopePanel() {

        super("Oscilloscope");

        // Set initial (time, voltage) datapoint of (0.0, 0.0).
        voltages.add(0.0, 0.0);

        XYSeriesCollection dataset = new XYSeriesCollection();
        dataset.addSeries(voltages);

        JFreeChart chart = ChartFactory.createXYLineChart(
                "Oscilloscope",
                "Time (seconds)",
                "Voltage",
                dataset,
                PlotOrientation.VERTICAL,
                true,
                false,
                false);

        XYPlot plot = (XYPlot) chart.getPlot();

        XYLineAndShapeRenderer renderer = new XYLineAndShapeRenderer();
        renderer.setSeriesLinesVisible(0, true);

        NumberAxis domain = (NumberAxis) plot.getDomainAxis();
        domain.setRange(0.0, 10.0);
        domain.setTickUnit(new NumberTickUnit(1.0));
        domain.setVerticalTickLabels(true);

        NumberAxis range = (NumberAxis) plot.getRangeAxis();
        range.setRange(-5.0, 5.0);
        range.setTickUnit(new NumberTickUnit(1.0));

        plot.setRenderer(renderer);

        ChartPanel chartPanel = new ChartPanel(chart);
        chartPanel.setPreferredSize(new java.awt.Dimension(500, 300));

        setContentPane(chartPanel);
    }


    /**
     * This sets the voltage value at a particular point in term on the oscilloscope.
     * If it sweeps over the end then it resets and goes back to the start.
     *
     * @param voltage Value to set on the oscilloscope.
     */
    void setVoltage(double voltage) {

        Date currentDate = new Date();
        double currentTime = (currentDate.getTime() - startTime) / 1000.0;

        if (currentTime > 10.0) {

            startTime = currentDate.getTime();
            currentTime = 0.0;

            Runnable clearData = new Runnable() {
                public void run() {
                    voltages.clear();
                }
            };

            SwingUtilities.invokeLater(clearData);
        }

        voltages.add(currentTime, voltage);
    }
}


class Oscilloscope extends Thread {

    private final String deviceName;
    private final TwistedWirePair wire;
    private final OscilloscopePanel panel;

    public Oscilloscope(String deviceName, TwistedWirePair wire) {

        this.deviceName = deviceName;
        this.wire = wire;

        // Create the Oscilloscope panel and make it visible.
        this.panel = new OscilloscopePanel();

        panel.pack();
        RefineryUtilities.centerFrameOnScreen(panel);
        panel.setVisible(true);
    }


    @Override
    public void run() {

        try {

            while (true) {

                double voltage = wire.getVoltage(deviceName);
                panel.setVoltage(voltage);

                sleep(10);
            }

        } catch (InterruptedException except) {
            System.out.println("Netword Card Interrupted: " + getName());
        }

    }
}
