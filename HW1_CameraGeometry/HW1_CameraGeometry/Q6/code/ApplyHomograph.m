function [ Output] = ApplyHomograph( Xin2,Yin2,Homo )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

sz = size(Xin2);
one = ones(sz);

Output = Homo*([Xin2, Yin2,one])';
Output = Output ./ repmat(Output(3,:),3,1);



end

