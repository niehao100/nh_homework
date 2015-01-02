#include<stdio.h>
#include<stdlib.h>
typedef struct _Hnode{
	int data;
	int flag;//判断是不是同一次查找
  struct _Hnode* next;
}hnode;
int *list,head=0,tail=-1,l1=0,l2,minsize=0,sol=0,i=0,if_repeat=0,sum1=0,sum2=0;

hnode  *hashtable[3000],**search=NULL;


unsigned int Hash(int x){
		x=x<<5;
		x=x|0xfffff12345000000;
		return abs(x);
}

void Push(int x){
	int countx=0;
	hnode* first=NULL;
  tail++;
  list[tail]=x;
 sol++;
 hnode* current =	hashtable[Hash(x)%3000];
 for(;current!=NULL;current=current->next){
	if(current->data==x){
		first=current;
		break;
	}
}
if(current==NULL) return;
for(;current!=NULL;current=current->next){
		if(current->data==x){
				if(current->flag==-1){
				current->flag+=2;
				sum1+=x;
				return;
				}
				break;
		}
}
if(first==NULL) return;
first->flag+=2;
sum1+=x;
if_repeat++;
}



int Pop(){
int tmp=list[head];
	  hnode* current =	hashtable[Hash(list[head])%3000];
  	for(;current!=NULL;current=current->next){
		if(current->data==list[head]) {
			if(current->flag!=-1) {
		  current->flag-=2;
			sum1-=tmp;
			if(current->flag>0) if_repeat--;
			break;
			}
		}
	}
	head++;
	sol--;
	return tmp;
}

int compare(){
int i=0,iter=0;
for(;if_repeat;) Pop();
if(sol<l1) return 0;
if(sum1!=sum2) return 0;
if(minsize>sol) minsize=sol;
return 1;
}

int main(void){
	int i=0,tmp=0;
	hnode* htmp=NULL,*current=NULL,*next=NULL;
	scanf("%d",&l1);
	scanf("%d",&l2);
	minsize=l2;
	search = (hnode**)malloc(sizeof(hnode*)*l1);
	list = (int*)malloc(sizeof(int)*l2);
	for(i=0;i<l1;i++){
		htmp=(hnode*)malloc(sizeof(hnode));
		htmp->flag=-1;
		scanf("%d",&(htmp->data));
		search[i]=htmp;
		sum2+=htmp->data;
		htmp->next=hashtable[Hash(htmp->data)%3000];
		hashtable[Hash(htmp->data)%3000]=htmp;
	}
  for(i=0;i<l2;i++){
	scanf("%d",&tmp);
	Push(tmp);
	while(compare()) Pop();

  }
printf("%d\n",minsize);
return 0;
}

