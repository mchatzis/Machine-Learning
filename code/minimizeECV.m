function [lamda,ECV] = minimizeECV(X,yTraining,L,name)

    %get dimensions of lamda array
    [r,c] = size(L);
    StoreResults = [];

for i=1:c   
    lamda = L(1,i);
    [g,ErrIn,ErrCV] = vFoldCrossValidation(X,yTraining,lamda);
    multiDimArr = [lamda;ErrCV];
    StoreResults = [StoreResults multiDimArr];    
end
    %Plots ECV against lamda values
    plot(L(1,:),StoreResults(2,:))
    title(name);
    ylabel('ECV');
    xlabel('lamda');
    hold on
    
    
    %The next lines find the minimum ECV and its corresponding lamda in the
    %array of all lamdas and ECVs created by the for loop and returns them
    ECV = min(StoreResults(2,:));
    index = find(StoreResults(2,:) == ECV);
    lamda = StoreResults(1,index);
end