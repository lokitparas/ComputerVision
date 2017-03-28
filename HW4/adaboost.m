function [ i, theta, p, alpha, w ] = adaboost( X, Y, w)
%   Summary of this function goes here
%   Detailed explanation goes here
[i, theta, p, error] = find_best(X,Y,w);
alpha = 1/2 * log((1-error)/error);
pred = (p*(X(:,i) - theta) >= 0);
disp(error);
h(1:length(X)) = -1;
h(pred) = 1;

% w= w .* (exp(-alpha) * exp(2*alpha (pred==Y))); % Sir says we need to use the updation rule used in the class
total = 0;
for j = length(X)
   w(j) = w(j)*exp(-alpha*Y(i)*h(j));
   total = total + w(j);
end
w= w ./ total;
end

