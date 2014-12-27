//奇葩汉诺塔的解 无31 聂浩
#include<stdio.h>
#include <stdlib.h>


int main(void){
		void move(int,int);
		int n=0,i=0,j=0,k=0;
		scanf("%d",&n);
		k=n%2;
		for(i=0;i<n-1;i++){
				if((i+k)%2==0){
				printf("0 1\n");
				for(j=0;j<i;j++)
							printf("2 1\n");
		  	continue;
				}
		printf("0 2\n");
		for(j=0;j<i;j++)
					printf("1 2\n");
		}
		printf("0 2\n");

		for(i=0;i<n-1;i++){
				if(i%2!=0){
						for(j=0;j<n-2-i;j++) 
								printf("0 1\n");
						printf("0 2\n");
						}						
				else{
					for(j=0;j<n-2-i;j++)
							printf("1 0\n");
					printf("1 2\n");
				}
		}
return 0;
}

