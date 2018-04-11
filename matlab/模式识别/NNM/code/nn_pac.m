clear;close all;clc;
profile off;
profile on -memory
trainsize=10000;
testsize=1000;

trainData=loadimg('train-images.idx3-ubyte',trainsize);
trainLabel=loadlabel('train-labels.idx1-ubyte',trainsize);

testData=loadimg('t10k-images.idx3-ubyte',testsize);
testLabel=loadlabel('t10k-labels.idx1-ubyte',testsize);


trainL=length(trainLabel);
testL=length(testLabel);
testResult=zeros(1,testL);
load pac.mat;

trainData=Utran'*reshape(trainData,28*28,trainL);
testData=Utran'*reshape(testData,28*28,testL);

tic;
for count=1:testL
disp(count);
    tmpImg=repmat(testData(:,count),1,trainL);
    %%≈∑ œæ‡¿Î
    tmpImg=(trainData-tmpImg).^2;
    comp=(sum(tmpImg));
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