package com.company;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by nathanliu on 31/12/2016.
 */
public class DataFrame {

    public static final byte escapeChar = 0x7D;
    public static final byte sentinel = 0x7E;

    public final byte[] payload;
    public byte[] checksum;
    private int destination = 0;

    public DataFrame(String payload) {
        this.payload = payload.getBytes();
    }

    public DataFrame(String payload, int destination) {
        this.payload = payload.getBytes();
        this.destination = destination;
    }

    public DataFrame(byte[] payload) {
        this.payload = payload;
    }

    public DataFrame(byte[] payload, int destination) {
        this.payload = payload;
        this.destination = destination;
    }

    public int getDestination() {
        return destination;
    }

    public byte[] getPayload() {
        return payload;
    }

    public String toString() {
        return new String(payload);
    }

    /*
     * A factory method that can be used to create a data frame
     * from an array of bytes that have been received.
     */
    public static DataFrame createFromReceivedBytes(byte[] byteArray) {
        DataFrame created = new DataFrame(byteArray);
        return created;
    }

    // Given a DataFrame this function will return the header
    // e.g. getDestination("2-1-hello world-0001000100010001") => "2-1-"
    public static String getHeader(String info) {
        StringBuilder builder = new StringBuilder();
        builder.append(getDestination(info));
        builder.append(getSource(info));
        return builder.toString();
    }

    // Given a DataFrame this function will return the destination
    // e.g. getDestination("2-1-hello world-0001000100010001") => "2"
    public static String getDestination(String des) {
        return des.substring(0, 1);
    }

    // Given a DataFrame this function will return the source
    // e.g. getDestination("2-1-hello world-0001000100010001") => "1"
    public static String getSource(String des) {
        return des.substring(1, 2);
    }

    // Given a DataFrame this function will return the payload
    // e.g. getDestination("2-1-hello world-0001000100010001") => "hello world-"
    public static String getPayload(String des) {
        String[] destArray = des.split("-");
        return des.substring(2, destArray[0].length()) + "-";
    }

    // Join two byte[] arrays together
    // e.g. concat([1,2], [3]) => [1,2,3]
    public static byte[] concat(byte[] a, byte[] b) {
        int first = a.length;
        int second = b.length;
        byte[] output = new byte[first + second];
        System.arraycopy(a, 0, output, 0, first);
        System.arraycopy(b, 0, output, first, second);
        return output;
    }

    /*
     * This method should return the byte sequence of the transmitted bytes.
     * At the moment it is just the payload data ... but extensions should
     * include needed header information for the data frame.
     * Note that this does not need sentinel or byte stuffing
     * to be implemented since this is carried out as the data
     * frame is transmitted and received.
     */
    public byte[] getTransmittedBytes() {
        return payload;
    }
}
