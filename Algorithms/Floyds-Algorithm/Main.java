package com.company;

public class Main {

    static int[][] floydWarshall(int[][] d) {
        d = constructInitialMatixOfPredecessors(d);
        for (int k = 0; k < d.length; k++) {
            for (int i = 0; i < d.length; i++) {
                for (int j = 0; j < d.length; j++) {
                    if (d[i][j] > d[i][k] + d[k][j]) {
                        d[i][j] = d[i][k] + d[k][j];
                    }
                }
            }
        }
        d = finaliseArray(d);
        return d;
    }

    private static int[][] constructInitialMatixOfPredecessors(int[][] d) {

        for (int i = 0; i < d.length; i++) {
            for (int j = 0; j < d.length; j++) {
                if (d[i][j] == -1) {
                    d[i][j] = 100000;
                }
            }
        }
        return d;
    }

    static int[][] finaliseArray(int[][] d) {
        for (int i = 0; i < d.length; i++) {
            d[i][i] = 0;
        }
        return d;
    }

    public static void printArray(int[][] output) {
        for (int i = 0; i < output.length ; i++) {
            for (int j = 0; j < output.length ; j++) {
                System.out.print(output[i][j] + ", ");
                if (j == output.length - 1) {
                    System.out.print("\n");
                }
            }
        }
    }

    public static void main(String[] args) {

        int[][] output = floydWarshall(new int[][] {
                {-1,1,-1,3},
                {13,-1,2,-1},
                {-1,12,-1,3},
                {4,-1,11,-1}
        });

        printArray(output);
    }
}
