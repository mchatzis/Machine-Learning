function [Z] = transformXtoZ_Legendre5(X)
    
    [N,dPlusOne] = size(X);
    d = dPlusOne - 1;
    Z = ones(N,5*d + 1);
    
    for i=2:dPlusOne
        xVec = X(:,i);
        lgdr1 = xVec;
        lgdr2 = 0.5 * (3 * (xVec.^2) - 1);
        lgdr3 = 0.5 * (  (5*(xVec.^3) -  3*(xVec) )   );
        lgdr4 = (1/8) * (   35*(xVec.^4) - 30*(xVec.^2) + 3);
        lgdr5 = (1/8) * (   63*(xVec.^5) - 70*(xVec.^3) + 15.*xVec);        
        
        Z(:,5*(i-1)- 3) = lgdr1;
        Z(:,5*(i-1)- 2) = lgdr2;
        Z(:,5*(i-1)- 1) = lgdr3;
        Z(:,5*(i-1)   ) = lgdr4;
        Z(:,5*(i-1) + 1 ) = lgdr5;
    end    
end