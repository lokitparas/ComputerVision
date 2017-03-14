%% MyMainScript

tic;
%% Your code here
folder = uigetdir();
I1 = imread(strcat(folder, '/tajnew1_downsampled.jpg'));
I2 = imread(strcat(folder ,'/tajnew2_downsampled.jpg'));

% imshow(A);

% I1 = rgb2gray(A);
% I2 = rgb2gray(B);

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[f1, vpts1] = extractFeatures(I1, points1);
[f2, vpts2] = extractFeatures(I2, points2);

indexPairs = matchFeatures(f1, f2) ;
matchedPoints1 = vpts1(indexPairs(:, 1));
matchedPoints2 = vpts2(indexPairs(:, 2));

figure; ax = axes;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

[H, inliers]  = ransacfithomography(matchedPoints1, matchedPoints2, 0.1);

toc;
