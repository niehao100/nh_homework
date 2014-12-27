#include<stdio.h>
#include<stdlib.h>

long Cal1(long a,int * n){//a 需要计算的数

	if(a!=1){
		(*n)++;
		if(a%2==1) return 3*a+1;
		return a/2;
	}
	return 1;
}
long Cal2(long a){//a 需要计算的数

	if(a!=1){
		if(a%2==1) return 3*a+1;
		return a/2;
	}
	return 1;
}
void Sort(long * a,int size) //快排
{
		int i=0,j=size-1;
		long val=a[0];
		if(size>1){
			while(i<j){
				for(;i<j;j--)
				if(a[j]<val){
					a[i++]=a[j];
					break;
				}
				for(;i<j;i++)
				if(a[i]>val){
					a[j--]=a[i];
					break;
				}
			}
			a[i]=val;
			Sort(a,i);
			Sort(a+i+1,size-i-1);
		}
}

int main(void){
		long Cal1(long,int*),Cal2(long),a=0,b=0;
		void Sort(long*,int);
		int n=0,max=0,i=0,k=0;
		scanf("%ld",&b);
		scanf("%d",&k);
		for(a=b;a!=1;)
		{
				a=Cal1(a,&n);
		}
		long * list=(long *)malloc((n+1)*sizeof(long));
		a=list[0]=b;	
		for(i=1;a!=1;)
		{
				a=list[i]=Cal2(a);
				i++;
		}
		Sort(list,n+1);
		printf("%ld\t",list[n+1-k]);		
		return 0;
}

