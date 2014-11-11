#include<stdio.h>
#include<stdlib.h>
#include<string.h>
//二叉搜索树
#define Tnode struct tnode

typedef int Elemtype;

struct tnode{
		Elemtype data;
		int count;
		Tnode* Tleft;
		Tnode* Tright;
		Tnode* parent;
};

Tnode* CreateTree(); //建树   
Tnode* insert(Tnode* root, Elemtype data);//插入节点   
 
Tnode* CreateTree(){  
    Tnode* root = NULL, *newNode = (Tnode*)malloc(sizeof(Tnode));   
    Elemtype temp = 0; 
    int i=0,count=0;
    scanf("%d", &count); 
    if(count==0) return root;
    scanf("%d", &temp);
    newNode->data = temp ;
    newNode->count = 1;
    newNode->Tleft = NULL;  
    newNode->Tright = NULL;
		root = newNode;
    for(i=1;i<count;i++){  
        scanf("%d", &temp);    
        insert(root, temp);    
    }  
      
    return root;   
} 

Tnode* insert(Tnode* root, Elemtype data){  
    Tnode* ptr = root;  
    Tnode* tempNode;   
    Tnode* newNode = (Tnode*)malloc(sizeof(Tnode));   
    //初始化元素
    newNode->data = data ;  
    newNode->count = 1;
    newNode->Tleft = NULL;  
    newNode->Tright = NULL;  
      
    
    while(ptr != NULL){  
        tempNode = ptr;
        ptr->count++;
        if(data < ptr->data)  
            ptr = ptr->Tleft;   
        else  
            ptr = ptr->Tright;   
              
    }   
          
     if(data < tempNode->data ){  
        tempNode->Tleft =  newNode;   
        }else{  
           tempNode->Tright =  newNode;   
        
        }   
      
    return root;   
} 

void InBTree(Tnode* root,char* s){  
    if(root != NULL){  
        InBTree(root->Tleft,s);   
        printf("%d ", root->data);   
				strcat(s,"1 ");
        InBTree(root->Tright,s);  
    }  
    else{  printf("# "); strcat(s,"# ");} 
}  

void InBTree_without_std(Tnode* root,char* s){  
    if(root != NULL){  
        InBTree_without_std(root->Tleft,s);   
				strcat(s,"1 ");
        InBTree_without_std(root->Tright,s);  
    }  
    else   strcat(s,"# "); 
}

void PreBTree(Tnode* root,char* s){  
    if(root != NULL){  
        printf("%d ", root->data);
				strcat(s,"1 ");
        PreBTree(root->Tleft,s);   
        PreBTree(root->Tright,s);  
    } 
    else {printf("# ");strcat(s,"# "); }
}   


void PreBTree_without_std(Tnode* root,char* s){  
    if(root != NULL){  
				strcat(s,"1 ");
        PreBTree_without_std(root->Tleft,s);   
        PreBTree_without_std(root->Tright,s);  
    } 
    else {strcat(s,"# "); }
}
void BackBTree(Tnode* root){  
    if(root != NULL){  
        BackBTree(root->Tleft);   
        BackBTree(root->Tright);  
        printf("%d ", root->data);  
    }  
    else printf("# "); 
}


int BTreeDepth(Tnode*root)
{
    if(root == NULL)
        return 0;
    //计算左子树深度
    int dpt1 = BTreeDepth(root->Tleft);
    //计算右子树深度
    int dpt2 = BTreeDepth(root->Tright);
    //返回树的深度
    if(dpt1 > dpt2)
        return dpt1+1;
    else
        return dpt2+1;
}

//kmp算法比较字符串,改编自讲义
void Next(char *T, int* N)
{
	int m = strlen(T);
	N[0] = 0;
	int i=1, j=0;
	while(i<m){
		if(T[i]==T[j]){ //已经比较了j+1个字符
			N[i] = j+1; //部分匹配串长度加1
			i++; j++;
		}else{
			if(j>0) j=N[j-1];//用部分匹配串对齐
			else N[i++]=0; //串头时部分匹配串长0
		}
	}
}

int Compare(char* s0,char* s1){
int * next=(int*)malloc(strlen(s1)*sizeof(int)),n=strlen(s0), m=strlen(s1), i=0, j=0,same_count=0;
	Next(s1,next);
	while(i<n){
		if(s0[i]==s1[j]){ //已匹配j+1个字符
			if(j==m-1) {
				same_count++; //匹配成功
				i++;
			}
			else {i++; j++;}}
		else{
			if(j>0) j=next[j-1]; //失配移动模式串
			else i++; }
	}
	return same_count; //匹配失败
}




int main(void){
    Tnode* CreateTree(),* root=CreateTree(),*search=CreateTree();
		void InBTree(Tnode*,char*),InBTree_without_std(Tnode*,char*),PreBTree(Tnode*,char* ),BackBTree(Tnode*);
    int deep0=BTreeDepth(root),deep1=BTreeDepth(search),same=0;
		char* s0=(char*)malloc(4096*sizeof(char)),*s1=(char*)malloc(4096*sizeof(char)),*s2=(char*)malloc(4096*sizeof(char)),*s3=(char*)malloc(4096*sizeof(char));
    PreBTree(root,s0);
    printf("\n");
    InBTree(root,s1);
    printf("\n");
    BackBTree(root);
    printf("\n");
    printf("%d\n", deep0);
		PreBTree_without_std(search,s2);
		printf("%d\n",Compare(s0,s2));
		return 0;
    
}
