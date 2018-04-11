trainsize=10000;
trainData=loadimg('train-images.idx3-ubyte',trainsize);
trainData=trainData-repmat(mean(trainData,2),1,trainsize);
su=zeros(784,784);
for c=1:trainsize
    su=su+trainData(:,c)*trainData(:,c)';
end
su=su./trainsize;
[U,S,V]=svd(su);
[re,I]=sort(diag(S),'descend');
Utran=U(:,I(re>1000));
save('pac.mat','Utran');