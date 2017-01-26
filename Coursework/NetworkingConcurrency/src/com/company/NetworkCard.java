package com.company;

/**
 * Created by nathanliu on 31/12/2016.
 */

import com.sun.tools.javac.util.ArrayUtils;
import org.jfree.chart.event.AnnotationChangeListener;
import org.jfree.util.ArrayUtilities;

import javax.xml.crypto.Data;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.concurrent.*;
import java.util.concurrent.locks.Lock;
import java.util.Timer;

import static java.lang.Thread.sleep;


/**
 * Represents a network card that can be attached to a particular wire.
 * <p>
 * It has only two key responsibilities:
 * i) Allow the sending of data frames consisting of arrays of bytes using send() method.
 * ii) Receives data frames into an input queue with a receive() method to access them.
 *
 * @author K. Bryson
 */

public class NetworkCard {

    private final byte ACK = 0x5E;

    // Wire pair that the network card is atatched to.
    private final TwistedWirePair wire;

    // Unique device number and name given to the network card.
    private final int deviceNumber;
    private final String deviceName;

    // Default values for high, low and mid- voltages on the wire.
    private final double HIGH_VOLTAGE = 2.5;
    private final double LOW_VOLTAGE = -2.5;

    // Default value for a signal pulse width that should be used in milliseconds.
    private final int PULSE_WIDTH = 200;

    // Default value for maximum payload size in bytes.
    private final int MAX_PAYLOAD_SIZE = 1600;

    // Default value for input & output queue sizes.
    private final int QUEUE_SIZE = 5;

    // Output queue for dataframes being transmitted.
    private volatile LinkedBlockingDeque<DataFrame> outputQueue = new LinkedBlockingDeque<DataFrame>(QUEUE_SIZE);

    // Input queue for dataframes being received.
    private volatile LinkedBlockingDeque<DataFrame> inputQueue = new LinkedBlockingDeque<DataFrame>(QUEUE_SIZE);

    private volatile LinkedBlockingQueue<DataFrame> ACKList = new LinkedBlockingQueue<>(QUEUE_SIZE);

    // Transmitter thread.
    private Thread txThread;

    // Receiver thread.
    private Thread rxThread;

    public volatile int numberOfAttempts = 0;

    /**
     * NetworkCard constructor.
     * param deviceName This provides the name of this device, i.e. "Network Card A".
     * param wire       This is the shared wire that this network card is connected to.
     * param listener   A data frame listener that should be informed when data frames are received.
     * (May be set to 'null' if network card should not respond to data frames.)
     */
    public NetworkCard(int number, TwistedWirePair wire) {

        this.deviceNumber = number;
        this.deviceName = "NetCard" + number;
        this.wire = wire;

        txThread = this.new TXThread();
        rxThread = this.new RXThread();
    }

    /*
     * Initialize the network card.
     */
    public void init() {
        txThread.start();
        rxThread.start();
    }

    public void send(DataFrame data) throws InterruptedException {

        String header = Integer.toString(data.getDestination()) + deviceNumber;

        // Create Header of dataframe
        byte[] headerFrame = header.getBytes();

        // Create payload of dataframe
        byte[] payload = DataFrame.concat(data.getPayload(), ("-").getBytes());

        // Join header and payload into one byte array
        byte[] tempPacket = DataFrame.concat(headerFrame, payload);

        // Create the internet checksum for the dataframe
        byte[] headerWrapsum = wrapSum(headerFrame).getBytes();
        byte[] payloadWrapsum = wrapSum(payload).getBytes();

        // System.out.println("header size = " + headerWrapsum.length);
        // System.out.println("payload size = " + payloadWrapsum.length);

        // Join the header checksum and the payload checksum into one byte array
        byte[] wrapsum = DataFrame.concat(headerWrapsum, payloadWrapsum);

        // Join the header, payload and checksum together
        byte[] finalFrame = DataFrame.concat(tempPacket, wrapsum);

        outputQueue.put(new DataFrame(finalFrame, data.getDestination()));
    }

