//
//  main.c
//  towersOfHanoi
//
//  Created by Nathan Liu on 08/02/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

#include <stdio.h>

void evaluate(int n, char beg, char aux, char end) {
    
    if (n == 1) {
        printf("Move from tower %c to tower %c\n", beg, end);
    } else {
        evaluate(n-1, beg, end, aux);
        evaluate(1, beg, aux, end);
        evaluate(n-1, aux, beg, end);
    }
    
}

int main(int argc, char **argv) {
    
    int n;
    printf("Enter number of disks: ");
    scanf("%d", &n);
    
    char x;
    printf("Enter starting peg: ");
    scanf(" %c", &x);
    
    switch (x) {
            
        case 'a':
            evaluate(n, x, 'b', 'c'); break;
            
        case 'b':
            evaluate(n, x, 'a', 'c'); break;
            
        case 'c':
            evaluate(n, x, 'b', 'a'); break;

        default:
            printf("please enter a, b or c for the starting peg\n"); break;
    }
    

    
    return 0;
}
