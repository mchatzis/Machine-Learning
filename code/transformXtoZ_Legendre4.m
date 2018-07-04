function [Z] = transformXtoZ_Legendre4(X)
    
    [N,dPlusOne] = size(X);
    d = dPlusOne - 1;
    Z = ones(N,4*d + 1);
    
    for i=2:dPlusOne
        xVec = X(:,i);
        lgdr1 = xVec;
        lgdr2 = 0.5 * (3 * (xVec.^2) - 1);
        lgdr3 = 0.5 * (  (5*(xVec.^3) -  3*(xVec) )   );
        lgdr4 = (1/8) * (   35*(xVec.^4) - 30*(xVec.^2) + 3);       
        
        Z(:,4*(i-1)- 2) = lgdr1;
        Z(:,4*(i-1)- 1) = lgdr2;
        Z(:,4*(i-1)   ) = lgdr3;
        Z(:,4*(i-1) +1 ) = lgdr4;
    end    
end