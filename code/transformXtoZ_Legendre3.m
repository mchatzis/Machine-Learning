function [Z] = transformXtoZ_Legendre3(X)
    
    [N,dPlusOne] = size(X);
    d = dPlusOne - 1;
    Z = ones(N,3*d + 1);
    
    for i=2:dPlusOne
        xVec = X(:,i);
        lgdr1 = xVec;
        lgdr2 = 0.5 * (3 * (xVec.^2) - 1);
        lgdr3 = 0.5 * (  (5*(xVec.^3) -  3*(xVec) )   );
        Z(:,3*(i-1) - 1) = lgdr1;
        Z(:,3*(i-1)) = lgdr2;
        Z(:,3*(i-1)+1) = lgdr3;
    end    
end