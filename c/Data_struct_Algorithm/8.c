#include<stdio.h>
#include<stdlib.h>

int Add(char* A,char *B,int size){
		int i=0,count=0,tmp=0;
		for(i=size-1;i>-1;i--){
				tmp=((A[i]+B[i]+count)>9)?1:0;
				A[i]=(A[i]+B[i]+count)%10;
				count=tmp;
		}
		if(count) return 1;
		return 0;
}

int Div(char* A,int x,int size){
		int iter=0,flag=0,tmp=0;		
		for(iter=0;iter<size;iter++){
				flag*=10;
				if((A[iter]+flag)>x){
						tmp=(int)((A[iter]+flag)/x);
						flag=(A[iter]+flag)%x;
						A[iter]=tmp;
				}
				else {flag+=A[iter];A[iter]=0;}
		}
		return 0;
}


int main (void)
{
	int k=0,n=0,i=0,j=0;
	char* tmp=NULL,*A=NULL;//A存储最后的结果
	scanf("%d",&k);
	scanf("%d",&n);
  tmp=(char*)malloc(sizeof(char)*n+10);
	A=(char*)malloc(sizeof(char)*n+10);
  tmp[k-1]=1;
	Div(tmp,2,n+10);
	for(i=0;i<n+10;i++) A[k]=tmp[k];

	for(j=1;;j++){
		if((n-j*k+10)<0) break;
		Div(tmp,j+2,n-j*k+10);
		Add(A+j*k,tmp,n-j*k+10);
  }
	printf("1.");
		for(i=5;i>-1;i--) if(A[n+i]>5) A[n+i-1]++;
		for(i=0;i<n;i++) printf("%d",A[i]);
		return 0;
}
