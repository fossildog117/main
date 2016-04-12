//
//  main.c
//  BubbleSort
//
//  Created by Nathan Liu on 23/10/2015.
//  Copyright © 2015 Liu Empire. All rights reserved.
//

#include <stdio.h>

int testArray[];
int testArrayTotal;

int *bubblesort(int *a, int n) {
    int temp; //for swapping
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - 1; j++) {
            
            if (a[j] > a[j+1]) {
                
                temp = a[j];
                a[j] = a[j+1];
                a[j+1] = temp;
                
                printf("\nThe array this swap is ");
                
                for (int p = 0; p < n; p++) {
                    printf("%d ", a[p]);
                }
            }
        }
    }
    
    return a;
    
}

int main(void)
{
    
    printf("Enter number of entries: ");
    scanf("%d", &testArrayTotal);
    
    for (int i = 0; i < testArrayTotal; i++) {
        printf("Enter a number: ");
        scanf("%d", &testArray[i]);
    }
    
    *testArray = *bubblesort(testArray, testArrayTotal);
    
    printf("\nThe sorted list is: ");
    
    for (int i = 0; i < testArrayTotal; i++) {
        
        printf("%i ", testArray[i]);
        
    }
    
    printf("\n\n");
    
    return 0;
    
}