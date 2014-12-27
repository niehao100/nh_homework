#include<stdio.h>
#include<stdlib.h>
#include<math.h>
//先列后行

//本次只用到矩阵乘以向量
void times(double** A,double* B,double* C,int m_a,int m_b){
		int r_a=0,r_b=0,i=0,j=0;
		for(r_a=0;r_a<m_a;r_a++){
				C[r_a]=0;
				for(r_b=0;r_b<m_b;r_b++)
					C[r_a]+=A[r_b][r_a]*B[r_b];
		}
}
//仅使用于三角阵
void inv(double** A,double* b,double* x,int n){
		int i=0,j=0;
		double tmp=0;
		for(i=n-1;i>-1;i--){
				tmp=b[i];
				for(j=n-1;j>i;j--)
						tmp-=x[j]*A[j][i];
				x[i]=tmp/A[i][i];
		}
		
		/*
		for(i=n-1;i>-1;i--) {
			C[i][i]=1/A[i][i];
		  for(j=i-1;j>-1;j--){
				C[i][j]-=A[i][j]/(A[j][j]*A[i][i]);
			}
		}*/
}
void htimes(double* u,double* v,int n){
	//求u-2*vTu*v/(vTv)
	double vTu=0,vTv=0;
	int i=0;
	for(i=0;i<n;i++){
		vTu+=v[i]*u[i];
		vTv+=v[i]*v[i];
	}
	for(i=0;i<n;i++)
		u[i]-=2*vTu*v[i]/vTv;

}

void Household_QR(double **A,int m,int n,double* b){
double* v=(double*)malloc(sizeof(double)*m),*x=(double*)malloc(sizeof(double)*n),** invA=NULL,error=0,_abs=0;
int r=0,c=0,i=0,j=0;
for(c=0;c<n;c++){
	//计算v
		_abs=0;
		for(r=c;r<m;r++)
				_abs+=A[c][r]*A[c][r];
		_abs=sqrt(_abs);
		for(r=0;r<c;r++)
				v[r]=0;
		if(A[c][c]>0)
				v[c]=A[c][c]+_abs;
		else		v[c]=A[c][c]-_abs;
		for(r=c+1;r<m;r++)
				v[r]=A[c][r];
		//变换
		for(i=0;i<n;i++)
				htimes(A[i],v,m);
		htimes(b,v,m);
		}

		invA=(double**)malloc(sizeof(double*)*n);
		for(i=0;i<n;i++)
		{	invA[i]=(double*)malloc(sizeof(double)*n);
				for(j=0;j<n;j++) invA[i][j]=0;
		}
for(i=0;i<n;i++) x[i]=0;
inv(A,b,x,n);
for(r=0;r<n;r++) printf("%lf\n",x[r]);
for(i=n;i<m;i++) error+=b[i]*b[i];
printf("%lf\n",sqrt(error));
}

int main(void){
int m=0,n=0,M=0,N=0,zero=0,i=0,j=0;
double **A=NULL,*b=NULL,s=0;
scanf("%d",&M);
scanf("%d",&N);
scanf("%d",&zero);
A=(double**)malloc(sizeof(double*)*N);
b=(double*)malloc(sizeof(double)*M);
for(i=0;i<N;i++){
		A[i]=(double*)malloc(sizeof(double)*M);
		for(j=0;j<M;j++) A[i][j]=0;
}
for(i=0;i<zero;i++){
		scanf("%d",&m);
		scanf("%d",&n);
		scanf("%lf",&s);
		if(s==0) i--;
		A[n][m]=s;
}
for(i=0;i<M;i++)
{
		scanf("%lf",&s);
		b[i]=s;
}
Household_QR(A,M,N,b);
return 0;
}

