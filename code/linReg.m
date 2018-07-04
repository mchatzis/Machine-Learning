function [w,ErrorIn,ErrorCV] = linReg(X,y,lamda)
    
    [N,dPlusOne]=size(X);
    %Create little by little (transposeZ * Z + lamda*I) * w = transposeZ * y
    %It was found by trial and error and matlab documentation that the next
    %6 lines is the most time efficient way and accurate way (errorfree) to
    %perform the linear regression algorithm. Other methods, as the
    %pseudo(x) function and the inv(x) were tried and they both failed
    %either in time or in bugs. The code below is robust and fast!
    rhs = (X.')*y;
    lh = (X.')*X;
    [r,c] = size(lh);
    s =lamda * eye(r);
    lhs = lh + s;
    w = lhs\rhs;
    
    %step = inv(lhs);
    %Hat = X * step * (X.') ;
    
    ErrorVector = X*w - y;
    TotalError = norm(ErrorVector) ^ 2;
    ErrorIn = 1/(length(y)) * TotalError;
    
    ErrorCV = 0;
    
    %{
    %ANALYTIC CROSS-VALIDATION -> Unstable, did not perform well, hence
    replaced with V-fold cross validation
    sumResult = 0;
    for i=1:N 
        numerator = ErrorVector(i,1);
        denominator = 1 - Hat(i,i);
        fraction = numerator / denominator; 
        sumResult = sumResult + (fraction ^ 2);
    end
    ErrorCV = sumResult/N;
    %}
    
end