#include <stdio.h>
#include <stdlib.h>
int N=0,M=0,*a=NULL,spre=0,*s=NULL,l=1,spost=0,i=0;
unsigned long *optiValuePre=NULL,*optiValuePost=NULL;

//spre 本次循环时前一行最后的空格
int Pre(int i){
	int j=0;
		if(i==0){
			s[i]=M-a[i];
			return optiValuePre[i]=0;
		}
		if(i<spre) {
			optiValuePre[i]=0; 
			for(j=0,s[i]=M;j<i+1;j++)
				s[i]-=1+a[j];
		  s[i]++;
			return 0;
		}
		optiValuePre[i]=optiValuePre[i-1]+s[i-1]*s[i-1];
		for(j=i-1,l=a[i];l<M&&j>-1;j--){
				if((s[j]*s[j]+optiValuePre[j])<optiValuePre[i]){
						optiValuePre[i]=s[j]*s[j]+optiValuePre[j];
						s[i]=M-l;
				}
				l+=a[j]+1;
		}
		
}
//s记录每一行结束的位置，spre记录每一行的空格数

int Post(int i){
	int j=0;
		if(i==(N-1)){
			return optiValuePost[i]=0;
		}
		if(i>spost) {optiValuePost[i]=0; return 0;}

		optiValuePost[i]=optiValuePost[i+1]+(M-a[i])*(M-a[i]);
		for(j=i+1,l=a[i];j<N&&l<M;j++){
				if(((M-l)*(M-l)+optiValuePost[j])<optiValuePost[i])
					optiValuePost[i]=((M-l)*(M-l)+optiValuePost[j]);
				l+=a[j]+1;
		}
}

int main(void){
		unsigned long P=0,f_last=0,s_first=1,l=0,j=0;
		scanf("%d",&N);
		scanf("%d",&M);
		a=(int*)malloc(sizeof(int)*N);
		optiValuePre=(unsigned long*)malloc(sizeof(unsigned long)*N);
		optiValuePost=(unsigned long*)malloc(sizeof(unsigned long)*(1+N));
		s=(int*)malloc(sizeof(int)*(1+N));
		optiValuePost[N]=0;
				for(l=a[0],spre=1;l<M&&spre<N;spre++)
				l+=a[spre]+1;
		spre--;

		for(i=0;i<N;i++)
		{
				scanf("%d",a+i);
				Pre(i);
				printf("^%d^\n",optiValuePre[i]);
		}
		for(l=a[N-1],spost=N-2;l<M&&spost>-1;spost--)
				l+=a[spost]+1;
		spost++;

		for(i=N-1;i>-1;i--)
		{		Post(i);printf("%d|\n",optiValuePost[i]);}
		P=optiValuePre[0]+optiValuePost[1];
		for(i=N-2;i>-1;i--){
				l=a[i];
				for(j=i+1;l<M&&j<N;j++){
					if((optiValuePre[i]+optiValuePost[j])<P){
						f_last=i;s_first=j;
						P=optiValuePre[i]+optiValuePost[j];
					}
					if((optiValuePre[i]+optiValuePost[j])==P){
								if(f_last!=i) s_first=j;
								f_last=i;
				  }
					l+=a[j];
				}
		}
		printf("%d %d %d\n",P,f_last,s_first);
		return 0;
}
