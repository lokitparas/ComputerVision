function [ i, theta, p, error] = find_best( X, Y, w )
%   Summary of this function goes here
%   Detailed explanation goes here
error = sum(w);
i = 0;
p = +1;
theta = 0;
d = size(X,2);
n = size(X,1);
for j = 1:d
   % find theta and p minimizing error
   for k = unique(X(:,j))
    for sign = [-1, 1]
        % better way to iterate
        pred = sign*(X(:,j)-k);
        curr_error = sum(w .* (pred ~=Y));
        if(curr_error < error)
            error= curr_error;
            i = j;
            p = sign;
            theta = k;
        end
    end
   end
end

end

