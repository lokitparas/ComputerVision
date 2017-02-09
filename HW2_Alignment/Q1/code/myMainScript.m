%% MyMainScript

load('../input/Q1data.mat');

%loop
B1 = B;
C = corresp(A,B);
[R,T] = rigidtrans(A,C);

count=0;

while norm(R-eye(3),'fro')> 0.000001 || norm(T,'fro') > 0.000001 
    B = B*R'+ones(size(B))*diag(T);
    C = corresp(A,B);
    [R,T] = rigidtrans(A,C);
    disp(count);
    count = count+1;
    
end

figure(),scatter3(A(:,1),A(:,2),A(:,3));
figure(),scatter3(B(:,1),B(:,2),B(:,3));
figure(),scatter3(B1(:,1),B1(:,2),B1(:,3));

