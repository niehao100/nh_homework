#include<stdio.h>
#include<stdlib.h>
//二叉搜索树
#define Tnode sturct tnode
typedef int Elemtype;

struct tnode{
		Elemtype data;
		int count;
		Tnode* Tleft;
		Tnode* Tright;
		Tnode* parent;
}

Tnode* CreateTree(); //建树   
Tnode* insert(Tnode* root, DataType data);//插入节点   
void InBTree(Tnode* root); //中序遍历   
void PreBTree(Tnode* root); //先序遍历   
void PostBTree(BTree root);//后序遍历   

Tnode* CreateTree(){  
    BTree root = NULL;  
    ElemType temp = 0; 
    int i=0,count=0;
    scanf("%d", &count); 
    if(count==0) return root;
    scanf("%d", &temp);
    newNode->data = tmp ;
    newNode->count = 1;
    newNode->Tleft = NULL;  
    newNode->Tright = NULL;
    for(i=1;i<count;i++){  
        root = insert(root, temp);    
        scanf("%d", &temp);    
    }  
      
    return root;   
} 

Tnode* insert(BTree root, Elemtype data){  
    Tnode* ptr = root;  
    Tnode* tempNode;   
    Tnode* newNode = (BTree)malloc(sizeof(struct BTree));   
    //初始化元素
    ewNode->data = data ;  
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
          
     if(tempNode->data >= data){  
        tempNode->Tleft =  newNode;   
        }else{  
           tempNode->Tright =  newNode;   
        
        }   
      
    return root;   
} 

void InBTree(Tnode* root){  
    if(root != NULL){  
        InBTree(root->Tleft);   
        printf("%d ", root->data);   
        InBTree(root->Tright);  
    }  
    else printf("# "); 
}  

void PreBTree(Tnode* root){  
    if(root != NULL){  
        printf("%d ", root->data);   
        PreBTree(root->Tleft);   
        PreBTree(root->Tright);  
    } 
    else printf("# "); 
}   
void BackBTree(BTree root){  
    if(root != NULL){  
        BackBTree(root->Tleft);   
        BcakBTree(root->Tright);  
        printf("%d ", root->data);  
    }  
}

int main(void){
    Tnode* root=CreateTree();
    PreBTree(root);
    printf("\n");
    InBTree(root);
    printf("\n");
    BackTree(root);
    return 0;
}
