#include <stdio.h>
#include <stdlib.h>
#include "rb.h"
int main(void){
	PMMADDRESS_NODE  pn[11];
	MM_AVL_TABLE root;
	int rol[11]={6,8,4,10,3,5,0,1,2,7,9};
	int i=0;
	root.BalancedRoot.RightChild=NULL;
	root.NumberGenericTableElements=0;
	root.DepthOfTree=0;
	for(i=0;i<11;i++){
		pn[i]=(PMMADDRESS_NODE)malloc(sizeof(MMADDRESS_NODE));
		 pn[i]->StartingVpn=i;
		 pn[i]->EndingVpn=i;
		 pn[i]->u1.Parent=NULL;
		 pn[i]->RightChild=NULL;
		 pn[i]->LeftChild=NULL;
		MiInsertNode (pn[i],&root);
	}
	for(i=0;i<11;i++){
		MiRemoveNode (pn[rol[i]],&root);
	}
	return;
}