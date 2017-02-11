function [ C ] = corresp( A,B )
correspond = knnsearch(B,A,'distance','euclidean');
C = B(correspond,:);
end

