%% MyMainScript

[file,path] = uigetfile({'*.jpg;*.png'});
[file1,path1] = uigetfile({'*.jpg;*.png'});
fixed = imread(strcat(path,'/',file));
moving = imread(strcat(path1,'/',file1));

sz = size(size(fixed));

if(sz(2) > 2)
    fixed = rgb2gray(fixed);
    moving = rgb2gray(moving);
end
% 
% moving1 = imrotate(moving,180,'crop');
% moving1 = imtranslate(moving1,[-210,-60]);

moving1 = imagetrans(moving,23.5,-3);

noise = rand(size(moving1))*9;
moving1 = moving1 + uint8(noise);

moving1(moving1(:)>255) = 255;

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
disp('rotate by');
disp(61-row);
disp('translate by');
disp(13-col);

disp('minimum entropy');
disp(min(min(entroplot)));







