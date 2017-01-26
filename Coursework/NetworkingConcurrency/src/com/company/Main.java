package com.company;

public class Main {

    public static void main(String[] args) throws InterruptedException {


        // Shared twisted pair wire.
        TwistedWirePair wire = new MyTwistedWirePair();

        // Set network card 1 running connected to the shared wire.
        NetworkCard networkCard1 = new NetworkCard(1, wire);
        networkCard1.init();

        // Set network card 2 running with a simple data frame listener registered.
        NetworkCard networkCard2 = new NetworkCard(2, wire);
        networkCard2.init();

        // Currently noise level is set to 0.0 volts on wire (the 0.0 value).
        // Try increasing it to 3.5 volts to see if the transmission is reliable.
        ThermalNoise thermalNoise = new ThermalNoise("Thermal Noise", 1, wire);
        thermalNoise.start();

        // Set oscilloscope monitoring the wire voltage.
        Oscilloscope oscilloscope = new Oscilloscope("Oscilloscope", wire);
        oscilloscope.start();

        // Send a data frame across the link from network card 1 to network card 2.
        DataFrame myMessage = new DataFrame("Hello", 2);
        System.out.println("\n *** SENDING DATA FRAME: " + myMessage + "\n");
        networkCard1.send(myMessage);

        myMessage = new DataFrame("Earth calling Mars", 2);
        System.out.println("\n *** SENDING DATA FRAME: " + myMessage + "\n");
        networkCard1.send(myMessage);

        myMessage = new DataFrame("Hello Mars", 2);
        System.out.println("\n *** SENDING DATA FRAME: " + myMessage + "\n");
        networkCard1.send(myMessage);

        // Continuously read data frames received by network card 2.
        while (true) {

            DataFrame receivedData = networkCard2.receive();
            System.out.println("\n *** NETWORKCARD 2 RECEIVED: " + receivedData + "\n");

            DataFrame rd = networkCard1.receive();
            System.out.println("*** NETWORKCARD 1 RECIEIVED: " + rd);

        }
    }

//    static String checksum(byte[] buf) {
//        int j = 0;
//        long sum = 0;
//        int length = buf.length;
//        while (length > 0) {
//            sum += (buf[j++]&0xff) << 8;
//            if ((--length)==0) break;
//            sum += (buf[j++]&0xff);
//            --length;
//        }
//
//        System.out.println(Long.toBinaryString((~((sum & 0xFFFF)+(sum >> 16)))&0xFFFF));
//        System.out.println(Long.toBinaryString(((sum & 0xFFFF)+(sum >> 16))&0xFFFF));
//
//        long number0 = Long.parseLong(Long.toBinaryString((~((sum & 0xFFFF)+(sum >> 16)))&0xFFFF), 2);
//        long number1 = Long.parseLong(Long.toBinaryString(((sum & 0xFFFF)+(sum >> 16))&0xFFFF), 2);
//        long n = number0 + number1;
//        System.out.println(Long.toBinaryString((~(n & 0xFFFF)+(n >> 16))&0xFFFF));
//
//        return Long.toBinaryString((~((sum & 0xFFFF)+(sum >> 16)))&0xFFFF);
//
////        long sum2 = 0;
////
////        for (int i = 0; i < buf.length; i = i + 2) {
////            //Integer.parseInt(display.getText().trim(), 16 );
////            sum2 += Long.parseLong(String.format("%02X%02X", buf[i], buf[i+1]), 16);
////        }
////
////        System.out.println(Long.toBinaryString(sum2-1));
//
//        // prints "FF 00 01 02 03 "
//        //return 0;
//    }
}
