#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>
#define INF 16777215;


int v=0,e=0,v1=0,v2=0,weight=0,sum=0,i=0,*d=NULL,*Path=NULL,*rank,*parent,c=0;
bool* Inqueue;

typedef struct _Edge
{
 int from;
 int to;
 int weight;
 bool selected;
}edge;
edge *Pedge=NULL;

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
//SPFA最短路径
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
//快排排边升序
void fast_sort(edge *a,int size) 

{
		int i=0,j=size-1;
		edge val=a[0];
		if(size>1){
			while(i<j){
				for(;i<j;j--)
				if(a[j].weight<val.weight){
					a[i++]=a[j];
					break;
				}
				for(;i<j;i++)
				if(a[i].weight>val.weight){
					a[j--]=a[i];
					break;
				}
			}
			a[i]=val;
			fast_sort(a,i);
			fast_sort(a+i+1,size-i-1);
		}
}




int find_set(int x)
{
	 if(x != parent[x] )
	   parent[x] = find_set(parent[x]);
	  return parent[x];
}

void union_set(int x,int y,int w)
{
	 if(x==y)
	   return;
	  if(rank[x]>rank[y])
		  parent[y]=x;
		 else
		  {
				  if(rank[x]==rank[y])
					   rank[y]++;
					  parent[x]=y;
						 }
		  sum +=w;
}





void kruskal(){
fast_sort(Pedge,e);
for(i=0;i<e;i++){
		int x,y;
		x = find_set(Pedge[i].from);
		y = find_set(Pedge[i].to);
		if(x != y )
		{
		c++;
		Pedge[i].selected = true;
		//合并不会形成回路的二个集合
		union_set(x,y,Pedge[i].weight);
		}
}
}

int main(void)
{
int flag=1;
scanf("%d",&v);
scanf("%d",&e);
vexs=(VNode*)malloc(v*sizeof(VNode));
Pedge=(edge*)malloc(e*sizeof(edge));
d=(int*)malloc(v*sizeof(int));
Path=(int*)malloc(v*sizeof(int));
parent=(int*)malloc(v*sizeof(int));
rank=(int*)malloc(v*sizeof(int));
//距离数组初始化

for(i=0;i<e;i++){
scanf("%d",&v1);
scanf("%d",&v2);
scanf("%d",&weight);

insert(v1,v2,weight);
insert(v2,v1,weight);

Pedge[i].from=v1;
Pedge[i].to=v2;
Pedge[i].weight=weight;
Pedge[i].selected=false;

  parent[v1] = v1;
  parent[v2] = v2;
	rank[v1] = 0;
	rank[v2] = 0;
}

SPFA(0);
for(i=1;i<v;i++){
if(d[i]==100000) {
	d[i]=INF;
  Path[i]=-1;
	flag=0;}
printf("%d %d %d\n",i,d[i],Path[i]);
}
if(flag) {
	kruskal();
printf("%d %d\n",c,sum);
for(i=0;i<e;i++)
	  {
			   if(Pedge[i].selected)
				 printf("%d %d %d\n",Pedge[i].from,Pedge[i].to,Pedge[i].weight);									  
		}
	 }
else {printf("0 0\n");}
return 0;
}
