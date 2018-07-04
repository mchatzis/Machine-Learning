function [g,ErIn,ECV] = findCrossValidationError(X,y,XVal,yVal,lamda)
    
    %Pretty simple function
    %Finds best hypothesis g for training data set X using the linear
    %regression model with optional regularization
    %Then applies learned hypothesis into XVal validation set and returns
    %the error using the norm operation (linear algebra theory)
    [g,ErIn,ErCV] = linReg(X,y,lamda);
    
    ErrorVectorTest = XVal*g - yVal;
    TotalError = norm(ErrorVectorTest) ^ 2;
    ECV = 1/(length(yVal)) * TotalError;
    
end