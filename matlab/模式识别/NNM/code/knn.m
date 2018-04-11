clear;close all;clc;
profile on -memory
trainsize=10000;
testsize=1000;
k=20;

trainData=loadimg('train-images.idx3-ubyte',trainsize);
trainLabel=loadlabel('train-labels.idx1-ubyte',trainsize);

testData=loadimg('t10k-images.idx3-ubyte',testsize);
testLabel=loadlabel('t10k-labels.idx1-ubyte',testsize);


trainL=length(trainLabel);
testL=length(testLabel);
testResult=zeros(testL);

leastk=zeros(1,k);

tic;
for count=1:testL
    
    tmpImg=repmat(testData(:,:,count),1,1,trainL);
    %%欧氏距离
    tmpImg=(trainData-tmpImg).^2;
    comp=sum(sum(tmpImg));
    
    [m,Index]=sort(comp);
    leastk=trainLabel(Index(1:k));
    testResult(count)=mode(leastk);
end
toc;
profile viewer;
error=0;  
for i=1:testL 
  if (testResult(i) ~= testLabel(i))  
    error=error+1;  
  end  
end  