function [ i, theta, p, alpha, w ] = adaboost( X, Y, w)
%   Summary of this function goes here
%   Detailed explanation goes here
[i, theta, p, error] = find_best(X,Y,w);
alpha = 1/2 * ln((1-error)/error);
pred = p*(X(:,i) - theta);
w= w .* (exp(-alpha) * exp(2*alpha (pred==Y))); 

end

