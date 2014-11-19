#include		<stdio.h>
#include		<stdlib.h>

#define CrosLNode struct crosLNode
#define  ElemType int
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
	newnode->row=row;
	newnode->column=column;
	newnode->val=val;
	tmp=Clist[row]->right;
	now=Clist[row];
	for(;tmp!=Clist[row]&&(column>tmp->column);){
		now=tmp;
		tmp=now->right;
	}
	now->right=newnode;
	newnode->right=tmp;
	tmp=Clist[column]->down;
	now=Clist[column];
	for(;tmp!=Clist[column]&&(row>tmp->row);){
		now=tmp;
		tmp=now->down;
	}
	now->down=newnode;
	newnode->down=tmp;
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

int main(void){
	void CreateClist(int,CrosLNode**),PrintClist(CrosLNode**,int),ClearClist(CrosLNode**,int);
	int row=0,column=0,count_size=0,count_not_zero=0,i=42,j=42,InsertClist(CrosLNode**,CrosLNode*,ElemType,int,int);
	ElemType	k=42,val=0,* con;//存储一行或一列
	CrosLNode ** ClistA,** ClistB,** ClistC,**ClistD;
	CrosLNode* node,*tmp=NULL,*now=NULL;
	scanf("%d",&row);
	scanf("%d",&column);
	scanf("%d",&count_not_zero);
	count_size=(row>=column)?row:column;
	ClistA=(CrosLNode**)malloc(count_size*sizeof(CrosLNode*));
	con=(ElemType*)malloc(count_size*sizeof(ElemType));for(j=0;j<count_size;j++) con[j]=0;
	CreateClist(count_size,ClistA);
	for(i=0;i<count_not_zero;){
		scanf("%d",&row);
		scanf("%d",&column);
		scanf("%d",&val);
		if(val){
		node =(CrosLNode*)malloc(sizeof(CrosLNode));
		InsertClist(ClistA,node,val,row,column);
		i++;
		}
	}

	//转置
	for(i=0;i<count_size;i++){
		now=ClistA[i];tmp=ClistA[i]->down;
		for(;tmp!=ClistA[i];){
			node =(CrosLNode*)malloc(sizeof(CrosLNode));
			now=tmp;
			printf("%d %d %d\n",now->column,now->row,now->val);
			tmp=now->down;
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
		now=ClistA[i];tmp=ClistA[i]->down;
		for(;tmp!=ClistA[i];){
			now=tmp;
			tmp=now->down;
			con[now->row]+=now->val;
		}
		for(j=0;j<count_size;j++) {
			if(con[j]) {
				printf("%d %d %d\n",i,j,con[j]);
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
			now=ClistA[j];tmp=ClistA[j]->right;
			for(;tmp!=ClistA[j];){
				now=tmp;
				tmp=now->right;
				if(con[now->column]) k+=con[now->column]*now->val;
			}
			if(k!=0){
				printf("%d %d %d\n",i,j,k);
			}
		}
		for(j=0;j<count_size;j++) con[j]=0;
	}


	//相乘
	//		PrintClist(ClistA,count_size);
//	ClearClist(ClistA,count_size);
//	free(con);
	return 0;
}
