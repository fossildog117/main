#include <stdio.h>
#include <string.h>   /* for all the new-fangled string functions */
#include <stdlib.h>     /* malloc, free, rand */

/*  The main program calls procedures parse, partone, parttwo and bin which are not implemented here.
 */

int Fsize=50;  /*big enough for our formulas*/

int numberOfBrackets = 0;
int lengthOfString = 0;
int store = 0;
int number_of_connectives = 0;

char bin(char *g);
char *partone(char *g);
char *parttwo(char *g);
char *string[];
char connectives[];

int parse(char *g)
/* returns 0 for non-formulas, 1 for atoms, 2 for negations, 3 for binary connective fmlas, 4 for existential and 5 for universal formulas.*/
{
    if (*g == 'X') {
        if (*(g+1) == '[') {
            if (*(g+2) == 'x' || *(g+2) == 'y' || *(g+2) == 'z') {
                if (*(g+3) == 'x' || *(g+3) == 'y' || *(g+3) == 'z') {
                    if (*(g+4) == ']') {
                        if(*(g + 5) == '\0') {
                            return 1;
                        } else {
                            return 0;
                        }
                    }
                    return 0;
                }
                return 0;
            }
            return 0;
        }
        return 0;
    }
    
    if (*g == '-') {
        if (parse(g+1) != 0) {
            return 2;
        }
    }
    
    if (*g == 'E') {
        if (*(g+1) == 'x' || *(g+1) == 'y' || *(g+1) == 'z') {
            if (parse(g+2) > 0) {
                return 4;
            }
        }
    }
    
    if (*g == 'A') {
        if (*(g+1) == 'x' || *(g+1) == 'y' || *(g+1) == 'z') {
            if (parse(g+2) > 0) {
                return 5;
            }
        }
    }
    
    if (*g == '(') {
        numberOfBrackets++;
        lengthOfString++;
        
        bin(g+1);
        
        long len2 = strlen(g) - lengthOfString;
        string[store] = malloc(lengthOfString); // one for the null terminator
        memcpy(string[store], g+1, lengthOfString - 2);

        string[store][lengthOfString - 1] = '\0';
        store++;
        
        string[store]= malloc(len2 + 1); // one for the null terminator
        memcpy(string[store], g+lengthOfString, len2 - 1);
        
        string[store][len2 - 1] = '\0';
        store++;
        
        printf("%s, %s \n", string[store - 2], string[store - 1]);
        string[store] = string[store - 1];
        
        lengthOfString = 0;
        numberOfBrackets = 0;
        
        if (parse(string[store - 2]) != 0) {
            
            if (parse(string[store]) != 0) {
                printf("hello \n");
                for (int i = 0; i < store; i++) {
                    printf("%s,\n", string[i]);
                }

                return 3;
                
            }
        }
    }
   
    return 0;
}

char *partone(char *g)
/*
 Given a formula (A*B) this should return A
 */
{
    printf("%s \n", g);
    return string[1];
}

char *parttwo(char *g)
/*
 Given a formula (A*B) this should return B
 */
{
    return string[2];
}

char bin(char *g)
/*
 Given a formula (A*B) this should return the character *
 */
{
    
    if (numberOfBrackets == 1) {
        
        if (*g == 'v' || *g == '^' || *g == '>' || *g == '<') {
            
            lengthOfString++;
            
            return *g;
        }
    }
        
    if (*g == '(') {
        numberOfBrackets++;
            
    }
    
    if (*g == ')') {
        numberOfBrackets--;
    }
        
    if (lengthOfString == strlen(g)) {
        return 0;
    }
    
    lengthOfString++;
    
    return bin(g+1);
        
}

int main()
{
    /*Input a string and check if its a formula*/
    char *name=malloc(Fsize);
    printf("Enter a formula: ");
    scanf("%s", name);
    string[store] = name;
    store++;
    int p=parse(name);
    switch(p)
    {
        case 0: printf("Not a formula \n");break;
        case 1: printf("An atomic formula \n");break;
        case 2: printf("A negated formula \n");break;
        case 3: printf("A binary connective formula \n");break;
        case 4: printf("An existential formula \n");break;
        case 5: printf("A universal quantifier \n");break;
        default: printf("Not a formula \n");break;
    }
    
    if (p==3) {
        printf("The first part is %s, the binary connective is %c, the second part is %s", partone(string[0]), bin(name), parttwo(string[1]));
    }
    return(1);
}
