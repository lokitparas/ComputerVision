function [image1] = imagetrans(image, theta, trans)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% disp(theta);
image1 = imrotate(image,theta,'crop');
image1 = imtranslate(image1,[trans,0]);

end

