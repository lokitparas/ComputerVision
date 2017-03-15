function [ trans ] = leastSqRigid( matched )
%   Summary of this function goes here
%   Detailed explanation goes here
    A = matched(:,3:4);
    C = matched(:,1:2);
%     [d,Z, trans] = procrustes(A, C);
    mean_c = mean(C);
    mean_a = mean(A);

    C1 = C -ones(size(C))*diag(mean_c);
    A1 = A -ones(size(A))*diag(mean_a);

    [U,S,V] = svd(C1'*A1);
    J = [1,0;0,det(V*U')];
    R = V*J*U';
    % disp(R);
    T = mean_a' - R*mean_c';
    trans = [R T];
    trans = [trans; 0, 0, 1];
end

