#include		<stdio.h>
#include		<stdlib.h>

#define CrosLNode struct crosLNode
#define  ElemType long
struct crosLNode		//节点的定义
{
	int row,column;
	ElemType val;
	CrosLNode *down,*right;
};

void CreateClist(int count_size,CrosLNode** Clist)
{
	int i=42;
	for(i=0;i<count_size;i++)
	{
		Clist[i]=(CrosLNode*)malloc(sizeof(CrosLNode));
		Clist[i]->val=0;
		Clist[i]->row=Clist[i]->column=i;
		Clist[i]->right=Clist[i];
		Clist[i]->down=Clist[i];
	}
}

int InsertClist(CrosLNode** Clist,CrosLNode * newnode,ElemType val,int row,int column){
	CrosLNode* tmp=NULL,*now=NULL;
	if(!val) return 0;
	newnode->row=row;
	newnode->column=column;
	newnode->val=val;
	tmp=Clist[row]->right;
	now=Clist[row];
	for(;tmp!=Clist[row]||(row>now->row&&row<tmp->row);){
		now=tmp;
		tmp=now->right;
	}
	now->right=newnode;
	tmp=Clist[column]->down;
	now=Clist[column];
	for(;tmp!=Clist[column]||(column>now->column&&column<tmp->column);){
		now=tmp;
		tmp=now->down;
	}
	now->down=newnode;
	newnode->right=Clist[row];
	newnode->down=Clist[column];
	return 1;
}

void ClearClist(CrosLNode** Clist,int count){
	int i=0;
	CrosLNode* tmp=NULL,*now=NULL;
	for(i=0;i<count;i++){
		now=Clist[i];tmp=Clist[i]->right;
		for(;now!=Clist[i];){
			now=tmp;
			free(now);
			tmp=now->right;
		}
		free(Clist[i]);
	}
	free(Clist);
}

void PrintClist(CrosLNode** Clist,int count){
	int i=0;
	CrosLNode* tmp=NULL,*now=NULL;
	for(i=0;i<count;i++){
		now=Clist[i];tmp=Clist[i]->right;
		for(;tmp!=Clist[i];){
			now=tmp;
			if(now->val)
			printf("%d %d %ld\n",now->row,now->column,now->val);
			tmp=now->right;
		}
	}
}

int main(void){
	void CreateClist(int,CrosLNode**),PrintClist(CrosLNode**,int),ClearClist(CrosLNode**,int);
	int row=0,column=0,count_size=0,count_not_zero=0,i=42,j=42,InsertClist(CrosLNode**,CrosLNode*,ElemType,int,int);
	long	k=42,val=0,* con;//存储一行或一列
	CrosLNode ** ClistA,** ClistB,** ClistC,**ClistD;
	CrosLNode* node,*tmp=NULL,*now=NULL;
	scanf("%d",&row);
	scanf("%d",&column);
	scanf("%d",&count_not_zero);
	count_size=(row>=column)?row:column;
	ClistA=(CrosLNode**)malloc(count_size*sizeof(CrosLNode*));
	ClistB=(CrosLNode**)malloc(count_size*sizeof(CrosLNode*));
	ClistC=(CrosLNode**)malloc(count_size*sizeof(CrosLNode*));
	ClistD=(CrosLNode**)malloc(count_size*sizeof(CrosLNode*));
	con=(long*)malloc(count_size*sizeof(long));for(j=0;j<count_size;j++) con[j]=0;
	CreateClist(count_size,ClistA);
	CreateClist(count_size,ClistB);
	CreateClist(count_size,ClistC);
	CreateClist(count_size,ClistD);
	for(i=0;i<count_not_zero;i++){
		scanf("%d",&row);
		scanf("%d",&column);
		scanf("%ld",&val);
		node =(CrosLNode*)malloc(sizeof(CrosLNode));
		InsertClist(ClistA,node,val,row,column);
	}

	//转置
	for(i=0;i<count_size;i++){
		now=ClistA[i];tmp=ClistA[i]->right;
		for(;tmp!=ClistA[i];){
			node =(CrosLNode*)malloc(sizeof(CrosLNode));
			now=tmp;
			InsertClist(ClistB,node,now->val,now->column,now->row);
			tmp=now->right;
		}
	}
	//转置

	//相加
	for(i=0;i<count_size;i++){
		now=ClistA[i];tmp=ClistA[i]->right;
		for(;tmp!=ClistA[i];){
			now=tmp;
			tmp=now->right;
			con[now->column]=now->val;
		}
		now=ClistB[i];tmp=ClistB[i]->right;
		for(;tmp!=ClistB[i];){
			now=tmp;
			tmp=now->right;
			con[now->column]+=now->val;
		}
		for(j=0;j<count_size;j++) {
			if(con[j]) {
				node =(CrosLNode*)malloc(sizeof(CrosLNode));
				InsertClist(ClistC,node,con[j],i,j);
				con[j]=0;
			}
		}
	}
	//相加
	//相乘
	for(i=0;i<count_size;i++){
		now=ClistA[i];tmp=ClistA[i]->right;
		for(;tmp!=ClistA[i];){
			now=tmp;
			tmp=now->right;
			con[now->column]=now->val;
		}
		for(j=0;j<count_size;j++){
			k=0;
			now=ClistB[j];tmp=ClistB[j]->down;
			for(;tmp!=ClistB[j];){
				now=tmp;
				tmp=now->down;
				if(con[now->row]) k+=con[now->row]*now->val;
			}
			if(k!=0){
				node =(CrosLNode*)malloc(sizeof(CrosLNode));
				InsertClist(ClistD,node,k,i,j);
			}
		}
		for(j=0;j<count_size;j++) con[j]=0;
	}


	//相乘
	//		PrintClist(ClistA,count_size);
	PrintClist(ClistB,count_size);
	PrintClist(ClistC,count_size);
	PrintClist(ClistD,count_size);
	ClearClist(ClistA,count_size);
	ClearClist(ClistB,count_size);
	ClearClist(ClistC,count_size);
	ClearClist(ClistD,count_size);
	free(con);
	return 0;
}
