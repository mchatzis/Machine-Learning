function [g,ErIn,ECV] = vFoldCrossValidation(X,y,lamda)
    
    %Get dimensions of X
    [N,dummy] = size(X);
    
    %Initialize TotalError for loop so that it can be updated
    eTotal = 0;
    
    %Ideally, the loop should perform the whole 10 iterations of cross
    %validation. However, I faced an issue with invalid matrix indices.
    %Therefore, the first and last parts of cross validation are performed
    %manually after the loop. The loop iterates and essentially
    %makes in each iteration XVal which contains the 1/10 of the data
    %set and Xtrain which contains the rest 9/10 and passes them as
    %arguments to findCrossValidationError which does what its name
    %suggests. 
    for i=1:8
        [Xtrain,XVal,yTrain,yVal]=getSubMatrix(X,y,128*i,127+128*i);
        [g,ErIn,ValidErr] = findCrossValidationError(Xtrain,yTrain,XVal,yVal,lamda);
        %Now find the ErrorOut
        eTotal = eTotal + ValidErr;
    end
    
    %Performing the same manually
    XValidate = X(1:127,:);
    yValidate = y(1:127,:);
    XTrain = X(128:N,:);
    yTrain = y(128:N,:);
    [g,ErIn,ValidErr] = findCrossValidationError(XTrain,yTrain,XValidate,yValidate,lamda);
    %Now find the ErrorOut
    eTotal = eTotal + ValidErr;
    
    
    XValidate = X(1153:N,:);
    yValidate = y(1153:N,:);
    XTrain = X(1:1152,:);
    yTrain = y(1:1152,:);
    [g,ErIn,ValidErr] = findCrossValidationError(XTrain,yTrain,XValidate,yValidate,lamda);
    %Now find the ErrorOut
    eTotal = eTotal + ValidErr;
    
    %Eventually, after all cross Validation errors have been summed up,
    %divide by their number to get average and return result
    ECV = eTotal/10;
end