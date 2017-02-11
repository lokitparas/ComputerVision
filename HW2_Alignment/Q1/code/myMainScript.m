%% MyMainScript

folder = uigetdir();
load(strcat(folder, '/Q1data.mat'));

%loop
B1 = B;
C = corresp(A,B);
[R,T] = rigidtrans(A,C);
R_act = eye(3);
T_act = zeros(3,1);
count=0;

while norm(R-eye(3),'fro')> 0.000001 || norm(T,'fro') > 0.000001 
    B = B*R'+ones(size(B))*diag(T);
    C = corresp(A,B);
    R_act = R*R_act;
    T_act = T + R*T_act;
    [R,T] = rigidtrans(A,C);
%     disp(count);
    count = count+1;
end

% figure(),scatter3(A(:,1),A(:,2),A(:,3));
% figure(),scatter3(B(:,1),B(:,2),B(:,3));
% figure(),scatter3(B1(:,1),B1(:,2),B1(:,3));

figure(),scatter3(A(:,1),A(:,2),A(:,3));
hold on;scatter3(B1(:,1),B1(:,2),B1(:,3));

figure(),scatter3(A(:,1),A(:,2),A(:,3));
hold on;scatter3(B(:,1),B(:,2),B(:,3));

disp('R = ')
disp(R_act);
disp('t = ')
disp(T_act);


