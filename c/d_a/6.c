#include<stdio.h>
#include<stdlib.h>

typedef struct _ENode
{
	    int ivex;                   // 该边的顶点的位置
		  int weight;                 // 该边的权
		  struct _ENode *next_edge;   // 指向下一条弧的指针
}ENode;

typedef struct _VNode
{
	    char data;              // 顶点信息
		  ENode *first_edge;      // 指向第一条依附该顶点的弧
		  ENode *last_edge;
}VNode;

void insert(int v1,int v2,int weight,VNode* vexs){
		ENode* tmp=(ENode*)malloc(sizeof(ENode));
		tmp->ivex=v2;
		tmp->weight=weight;
		tmp->next_edge=NULL;
		if(vexs[v1].last_edge)
		vexs[v1].last_edge->next_edge=tmp;
		else vexs[v1].first_edge=tmp;
		vexs[v1].last_edge=tmp;
}


int main(void)
{
		int v=0,e=0,v1=0,v2=0,weight=0,i=0;
		VNode* vexs=NULL;
		scanf("%d",&v);
		scanf("%d",&e);
		vexs=(VNode*)malloc(v*sizeof(VNode));
		for(i=0;i<e;i++){
			scanf("%d",&v1);
			scanf("%d",&v2);
		  scanf("%d",&weight);
			insert(v1,v2,weight,vexs);
		}
		return 0;
}
