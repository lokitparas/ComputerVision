function [ pred, error ] = computeError( H, X, Y )
%COMPUTEERROR Summary of this function goes here
%   Detailed explanation goes here
pred = zeros(size(Y));
for it = 1:size(H, 1)
    op = H(it, :);
    i = op(1,1);
    theta = op(1,2);
    p = op(1,3);
    alpha = op(1,4);
    pred = pred + ((X(:,i)-theta > 0)*2-1)*p*alpha;    
end
pred = (pred> 0)*2-1;

error = sum(Y~=pred)/size(Y,1);
end

