function [entro] = JointEntro( fixed, moving)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

im1 = double(fixed(:)) +1;
im2 = double(moving(:)) +1;
% disp(im1);
A = accumarray([im1,im2],1);
entro = entropy(A);


end

