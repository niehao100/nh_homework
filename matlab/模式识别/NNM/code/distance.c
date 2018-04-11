/* This implementation of tangent distance by Daniel Keysers
   was adapted to MATLAB by Aditi Krishn and to R by Volodya Vovk (October 2014).
   Copyright (C) 2003 Daniel Keysers

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA */

#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>
#include "mex.h"
#define templatefactor1 0.1667
#define templatefactor2 0.6667
#define templatefactor3 0.08
#define additiveBrightnessValue 0.1

#define maxNumTangents 9

const double ortho_singular_threshold = 1e-9;

int orthonormalizePzero (double **A, const unsigned int num, const unsigned int dim)
{
  unsigned int n,m,d,dim1;
  double projection,norm,tmp;
  double projection1,projection2,projection3,projection4;
  double *A_n, *A_m;

  dim1=dim-dim%4;

  for (n=0; n<num; ++n) {
    A_n=(double*)A[n];
    for (m=0; m<n; ++m) {
      A_m=(double*)A[m];
      projection=0.0;
      projection1=0.0;
      projection2=0.0;
      projection3=0.0;
      projection4=0.0;
      for (d=0; d<dim1; d+=4) {
	projection1+=A_n[d]*A_m[d]; 
	projection2+=A_n[d+1]*A_m[d+1]; 
	projection3+=A_n[d+2]*A_m[d+2]; 
	projection4+=A_n[d+3]*A_m[d+3]; }
      projection=projection1+projection2+projection3+projection4;
      for (; d<dim; ++d) {
	projection+=A_n[d]*A_m[d];}
      for (d=0; d<dim1; d+=4) {
	A_n[d]-=projection*A_m[d];
	A_n[d+1]-=projection*A_m[d+1];
	A_n[d+2]-=projection*A_m[d+2];
	A_n[d+3]-=projection*A_m[d+3];}
      for (; d<dim; ++d) {
	A_n[d]-=projection*A_m[d];}
    }
    norm=0.0;
    for (d=0; d<dim; ++d) {
      tmp=A_n[d];
      norm+=tmp*tmp;}
    if (norm<ortho_singular_threshold) {
      norm=0.0;}
    else {
      norm=1.0/sqrt(norm);}
    for (d=0; d<dim; ++d) {
      A_n[d]*=norm;}
  }

  return 0;
}
int tdIndex(int y, int x, int width){
  return y*width+x;
}


