#include <stdio.h>
#include <stdlib.h>
int N=0,M=0,*a=NULL,spre=0,l=1,spost=0,i=0,j=0;
unsigned long long*s1=NULL,*optiValuePost=NULL;

int Pre(int i){
		if(i==0){
			for(j=0,l=a[0];j<N&&l<=M;j++,l+=1+a[j]){
				s1[j]=(M-l)*(M-l);
				}
			spre=j;
			return 0;
		}

		if(i<spre) return 0;
		s1[i]=s1[i-1]+(M-a[i])*(M-a[i]);
		for(j=i-1,l=a[i];j>-1&&l<=M;j--){
					if((s1[j]+(M-l)*(M-l))<s1[i]){
						s1[i]=s1[j]+(M-l)*(M-l);
					//	printf("^%d^",j);
					}
					l+=a[j]+1;
		}
		return 0;
}

int Post(int i){
	int j=0;
		if(i==(N-1)){
			return optiValuePost[i]=0;
		}
		if(i>spost) {optiValuePost[i]=0; return 0;}

		optiValuePost[i]=optiValuePost[i+1]+(M-a[i])*(M-a[i]);
		for(j=i+1,l=a[i];j<N&&l<=M;j++){
				if(((M-l)*(M-l)+optiValuePost[j])<optiValuePost[i])
				{			optiValuePost[i]=((M-l)*(M-l)+optiValuePost[j]);
//						printf("^%d^",j);
				}
				l+=a[j]+1;
		}
}

int main(void){
		unsigned long long P=0,t=0;
		int f_last=0,s_first=1,j=0;
		scanf("%d",&N);
		scanf("%d",&M);
		a=(int*)malloc(sizeof(int)*N);
		optiValuePost=(unsigned long long*)malloc(sizeof(unsigned long long)*(1+N));
		s1=(unsigned long long*)malloc(sizeof(unsigned long long)*(1+N));
		optiValuePost[N]=0;
			
		for(i=0;i<N;i++){
				scanf("%d",a+i);
		}

		for(l=a[N-1],spost=N-1;l<=M&&spost>-1;spost--,l+=a[spost]+1);
		for(i=0;i<N;i++){
			Pre(i);
		}	
//		  printf("^%d^\n",s1[N-2]);
		for(i=N-1;i>-1;i--)		{
			Post(i);
		}
	//		printf("%d|\n",optiValuePost[0]);
		P=optiValuePost[1];
		for(i=N-2;i>-1;i--){
				l=a[i];
				if(i==0) t=0;
				else t=s1[i-1];
				for(j=i+1;l<=M&&j<N;j++){
					if((t+optiValuePost[j])<P){
						f_last=i;s_first=j;
						P=t+optiValuePost[j];
					}
					if((t+optiValuePost[j])==P){
								if(f_last!=i) {
									s_first=j;
								  f_last=i;
								}
				  }
					l+=a[j]+1;
				}
		}
		printf("%lu %d %d\n",P,f_last,s_first);
		return 0;
}
