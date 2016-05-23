
#include<stdio.h>
#include<stdlib.h>

const int SIZE = 6;
const int no_of_nodes = SIZE;
const int infinity = 999;

void dijakstras(int matrix[SIZE][SIZE], int end_node) {
    
    int distance[SIZE];
    int visited[SIZE];
    int path[SIZE];
    
    int min;
    int nextNode = 0;
    
    for (int i = 0; i < SIZE; i++) {
        
        visited[i] = 0;
        path[i] = 0;
        
        for (int j = 0; j < SIZE; j++) {
            if (matrix[i][j] == 0) {
                matrix[i][j] = 999;
            }
        }
    }
    
    for (int i = 0; i < SIZE; i ++) {
        distance[i] = matrix[0][i];
    }
    distance[0] = 0;
    visited[0] = 1;
    
    for (int i = 0; i < SIZE; i++) {
        min = infinity;
        for (int j = 0 ; j < SIZE; j++) {
            if (min > distance[j] && visited[j] != 1) {
                min = distance[j];
                nextNode = j;
            }
        }
        
        visited[nextNode] = 1;
        
        for (int c = 0; c < SIZE; c++) {
            
            if (visited[c] != 1) {
                
                if (min + matrix[nextNode][c] < distance[c]) {
                    
                    distance[c] = min + matrix[nextNode][c];
                    path[c] = nextNode;
                    
                }
                
            }
            
        }
        
    }
    
    // shortest path from 0 to the end_node
    
    int j = end_node;
    printf("distance = %d\n", distance[j]);
    printf("path = %d" , j);
    
    do {
        j = path[j];
        printf("<- %i", j);
    } while (j != 0);
    printf("\n");
}

int main(){
    
    int matrix[SIZE][SIZE];
    for (int i = 0 ; i  < SIZE ; i++) {
        for (int j = 0; j < SIZE; j++) {
            matrix[i][j] = 0;
        }
    }
    
    matrix[0][1] = 7;
    matrix[0][2] = 9;
    matrix[0][5] = 14;
    matrix[1][2] = 10;
    matrix[1][3] = 15;
    matrix[2][3] = 11;
    matrix[2][5] = 2;
    matrix[3][4] = 6;
    matrix[4][5] = 9;
    
    dijakstras(matrix, 4);
    
    return 0;
    
}
