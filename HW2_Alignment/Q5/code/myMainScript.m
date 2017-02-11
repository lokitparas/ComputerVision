%% MyMainScript



fixed = rgb2gray(imread('../input/flash1.jpg'));
moving = rgb2gray(imread('../input/noflash1.jpg'));



disp(max(max(moving)));
disp(min(min(moving)));

moving1 = imrotate(moving,23.5,'crop');
moving1 = imtranslate(moving1,[-3,0]);
% imshow(moving1);

noise = rand(size(moving1))*9;
moving1 = moving1 + uint8(noise);

moving1(moving1(:)>255) = 255;

% disp(max(max(moving1)));
% disp(min(min(moving1)));
% 
% figure(),imshow(moving);
% figure(),imshow(moving1);

entroplot = zeros(121,25);

for theta = -60:60
    for trans = -12:12 
        moving2 = imagetrans(moving1,theta,trans);
        entro = JointEntro(fixed,moving2);
        entroplot(theta+61, trans+13) = entro;
    end
end

X = repmat((-60:60)',1,25);
Y = repmat((-12:12),121,1);
surf(X,Y, entroplot);
% axis([-12,12,-60,60,min(entroplot(:))-1,max(entroplot(:))+1]);

[minv,id] = min(entroplot(:));
[row,col] = ind2sub(size(entroplot),id);
disp(61-row);
disp(13-col);








