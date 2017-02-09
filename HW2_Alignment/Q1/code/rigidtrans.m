function [ R,T ] = rigidtrans(A,C)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


mean_c = mean(C);
mean_a = mean(A);

C1 = C -ones(size(C))*diag(mean_c);
A1 = A -ones(size(A))*diag(mean_a);

[U,S,V] = svd(C1'*A1);

R = V*U';
D = det(R);
if(D == -1)
    J = [1,0,0;0,1,0;0,0,-1];
    R = V*J*U';
end
disp(R);
T = mean_a' - R*mean_c';
end

