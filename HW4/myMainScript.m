% Read X[n,d], Y[n,1] 

% Training
T =40;
n = size(X,1);
d = size(X,2);
w = ones(n)/ n;
H = zeros(T, d)
for t = 1:T
    [ i, theta, p, alpha, w ] = adaboost(X, Y, w);
    H(t, :) = [i, theta, p, alpha];
end

% Testing

