#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>
#define INF 0xfffff;


int v=0,e=0,v1=0,v2=0,weight=0,i=0,*d=NULL,*Path=NULL;
bool* Inqueue;

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

VNode* vexs=NULL;
void insert(int v1,int v2,int weight){
ENode* tmp=(ENode*)malloc(sizeof(ENode));
tmp->ivex=v2;
tmp->weight=weight;
tmp->next_edge=NULL;
if(vexs[v1].last_edge)
vexs[v1].last_edge->next_edge=tmp;
else vexs[v1].first_edge=tmp;
vexs[v1].last_edge=tmp;
}
//SPFA
void SPFA(int S){
		int queue[4000];
		bool* Inqueue=(bool*)malloc(sizeof(bool)*v);
    for(i=1; i<=v; i++)
		{d[i] = 100000; Path[i]=0;}
    d[S] = 0;
    int closed = 0, open = 1;//队列的头和尾
    queue[1] = S;
    Inqueue[S] = true;
    while(1){
        closed++;
				if(closed>open) break;
        ENode *tmp = vexs[queue[closed]].first_edge;
				Inqueue[queue[closed]]=false;
        while(tmp != NULL){
            if( d[tmp->ivex] > d[queue[closed]] + tmp->weight ){
                d[tmp->ivex] = d[queue[ closed]] + tmp->weight;
                Path[tmp->ivex] = queue[closed];
                if(!Inqueue[tmp->ivex]){
								open++;
                queue[open] = tmp->ivex;
								Inqueue[tmp->ivex]= true;
								}
            }
            tmp = tmp->next_edge;
        }
		} 
}

int main(void)
{
scanf("%d",&v);
scanf("%d",&e);
vexs=(VNode*)malloc(v*sizeof(VNode));
d=(int*)malloc(v*sizeof(int));
Path=(int*)malloc(v*sizeof(int));
//距离数组初始化

for(i=0;i<e;i++){
scanf("%d",&v1);
scanf("%d",&v2);
  scanf("%d",&weight);
insert(v1,v2,weight);
insert(v2,v1,weight);
}
SPFA(0);
for(i=1;i<v;i++){
	printf("%d %d %d\n",i,d[i],Path[i]);
}
return 0;
}
