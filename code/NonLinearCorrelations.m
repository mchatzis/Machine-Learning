function [Z] = NonLinearCorrelations(X)
    %Get row and column size of X
    [N,dPlusOne]=size(X);
    
    %Initiate matrices that will change in loop
    Z = ones(N,1);
    Add = ones(N,1);

    %Loop function:
    %Creates a matrix Z which contains all the linear combinations of
    %columns of matrix X and the squared columns of X
    %   example:
    %       for X = [1 x1 x2], Z would become:
    %               Z = [1 x1 x1^2 x1x2 x2^2]
    %Full X however is N x (d+1) and hence Z contains much more
    %combinations than the example. This imposes a threat on computational
    %complexity and time, especially for higher order non-linear transforms
    for i=2:dPlusOne
            Z = [Z X(:,i)];
        for j=i:dPlusOne
            Append = X(:,i).*X(:,j);
            Z = [Z Append];
        end
        Add = Add .* X(:,i);
    end
    %return Z
    Z = [Z Add];
end

    
    

   