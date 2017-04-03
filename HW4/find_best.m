function [ i, theta, p, error] = find_best( X, Y, w )
%   Summary of this function goes here
%   Detailed explanation goes here
error = sum(w);
i = 1;
p = +1;
theta = 0;
col = size(X,2);
row = size(X,1);
for j = 1:col
   % find theta and p minimizing error
   temp = unique(X(:,j));
   for k = temp'
     for q = [-1, 1]
        pred = ((X(:,j)-k > 0)*2-1)*q;
        curr_error = sum(w .* (pred ~=Y));
        if(curr_error < error)
            error= curr_error;
            i = j;
            p = q;
            theta = k;
        end
     end
   end
end

end