int calculateTangents(const double * image, double ** tangents, const int numTangents,
                      const int height, const int width, const int * choice, const double background){
  int j,k,ind,tangentIndex,maxdim;
  double tp,factorW,offsetW,factorH,factor,offsetH,halfbg;
  double *tmp, *x1, *x2, *currentTangent;
  
  int size=height*width;
  maxdim=(height>width)?height:width;

  tmp=(double*)malloc(maxdim*sizeof(double));
  x1=(double*)malloc(size*sizeof(double));
  x2=(double*)malloc(size*sizeof(double));
  factorW=((double)width*0.5);
  offsetW=0.5-factorW;
  factorW=1.0/factorW;

  factorH=((double)height*0.5);
  offsetH=0.5-factorH;
  factorH=1.0/factorH;

  factor=(factorH<factorW)?factorH:factorW; 

  halfbg=0.5*background;

  for(k=0; k<height; k++) {
    ind=tdIndex(k,0,width);
    x1[ind]= halfbg - image[ind+1]*0.5;
    for(j=1; j<width-1;j++) {
      ind=tdIndex(k,j,width);
      x1[ind]=(image[ind-1]-image[ind+1])*0.5;
    }
    ind=tdIndex(k,width-1,width);
    x1[ind]= image[ind-1]*0.5 - halfbg;
  }
  for(j=0;j<width;j++) {
    tmp[j]=x1[j];
    x1[j]=templatefactor2*x1[j]+templatefactor1*x1[j+width];
  }
  for(k=1;k<height-1;k++)
    for(j=0;j<width;j++) {
      ind=tdIndex(k,j,width);
      tp=x1[ind];
      x1[ind]=templatefactor1*tmp[j]+templatefactor2*x1[ind]+
	templatefactor1*x1[ind+width];
      tmp[j]=tp;
    }
  for(j=0;j<width;j++) {
    ind=tdIndex(height-1,j,width);
    x1[ind]=templatefactor1*tmp[j]+templatefactor2*x1[ind];
  }
  for(j=0;j<2;j++)
    for(k=0;k<height;k++) {
      ind=tdIndex(k,j,width);
      x1[ind]+=templatefactor3*background;
    } 
  for(j=2;j<width;j++)
    for(k=0;k<height;k++) {
      ind=tdIndex(k,j,width);
      x1[ind]+=templatefactor3*image[ind-2];
    } 
  for(j=0;j<width-2;j++)
    for(k=0;k<height;k++) {
      ind=tdIndex(k,j,width);
      x1[ind]-=templatefactor3*image[ind+2];
    }
  for(j=width-2;j<width;j++)
    for(k=0;k<height;k++) {
      ind=tdIndex(k,j,width);
      x1[ind]-=templatefactor3*background;
    }

  for(j=0; j<width;j++) {
    x2[j]= halfbg - image[j+width]*0.5;
    for(k=1; k<height-1; k++) {
      ind=tdIndex(k,j,width);
      x2[ind]=(image[ind-width]-image[ind+width])*0.5;
    }
    ind=tdIndex(height-1,j,width);
    x2[ind]= image[ind-width]*0.5 - halfbg;
  }

  for(j=0;j<height;j++) {
    ind=tdIndex(j,0,width);
    tmp[j]=x2[ind];
    x2[ind]=templatefactor2*x2[ind]+templatefactor1*x2[ind+1];
  }
  for(k=1;k<width-1;k++)
    for(j=0;j<height;j++) {
      ind=tdIndex(j,k,width);
      tp=x2[ind];
      x2[ind]=templatefactor1*tmp[j]+templatefactor2*x2[ind]+
	templatefactor1*x2[ind+1];
      tmp[j]=tp;
    }
  for(j=0;j<height;j++) {
    ind=tdIndex(j,width-1,width);
    x2[ind]=templatefactor1*tmp[j]+templatefactor2*x2[ind];
  }

  for(j=0;j<2;j++)
    for(k=0;k<width;k++) {
      ind=tdIndex(j,k,width);
      x2[ind]+=templatefactor3*background;
    } 
  for(j=2;j<height;j++)
    for(k=0;k<width;k++) {
      ind=tdIndex(j,k,width);
      x2[ind]+=templatefactor3*image[ind-2*width];
    } 
  for(j=0;j<height-2;j++)
    for(k=0;k<width;k++) {
      ind=tdIndex(j,k,width);
      x2[ind]-=templatefactor3*image[ind+2*width];
    }
  for(j=height-2;j<height;j++)
    for(k=0;k<width;k++) {
      ind=tdIndex(j,k,width);
      x2[ind]-=templatefactor3*background;
    }

  tangentIndex=0;

  if(choice[0]>0){  /* horizontal shift*/
    currentTangent=tangents[tangentIndex];
    for(ind=0;ind<size;ind++) currentTangent[ind]=x1[ind];
    tangentIndex++;
  }

  if(choice[1]>0){  /* vertical shift*/
    currentTangent=tangents[tangentIndex];
    for(ind=0;ind<size;ind++) currentTangent[ind]=x2[ind];
    tangentIndex++;
  }

  if(choice[2]>0){  /* hyperbolic  1*/
    currentTangent=tangents[tangentIndex];
    ind=0;
    for(k=0;k<height;k++)
      for(j=0;j<width;j++) {
	currentTangent[ind] = ((j+offsetW)*x1[ind] - (k+offsetH)*x2[ind])*factor;
	ind++;
      }
    tangentIndex++;
  }

  if(choice[3]>0){  /* hyperbolic  2, (description = inverse of hyperbolic 1)*/
    currentTangent=tangents[tangentIndex];
    ind=0;
    for(k=0;k<height;k++)  
      for(j=0;j<width;j++) {
	currentTangent[ind] = ((k+offsetH)*x1[ind] + (j+offsetW)*x2[ind])*factor;
	ind++;
      }
    tangentIndex++;
  }

  if(choice[4]>0){  /* scaling*/
    currentTangent=tangents[tangentIndex];
    ind=0;
    for(k=0;k<height;k++)
      for(j=0;j<width;j++) {
	currentTangent[ind] = ((j+offsetW)*x1[ind] + (k+offsetH)*x2[ind])*factor;
	ind++;
      }
    tangentIndex++;
  }

  if(choice[5]>0){  /* rotation*/
    currentTangent=tangents[tangentIndex];
    ind=0;
    for(k=0;k<height;k++)
      for(j=0;j<width;j++) {
	currentTangent[ind] = ((k+offsetH)*x1[ind] - (j+offsetW)*x2[ind])*factor;
	ind++;
      }
    tangentIndex++;
  }

  if(choice[6]>0){  /* line thickness*/
    currentTangent=tangents[tangentIndex];
    ind=0;
    for(k=0;k<height;k++)
      for(j=0;j<width;j++) {
	currentTangent[ind] = x1[ind]*x1[ind] + x2[ind]*x2[ind];
	ind++;
      } 
    tangentIndex++;
  }

  if(choice[7]>0){  /* additive brightness*/
    currentTangent=tangents[tangentIndex];
    for(ind=0;ind<size;ind++)
      currentTangent[ind] = additiveBrightnessValue; 
    tangentIndex++;
  }

  if(choice[8]>0){  /* multiplicative brightness*/
    currentTangent=tangents[tangentIndex];
    for(ind=0;ind<size;ind++)
      currentTangent[ind] = image[ind];
    tangentIndex++;
  }

  free(tmp);
  free(x1);
  free(x2);
  
  assert(tangentIndex==numTangents);

  return tangentIndex;
}


