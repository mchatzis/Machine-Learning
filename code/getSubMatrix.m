function [XTrain,XValidate,yTrain,yValidate] = getSubMatrix(X,y,n1,n2)
    
    [N,dummy] = size(X);
    XValidate = X(n1:n2,:);
    yValidate = y(n1:n2,:);
    
    XTrain = [X(1:n1-1,:);X(n2+1:N,:)];
    yTrain = [y(1:n1-1,:);y(n2+1:N,:)];
    
end
    
    