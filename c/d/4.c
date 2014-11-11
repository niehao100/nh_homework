#include<stdio.h>
#include<stdlib.h>

#define Tnode sturct tnode
typedef int Elemtype;

struct tnode{
		Elemtype k;
		Elemtype count;
		Tnode* lchild;
		Tnode* rchild;
		Tnode* parent;
}

