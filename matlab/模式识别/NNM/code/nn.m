clear;close all;clc;
profile off;
profile on -memory
trainsize=5000;
testsize=300;

trainData=loadimg('train-images.idx3-ubyte',trainsize);
trainLabel=loadlabel('train-labels.idx1-ubyte',trainsize);

testData=loadimg('t10k-images.idx3-ubyte',testsize);
testLabel=loadlabel('t10k-labels.idx1-ubyte',testsize);


trainL=length(trainLabel);
testL=length(testLabel);
testResult=zeros(1,testL);
%load pac.mat;
%trainData=Utran'*trainData;
%testData=Utran'*testData;

tic;
for count=1:testL
disp(count);
%     tmpImg=repmat(testData(:,:,count),1,1,trainL);
    %%≈∑ œæ‡¿Î
    %tmpImg=(trainData-tmpImg).^2;
    %comp=sum(sum(tmpImg));
    %%«–±»—©∑Úæ‡¿Î
	%tmpImg=abs(trainData-tmpImg);
	%comp=max(tmpImg);
    %%3Ω◊Minkovski
	%tmpImg=(abs(trainData-tmpImg)/255).^3;
	%comp=(sum(tmpImg));
	%%tangentDistance
	for k=1:trainL
		comp(k)=distance(trainData(:,:,k)/255,testData(:,:,count)/255);
	end
    [m,Index]=min(comp);
    testResult(count)=trainLabel(Index);
end
toc;
profile viewer;
error=0;  
for i=1:testL 
  if (testResult(i) ~= testLabel(i))  
    error=error+1;  
  end  
end  