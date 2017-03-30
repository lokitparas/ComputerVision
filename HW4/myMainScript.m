% Read X[n,d], Y[n,1] 

A = [];
load 'dataset4.mat' A;
A = A(randperm(2000), :);
test_data = A(1001:end,1:2);
test_labels = A(1001:end,3);
A = A(1:1000, :);
X = A(:,1:2); 
Y = A(:,3);

% [I,labels,I_test,labels_test] = readMNIST();
% I = I(1:5000);
% labels = labels(1:5000);

% % % FOR PART 5 part A
% % labels = (labels==2)*2-1;
% % labels_test = (labels_test==2)*2-1;

% % % FOR PART 5 part B
% % labels = (labels==2|labels==3)*2-1;
% $labels_test = (labels_test==2|labels_test==3)*2-1;
% 
% num_train = size(I,2);
% X = zeros(num_train, 784);
% Y = labels;
% 
% for t = 1:num_train
%     X(t,:) = reshape(cell2mat(I(t)), [1 784]);
% end
% 
% num_test = size(I_test,2);
% test_data = zeros(num_test, 784);
% test_labels = labels_test;
% 
% for t = 1:num_test
%     test_data(t,:) = reshape(cell2mat(I_test(t)), [1 784]);
% end

% Training
T = 100;
row = size(X,1);
col = size(X,2);
w = ones(row,1)/ row;
H = zeros(T,4);
train_err = zeros(T,1);
test_err = zeros(T,1);
for t = 1:T
    disp(t);
    [ i, theta, p, alpha, w ] = adaboost(X, Y, w);
    H(t, :) = [i, theta, p, alpha];

    
%     For printing the training error
    [~, train_err(t,1)] = computeError(H(1:t, :), X, Y);
    [~, test_err(t,1)] = computeError(H(1:t, :), test_data, test_labels);
end

[pred, ~] = computeError(H(1:t, :), test_data, test_labels);
figure();plot(test_err);
figure();scatter(test_data(:,1), test_data(:,2), 30, pred, 'x');
// figure();scatter(test_data(:,1), test_data(:,2), 30, test_labels, 'x');

% Testing