    public DataFrame receive() throws InterruptedException {
        try {
            DataFrame data = inputQueue.take();
            // System.out.println(data);

            // String for entire dataframe
            String frame = data.toString();

            byte[] m = data.getTransmittedBytes();
            byte[] header = new byte[4];
            byte[] body = new byte[4];

            // Create byte array for header of dataframe
            System.arraycopy(m, m.length - 8, header, 0, header.length);

            // Create byte array for payload of dataframe
            System.arraycopy(m, m.length - 4, body, 0, body.length);

            // Transform header of dataframe into a String object
            String receivedHeader = DataFrame.getHeader(frame);

            // Transform payload of dataframe into a String object
            String receivedPayload = DataFrame.getPayload(frame);

            // Check if the header and payload is corrupted
            if (!isCorrupted(receivedHeader.getBytes(), new String(header)) && !isCorrupted(receivedPayload.getBytes(), new String(body))) {

                int destination = Integer.parseInt(DataFrame.getDestination(frame));

                if (destination == deviceNumber) {

                    // Send ACK
                    byte[] acknowledgement = {ACK};
                    outputQueue.addFirst(new DataFrame(acknowledgement));

                    // Get the payload of the DataFrame and return it
                    String retVal = DataFrame.getPayload(frame);
                    return new DataFrame(retVal.substring(0, retVal.length() - 1));
                }
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    // Returns the sum of a byte array
    private long adder(byte[] buf) {
        int j = 0;
        long sum = 0;
        int length = buf.length;
        if (length > 0) {
            do {
                sum += (buf[j++] & 0xff) << 8;
                if ((--length) == 0) break;
                sum += (buf[j++] & 0xff);
                --length;
            } while (length > 0);
        }
        return sum;
    }

    // Check if the buffer has been corrupted
    private boolean isCorrupted(byte[] receivedBuffer, String checksum) {
        try {
            // System.out.println(checksum);
            long cs = Long.parseLong(checksum, 16);
            long rb = Long.parseLong(sum1(receivedBuffer), 16);
            long n = cs + rb;

            return !Long.toBinaryString((~(n & 0xFFFF) + (n >> 16)) & 0xFFFF).equals("0");

        } catch (Exception e) {
            System.out.println("Corruption occurred");
            return true;
        }
    }

    // Calculate the sum of the buffer and return a binary string representing the buffer
    private String sum1(byte[] buf) {
        String l = Long.toBinaryString(((adder(buf) & 0xFFFF) + (adder(buf) >> 16)) & 0xFFFF);
        while (l.length() < 16) l = "0" + l;
        return Long.toString(Long.parseLong(l, 2), 16);
    }

    // Calculate the sum of the buffer and return the complementing binary string representing the buffer
    private String wrapSum(byte[] buf) {
        String l = Long.toBinaryString((~((adder(buf) & 0xFFFF) + (adder(buf) >> 16))) & 0xFFFF);
        while (l.length() < 16) l = "0" + l;
        return Long.toString(Long.parseLong(l, 2), 16);
    }

    /*
     * Private inner thread class that transmits data.
     */

    private class TXThread extends Thread {

        public void run() {

            try {
                while (true) {
                    // Blocks if nothing is in queue.
                    DataFrame frame = outputQueue.take();
                    transmitFrame(frame);


                }
            } catch (InterruptedException except) {
                System.out.println(deviceName + " Transmitter Thread Interrupted - terminated.");
            }

        }

        /**
         * Tell the network card to send this data frame across the wire.
         * NOTE - THIS METHOD ONLY RETURNS ONCE IT HAS TRANSMITTED THE DATA FRAME.
         *
         * @param frame Data frame to transmit across the network.
         */

        public void transmitFrame(DataFrame frame) throws InterruptedException {

            if (frame != null) {

                // System.out.println(deviceName + " sending " + frame);

                // Low voltage signal to get ready ...
                wire.setVoltage(deviceName, LOW_VOLTAGE);
                sleep(PULSE_WIDTH * 4);

                byte[] payload = frame.getTransmittedBytes();

                // Send bytes in asynchronous style with 0.2 seconds gaps between them.

                transmitByte(DataFrame.sentinel);

                for (int i = 0; i < payload.length; i++) {

                    // Byte stuff if required.
                    if (payload[i] == 0x7E || payload[i] == 0x7D)
                        transmitByte((byte) 0x7D);

                    transmitByte(payload[i]);

                }

                // Append a 0x7E to terminate frame.
                transmitByte((byte) 0x7E);

                // Reset voltage of this device to 0
                // So other devices can transmit
                wire.setVoltage(deviceName, 0);
                sleep(PULSE_WIDTH);

                // If the payload is not ACK then wait for an ACK
                if (frame.getPayload()[0] != ACK) {

                    // if number of attempts is greater than 10 stop sending
                    if (numberOfAttempts > 10) {
                        return;
                    }

                    //System.out.println("number of attempts "  + numberOfAttempts);

                    int counter = 0;
                    // While no ACK has been received ...
                    while (true) {

                        // If time waited for ACK is greater than 30 seconds
                        if (counter > 30000) {
                            // Resent DataFrame
                            numberOfAttempts++;
                            outputQueue.addFirst(frame);
                            return;
                        }

                        // Increment the counter by 1 millisecond
                        sleep(1);
                        counter++;

                        // Take the head of the ACK list
                        DataFrame data = null;
                        if (ACKList.size() > 0) {
                            data = ACKList.take();
                        }

                        // If ACK received break;
                        if (data != null) {
                            if (data.getPayload()[0] == ACK) {
                                // System.out.println("ACK RECEIVED");
                                break;
                            }
                        }
                    }
                }
            }
        }


        private void transmitByte(byte value) throws InterruptedException {

            // Low voltage signal ...
            wire.setVoltage(deviceName, LOW_VOLTAGE);
            sleep(PULSE_WIDTH * 4);

            // Set initial pulse for asynchronous transmission.
            wire.setVoltage(deviceName, HIGH_VOLTAGE);
            sleep(PULSE_WIDTH);

            // Go through bits in the value (big-endian bits first) and send pulses.
            for (int bit = 0; bit < 8; bit++) {
                if ((value & 0x80) == 0x80) {
                    wire.setVoltage(deviceName, HIGH_VOLTAGE);
                } else {
                    wire.setVoltage(deviceName, LOW_VOLTAGE);
                }

                // Shift value.
                value <<= 1;

                sleep(PULSE_WIDTH);
            }
        }
    }

    /*
     * Private inner thread class that receives data.
     */
    private class RXThread extends Thread {

        public void run() {

            try {

                // Listen for data frames.

                while (true) {

                    byte[] bytePayload = new byte[MAX_PAYLOAD_SIZE];
                    int bytePayloadIndex = 0;
                    byte receivedByte;

                    receivedByte = receiveByte();

                    if (receivedByte != 0x00 && receivedByte == 0x7E) {

                        while (true) {

                            receivedByte = receiveByte();

                            if (receivedByte != 0x00) {

                                System.out.println(deviceName + " RECEIVED BYTE = " + Integer.toHexString(receivedByte & 0xFF));

                                // Unstuff if escaped.
                                if (receivedByte == 0x7D) {
                                    receivedByte = receiveByte();
                                    bytePayload[bytePayloadIndex++] = receivedByte;
                                    receivedByte = receiveByte();
                                    System.out.println(deviceName + " ESCAPED RECEIVED BYTE = " + Integer.toHexString(receivedByte & 0xFF));
                                }

                                if ((receivedByte & 0xFF) == 0x7E) {
                                    break;
                                }

                                bytePayload[bytePayloadIndex++] = receivedByte;
                            }

                        }

                        DataFrame df = new DataFrame(Arrays.copyOfRange(bytePayload, 0, bytePayloadIndex));

                        if (df.getPayload()[0] == ACK && df.getPayload().length == 1) {
                            ACKList.add(df);
                        } else {
                            inputQueue.put(df);
                        }
                        sleep(PULSE_WIDTH);
                    }
                }

            } catch (InterruptedException except) {
                System.out.println(deviceName + " Interrupted: " + getName());
            }

        }


        public byte receiveByte() throws InterruptedException {

            double thresholdVoltage = (LOW_VOLTAGE + 2.0 * HIGH_VOLTAGE) / 6;
            //double thresholdVoltage = 0;
            byte value = 0;

            while (wire.getVoltage(deviceName) < thresholdVoltage) {
                sleep(PULSE_WIDTH / 10);
            }

            // Sleep till middle of next pulse.
            sleep(PULSE_WIDTH + PULSE_WIDTH / 2);

            // Use 8 next pulses for byte.
            for (int i = 0; i < 8; i++) {

                value *= 2;

                // System.out.println("Volage="+wire.getVoltage(deviceName) + ", thresholdValue=" + thresholdVoltage);

                if (wire.getVoltage(deviceName) > thresholdVoltage) {
                    value += 1;
                }

                sleep(PULSE_WIDTH);
            }

            return value;
        }

    }

}
