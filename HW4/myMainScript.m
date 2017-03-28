% Read X[n,d], Y[n,1] 

A = [];
load 'dataset4.mat' A;
A = A(randperm(2000), :);
% B = A([1001:2000 1:1000], :);
% A = B;
test_data = A(1001:end,1:2);
test_labels = A(1001:end,3);
A = A(1:1000, :);
X = A(:,1:2); 
Y = A(:,3);


% Training
T = 1000;
row = size(X,1);
col = size(X,2);
w = ones(row,1)/ row;
H = zeros(T,4);
train_err = zeros(T,1);
test_err = zeros(T,1);
for t = 1:T
    disp(t);
    [ i, theta, p, alpha, w ] = adaboost(X, Y, w);
%     temp = [i, theta, p, alpha];
    H(t, :) = [i, theta, p, alpha];
%     disp(H(t,:));
    
%     For printing the training error
    [~, train_err(t,1)] = computeError(H(1:t, :), X, Y);
    [~, test_err(t,1)] = computeError(H(1:t, :), test_data, test_labels);
end

[pred, ~] = computeError(H(1:t, :), test_data, test_labels);
plot(test_err);
figure();scatter(test_data(:,1), test_data(:,2), 30, pred, 'x');
figure();scatter(test_data(:,1), test_data(:,2), 30, test_labels, 'x');

% Testing

