%Performs simple nth order transformation mapping as in:
%(1, x1, x2...x11) -> (1,x1,x1^2,x2,x2^2...x11^2) for n = 2
% and as n increases same pattern but up to nth power of each element

function [Z] = nthOrderTransform(X,n)
    

    [r,c] = size(X);
    Z = ones(r,1);
    
    for i=2:c
        for j = 1:n
            Add = X(:,i) .^ j;
            Z = [Z Add];
        end
    end
end