int normalizeTangents(double ** tangents, const int numTangents, const int height, const int width){

  unsigned int size=(unsigned int)height*width;
  
  orthonormalizePzero (tangents, (unsigned int) numTangents, size);
  return numTangents;
}


double calculateDistance(const double * imageOne, const double * imageTwo, const double ** tangents,
  const int numTangents, const int height, const int width){

  double dist=0.0,tmp;
  const double *tangents_k;
  int k,l;

  int size=height*width;

  for(l=0;l<size;++l){
    tmp=imageOne[l]-imageTwo[l];
    dist+=tmp*tmp;
  }
  
  for(k=0;k<numTangents;++k){
    tangents_k=tangents[k];
    tmp=0.0;
    for(l=0;l<size;++l) tmp+=(imageOne[l]-imageTwo[l])*tangents_k[l];
    dist-=tmp*tmp;
  }

  return dist;
}


double tangentDistance(const double * imageOne, const double * imageTwo, 
  const int height, const int width, const int * choice, const double background){
  int i,numTangents=0,numTangentsRemaining;
  double ** tangents,dist;

  int size=width*height;

  for(i=0;i<maxNumTangents;++i) {
    if(choice[i]>0) numTangents++;
  }

  tangents=(double **)malloc(numTangents*sizeof(double *));
  for(i=0;i<numTangents;++i) {
    tangents[i]=(double *)malloc(size*sizeof(double));
  }

  calculateTangents(imageOne, tangents, numTangents, height, width, choice, background);

  numTangentsRemaining = normalizeTangents(tangents, numTangents, height, width);

  dist=calculateDistance(imageOne, imageTwo, (const double **) tangents, numTangentsRemaining, height, width);

  for(i=0;i<numTangents;++i) {
    free(tangents[i]);
  }
  free(tangents);

  return dist;
}

double distance(double *img1, double *img2)
{
  int fchoice[]={1,1,0,0,0,0,0,0};
  return tangentDistance(img1,img2,28,28,fchoice,0);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	plhs[0] = mxCreateDoubleMatrix(1, 1,mxREAL);
	double *outData = mxGetPr(plhs[0]);
	outData[0] = 1;
	//获取输入变量的数值大小  
	//获取输出变量的指针  
	if (nrhs == 2)
	{
		int m = mxGetM(prhs[0]);
		int n = mxGetN(prhs[0]);
		
		outData[0] = distance(mxGetPr(prhs[0]),mxGetPr(prhs[1]));
		
	}
	else
	{
		outData[0] = 0;
	}

}
