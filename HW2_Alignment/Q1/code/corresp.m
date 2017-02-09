function [ C ] = corresp( A,B )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
correspond = knnsearch(B,A,'distance','euclidean');
C = B(correspond,:);
end

