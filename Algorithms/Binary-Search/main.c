//
//  main.c
//  binarySearch
//
//  Created by Nathan Liu on 11/01/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

#include <stdio.h>

int i = 0;

int binary_search(int A[], int key, int imin, int imax) {
    
    int imid = imin + (imax - imin)/2;
    
    printf("A[mid] = %d ... A[imax] = %d ... A[imix] = %d \n\n", A[imid], A[imax], A[imin]);
    
    if (imax<imin) {
        return 0;
    } else {
        
        if (A[imid] > key) {
            return binary_search(A, key, imin, imid+1);
        } else if (A[imid] < key) {
            return binary_search(A, key, imid-1, imax);
        } else if (A[imid] == key) {
            return key;
        }
    }
    return 0;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    
    int A, key;
    int min = 0;
    
    printf("enter value of A: ");
    scanf("%d", &A);
    
    printf("\nEnter Key: ");
    scanf("%d", &key);
    
    int numbers[A];
    int max = A - 1;
    
    for (int i = 0; i < A; i++) {
        numbers[i] = i;
    }
    
    printf("\nKey is at location: %d\n", binary_search(numbers, key, min, max));
    
    return 0;
}
