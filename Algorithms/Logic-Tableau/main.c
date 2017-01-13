#include <stdio.h>
#include <string.h>   /* for all the new-fangled string functions */
#include <stdlib.h>     /* malloc, free, rand */

typedef struct tableau {
    char *root;
    struct tableau *left;
    struct tableau *right;
    struct tableau *parent;
}*tab, *node, *node1, *kid, *pa;

int Fsize=50;
int cases=11;
int i;
int j;
struct tableau endPoint = {NULL, NULL, NULL, NULL};

int parse(char *g);
int indexVal(char *g);
int closed(struct tableau *t);
int iterate(struct tableau *node, struct tableau **nodeArray, int counter);
char bin(char *g);
char *substring(char *g, int startIndex, int endIndex);
struct tableau *complete(struct tableau *t);

int parse(char *g)
{
    if (*g == 'p' || *g == 'q' || *g == 'r' || *g == 's') return 1;
    
    if (*g == '-') {
        if (parse(g+1) != 0) { return 2;}
    }
    
    if (*g == '(') {
        if (parse(substring(g, 1, indexVal(g) - 1)) != 0 && parse(substring(g, indexVal(g) + 1, (int)strlen(g) - 2)) != 0) {
            if (*(g+indexVal(g) + 2) != '^' && *(g+indexVal(g) + 2) != '>' && *(g+indexVal(g) + 2) != 'v') { return 3;}
        }
    }
    return 0;
}

int indexVal(char *g) {
    int i = 0, bracket = 0;
    for (i = 0; i < strlen(g); i++) {
        if (*(g+i) == '(') bracket++;
        if (*(g+i) == ')') bracket--;
        if (bracket == 1) {
            if (*(g+i) == '^' || *(g+i) == '>' || *(g+i) == 'v') return i;
        }
    }
    return -1; // Should not return -1
}

char *substring(char *g, int startIndex, int endIndex) {
    char *outString = malloc(sizeof(char) * (endIndex - startIndex + 1));
    memcpy(outString, g + startIndex, endIndex - startIndex + 1);  
    outString[endIndex] = '\0';
    return outString;
}

char bin(char *g) {
    return *(g+indexVal(g));
}

struct tableau **getAllLeafNodes(struct tableau *rootNode, struct tableau **nodeArray) {
    nodeArray[iterate(rootNode, nodeArray, 0)] = &endPoint;
    return nodeArray;
}

int iterate(struct tableau *node, struct tableau **nodeArray, int counter) {
    if ((node->left == NULL) && (node->right == NULL)) {
        nodeArray[counter++] = node;
        return counter;
    }
    if (node->left != NULL) {
        counter = iterate(node->left, nodeArray, counter);
    }
    if (node->right != NULL) {
        counter = iterate(node->right, nodeArray, counter);
    }
    return counter;
    
}

// 1 if closed and 0 if open
int isOpen(struct tableau node) {
    char *leafVal = node.root;
    struct tableau *tempNode = &node;
    while (tempNode->parent != NULL) {
        tempNode = tempNode->parent;
        if (!((*tempNode).root)) break;
        if (strncmp(leafVal, "-p", 2) == 0 && strncmp(tempNode->root, "p", 2) == 0) return 1;
        if (strncmp(leafVal, "-r", 2) == 0 && strncmp(tempNode->root, "r", 2) == 0) return 1;
        if (strncmp(leafVal, "-q", 2) == 0 && strncmp(tempNode->root, "q", 2) == 0) return 1;
        if (strncmp(leafVal, "p", 2) == 0 && strncmp(tempNode->root, "-p", 2) == 0) return 1;
        if (strncmp(leafVal, "r", 2) == 0 && strncmp(tempNode->root, "-r", 2) == 0) return 1;
        if (strncmp(leafVal, "q", 2) == 0 && strncmp(tempNode->root, "-q", 2) == 0) return 1;
        if (strncmp(leafVal, "s", 2) == 0 && strncmp(tempNode->root, "-s", 2) == 0) return 1;
        if (strncmp(leafVal, "-s", 2) == 0 && strncmp(tempNode->root, "s", 2) == 0) return 1;
    }
    return 0;
}

char *joinString(char *s1, char *s2) {
    int length = (int)(strlen(s1) + strlen(s2));
    char *str = (char*)malloc(sizeof(length) + 1);
    strcat(str, s1);
    strcat(str, s2);
    str[length] = '\0';
    return str;
}

struct tableau *newNode(char *name, struct tableau *parent) {
    struct tableau *node = (struct tableau*)malloc(sizeof(struct tableau));
    node->root = name;
    node->left = NULL;
    node->right = NULL;
    node->parent = parent;
    return node;
}

