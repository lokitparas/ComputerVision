% Read X[n,d], Y[n,1] 

% Training
T =40;
n = size(X,1);
w = ones(n)/ n;
for t = 1:T
    [ i, theta, p, alpha, w ] = adaboost(X, Y, w);
    % How to add these functions to get H?? maybe use formula
end

% Testing