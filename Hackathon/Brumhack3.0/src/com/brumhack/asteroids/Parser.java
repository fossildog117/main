package com.brumhack.asteroids;

import java.io.*;
import java.util.ArrayList;

/**
 * Created by janospotecki on 25/10/15.
 */
public class Parser {
    public static int[] readCompanies(ArrayList<Company> arr){
        boolean firstline = true;
        int[] output = new int[2]; // will hold arr[0] = firstmonth, arr[1] = firstyear

        FileInputStream fstream = null;
        try {
            fstream = new FileInputStream("bloomberg.brumhack");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        BufferedReader br = new BufferedReader(new InputStreamReader(fstream));

        String strLine;

        //Read File Line By Line
        try {
            while ((strLine = br.readLine()) != null)   {
                // Print the content on the console
                //System.out.println (strLine);
                int start = 0;
                int comma = strLine.indexOf(',');
                String name = strLine.substring(start, comma);
                start = ++comma;
                comma = strLine.indexOf(',' , comma);
                int month = Integer.parseInt(strLine.substring(start, comma));
                start = ++comma;
                comma = strLine.indexOf(',', comma);
                int year = Integer.parseInt(strLine.substring(start, comma));
                start = ++comma;
                int value = Integer.parseInt(strLine.substring(start));
                //System.out.println(name + " " + month + " " + year + " " + value);
                Company c = new Company(name);
                boolean exists = false;
                for (Company comp : arr){
                    if(comp.getName().equals(name)){
                        c = comp;
                        exists = true;
                    }
                }

                if(!c.hasYear(year)){
                    c.addYear(year);
                }
                c.insertMonth(month, value, year);
                if(!exists)
                    arr.add(c);

                if(firstline){
                    output[0] = month;
                    output[1] = year;
                    firstline = false;
                }

            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        //Close the input stream
        try {
            br.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    return output;
    }
}