void alpha_ii_transform(struct tableau *t, char *secondChildRoot) {
    
    struct tableau **leafNodes = (struct tableau**)malloc(sizeof(struct tableau) * Fsize);
    leafNodes = getAllLeafNodes(t->left, leafNodes);
    int counter = 0;
    
    for (counter = 0; (leafNodes[counter]->root); counter++) {
        if (!(leafNodes[counter]->root)) break;
        if (isOpen(*leafNodes[counter]) == 0) {
            leafNodes[counter]->left = complete(newNode(secondChildRoot, leafNodes[counter]));
        }
    }
}

struct tableau *complete(struct tableau *t) {
    
    int formula = parse(t->root);
    
    if (isOpen(*t) == 0) {
        
        // Propositional formula
        if (formula == 1) return t;
        
        // Negation
        if (formula == 2) {
            
            if (strlen(t->root) == 2) {
                return t;
            } else if (*(t->root + 1) == '-') {
                char *newRoot = (char*)malloc(sizeof(strlen(t->root)));
                memcpy(newRoot, &(t->root)[2], strlen(t->root) - 2);
                complete(newNode(newRoot, t));
            } else if (bin(t->root) == '^') {
                t->left = complete(newNode(joinString("-", substring(t->root, 2, indexVal(t->root) - 1)), t));
                t->right = complete(newNode(joinString("-", substring(t->root, indexVal(t->root) + 1, (int)strlen(t->root) - 2)), t));
            } else if (bin(t->root) == 'v') {
                t->left = complete(newNode(joinString("-", substring(t->root, 2, indexVal(t->root) - 1)), t));
                alpha_ii_transform(t, joinString("-", substring(t->root, indexVal(t->root) + 1, (int)strlen(t->root) - 2)));
            } else if (bin(t->root) == '>') {
                t->left = complete(newNode(substring(t->root, 2, indexVal(t->root) - 1), t));
                alpha_ii_transform(t, joinString("-", substring(t->root, indexVal(t->root) + 1, (int)strlen(t->root) - 2)));
            }
        }
        
        // binary connective
        if (formula == 3) {
            char connective = bin(t->root);
            if (connective == '^') {
                t->left = complete(newNode(substring(t->root, 1, indexVal(t->root) - 1), t));
                alpha_ii_transform(t, substring(t->root, indexVal(t->root) + 1, (int)strlen(t->root) - 2));
            } else if (connective == 'v') {
                t->left = complete(newNode(substring(t->root, 1, indexVal(t->root) - 1), t));
                t->right = complete(newNode(substring(t->root, indexVal(t->root) + 1, (int)strlen(t->root) - 2), t));
            } else if (connective == '>') {
                t->left = complete(newNode(joinString("-", substring(t->root, 1, indexVal(t->root) - 1)), t));
                t->right = complete(newNode(substring(t->root, indexVal(t->root) + 1, (int)strlen(t->root) - 2), t));
            }
        }
    }
    return t;
}

int closed(struct tableau *t) {
    
    struct tableau **ln = (struct tableau**)malloc(sizeof(struct tableau) * Fsize);
    ln = getAllLeafNodes(t, ln);
    
    int iter = 0;
    struct tableau *n = ln[0];
    
    while (n->root) {
        if (isOpen(*n) == 0) {
            free(ln);
            return 0;
        }
        n = ln[iter++];
    }
    free(ln);
    return 1;
}


int main()

{ /*input a string and check if its a propositional formula */
    
    
    
    char *name = malloc(Fsize);
    FILE *fp, *fpout;
    
    /* reads from input.txt, writes to output.txt*/
    if ((  fp=fopen("/Users/nathanliu/Documents/Programming/COMP101/tree/tree/input.txt","r"))==NULL){printf("Error opening file");exit(1);}
    if ((  fpout=fopen("/Users/nathanliu/Documents/Programming/COMP101/tree/tree/output.txt","w"))==NULL){printf("Error opening file");exit(1);}
    
    int j;
    for(j=0;j<cases;j++)
    {
        fscanf(fp, "%s",name);/*read formula*/
        switch (parse(name))
        {
            case(0): fprintf(fpout, "%s is not a formula.  ", name);break;
            case(1): fprintf(fpout, "%s is a proposition.  ", name);break;
            case(2): fprintf(fpout, "%s is a negation.  ", name);break;
            case(3):fprintf(fpout, "%s is a binary.  ", name);break;
            default:fprintf(fpout, "What the f***!  ");
        }
        
        /*make new tableau with name at root, no children, no parent*/
        
        struct tableau t={name, NULL, NULL, NULL};
        
        /*expand the root, recursively complete the children*/
        if (parse(name)!=0)
        { complete(&t);
            if (closed(&t)) fprintf(fpout, "%s is not satisfiable.\n", name);
            else fprintf(fpout, "%s is satisfiable.\n", name);
        }
        else fprintf(fpout, "I told you, %s is not a formula.\n", name);
    }
    
    fclose(fp);
    fclose(fpout);
    free(name);
    
    return(0);
}








