function [ Homo ] = GetHomoMatrix( Xin1,Yin1,Xout1,Yout1 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

sz = size(Xin1);
one = ones(sz);
zero = zeros(sz(1),3);

homo = -[Xin1,Yin1,one];
hx = [homo ,zero, Xout1.*Xin1, Xout1.*Yin1 , Xout1];
hy = [zero, homo, Yout1.*Xin1, Yout1.*Yin1 , Yout1];

H = [hx;hy];

[~,~,V] = svd(H);

Homo = reshape(V(:,9), 3, 3);
Homo = Homo';

end

