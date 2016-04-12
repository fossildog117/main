#include <stdio.h>

int greatestCommonDivisor() {
    
    int dummyElement;
    
    int numberOfArrayElements; // Number of numbers
    numberOfArrayElements = 3;
    
    int array[] = {83634, 124338, 153912, 161226, 249948}; // Array of n numbers
    
    int lowerArrayElement; //lowest number to be divided
    lowerArrayElement = 0; //lower number in array

    int upperArrayElement; //highest number to be divided
    upperArrayElement = 1; //higher number in array, one above the lowerArrayElement
    
    if ((array[lowerArrayElement] == 0) || (array[upperArrayElement] == 0)) {
        return 0;
    
    } else while (upperArrayElement < numberOfArrayElements) { // loops until final element in array is reached
        
        dummyElement = array[upperArrayElement] % array[lowerArrayElement];
        array[upperArrayElement] = array[lowerArrayElement];
        array[lowerArrayElement] = dummyElement;
        
        if ((dummyElement == 0) || (array[lowerArrayElement] == 0) || (array[upperArrayElement] == 0)) {
            upperArrayElement++;
            lowerArrayElement++;
        }
    }
    return array[lowerArrayElement];
}

int main(void) {
    int gcd = greatestCommonDivisor();
    printf("The GCD is %d\n", gcd);
    getchar();
    return 0;
}