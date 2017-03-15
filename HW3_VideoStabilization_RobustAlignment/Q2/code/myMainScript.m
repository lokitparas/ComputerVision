%% MyMainScript
addpath('./sift');
tic;
%% Your code here
folder = uigetdir();
I1 = imread(strcat(folder, '/laptop1.jpg'));
I2 = imread(strcat(folder ,'/laptop2.jpg'));

siz = size(I1);
if(length(siz) == 3)
    I1 = rgb2gray(I1);
    I2 = rgb2gray(I2);
end

[num, matched] = match(I1,I2);
disp(matched(:,1:2));
matchedPoints1 = matched(:,[2 1])';
matchedPoints2 = matched(:,[4 3])';

[H, inliers]  = ransacfithomography(matchedPoints1, matchedPoints2, 0.1);
alignedImage = I2;

sz = size(I1);

for i = 1:sz(1)
   for j = 1:sz(2)
       new_cor = inv(H)*[i, j, 1]';
       new_cor = new_cor ./ new_cor(3);

       if(uint32(new_cor(1)) > 0 && uint32(new_cor(2)) > 0 && uint32(new_cor(1)) < sz(1) && uint32(new_cor(2)) < sz(2))
           alignedImage(i,j) = I1(uint32(new_cor(1)),uint32(new_cor(2)));
       end
   end
end

figure(),imshow(I2);
figure(),imshow(alignedImage, []);
toc;
