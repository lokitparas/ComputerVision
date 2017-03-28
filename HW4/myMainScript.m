% Read X[n,d], Y[n,1] 

A = [];
load 'dataset1.mat' A;
X = A(:,1:2); 
Y = A(:,3);

% Training
T =40;
row = size(X,1);
col = size(X,2);
w = ones(row,1)/ row;
H = zeros(T,4);
for t = 1:T
    disp('t-> ');
    [ i, theta, p, alpha, w ] = adaboost(X, Y, w);
%     temp = [i, theta, p, alpha];
    H(t, :) = [i, theta, p, alpha];
    
end


% Testing

