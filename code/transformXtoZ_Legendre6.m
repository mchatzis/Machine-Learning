function [Z] = transformXtoZ_Legendre6(X)
    
    [N,dPlusOne] = size(X);
    d = dPlusOne - 1;
    Z = ones(N,6*d + 1);
    
    for i=2:dPlusOne
        xVec = X(:,i);
        lgdr1 = xVec;
        lgdr2 = 0.5 * (3 * (xVec.^2) - 1);
        lgdr3 = 0.5 * (  (5*(xVec.^3) -  3*(xVec) )   );
        lgdr4 = (1/8) * (   35*(xVec.^4) - 30*(xVec.^2) + 3);
        lgdr5 = (1/8) * (   63*(xVec.^5) - 70*(xVec.^3) + 15.*xVec);
        lgdr6 = (1/16) * (  231*(xVec.^6) - 315*(xVec.^4) + 105*(xVec.^2) - 5);
        
        
        Z(:,6*(i-1)- 4) = lgdr1;
        Z(:,6*(i-1)- 3) = lgdr2;
        Z(:,6*(i-1)- 2) = lgdr3;
        Z(:,6*(i-1)- 1) = lgdr4;
        Z(:,6*(i-1)  ) = lgdr5;
        Z(:,6*(i-1)+ 1) = lgdr6;
    end    
end