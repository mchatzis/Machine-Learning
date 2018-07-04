function [Z] = transformXtoZ_Legendre2(X)
    
    [N,dPlusOne] = size(X);
    d = dPlusOne - 1;
    Z = ones(N,2*d + 1);
    
    for i=2:dPlusOne
        lgdr1 = X(:,i);
        lgdr2 = 0.5 * (3 * (X(:,i).^2) - 1);
        Z(:,2*(i-1)) = lgdr1;
        Z(:,2*(i-1)+1) = lgdr2;
    end    
end