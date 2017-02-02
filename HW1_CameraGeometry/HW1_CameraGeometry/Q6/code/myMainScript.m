%% MyMainScript

tic;
%% Your code here
folder = uigetdir();
image = imread(strcat('..\testImg2.jpg'));
figure(), imshow(image);
[Xin1,Yin1] = getpts;
[Xin2,Yin2] = getpts;
Xout1 = [0;21;21;0];
Yout1 = [0;0;29.7;29.7];

Homo = GetHomoMatrix(Xin1,Yin1,Xout1,Yout1);

Output = ApplyHomograph(Xin2,Yin2,Homo);

width = (GetDist(Output(:,2),Output(:,1)) + GetDist(Output(:,4),Output(:,3))) / 2;
length = (GetDist(Output(:,3),Output(:,2)) + GetDist(Output(:,4),Output(:,1))) / 2;

disp(width);
disp(length);
toc;
