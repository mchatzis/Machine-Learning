function [Z] = transformXtoZ_Legendre10(X)
    
    [N,dPlusOne] = size(X);
    d = dPlusOne - 1;
    Z = ones(N,10*d + 1);
    
    for i=2:dPlusOne
        xVec = X(:,i);
        lgdr1 = xVec;
        lgdr2 = 0.5 * (3 * (xVec.^2) - 1);
        lgdr3 = 0.5 * (  (5*(xVec.^3) -  3*(xVec) )   );
        lgdr4 = (1/8) * (   35*(xVec.^4) - 30*(xVec.^2) + 3);
        lgdr5 = (1/8) * (   63*(xVec.^5) - 70*(xVec.^3) + 15.*xVec);
        lgdr6 = (1/16) * (  231*(xVec.^6) - 315*(xVec.^4) + 105*(xVec.^2) - 5);
        lgdr7 = (1/16) * (  429*(xVec.^7) -  693*(xVec.^5) +  315*(xVec.^3)  -  35.*xVec);
        lgdr8 = (1/128) * ( 6435*(xVec.^8) - 12012*(xVec.^6) + 6930*(xVec.^4) - 1260*(xVec.^2) + 35);
        lgdr9 = (1/128) * ( 12155*(xVec.^9) - 25740*(xVec.^7) + 18018*(xVec.^5) - 4620*(xVec.^3) + 315.*xVec);
        lgdr10 = (1/256) * ( 46189*(xVec.^10) - 109395*(xVec.^8) + 90090*(xVec.^6) - 30030*(xVec.^4) + 3465*(xVec.^2) - 63);
        
        Z(:,10*(i-1) - 8) = lgdr1;
        Z(:,10*(i-1)- 7) = lgdr2;
        Z(:,10*(i-1)- 6) = lgdr3;
        Z(:,10*(i-1)- 5) = lgdr4;
        Z(:,10*(i-1)- 4) = lgdr5;
        Z(:,10*(i-1)- 3) = lgdr6;
        Z(:,10*(i-1)- 2) = lgdr7;
        Z(:,10*(i-1)- 1) = lgdr8;
        Z(:,10*(i-1)   ) = lgdr9;
        Z(:,10*(i-1)+ 1) = lgdr10;
    end    
end