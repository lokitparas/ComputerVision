function [ trans ] = leastSqTrans( matched )
%   Summary of this function goes here
%   Detailed explanation goes here

    trans_x = (matched(:,1) - matched(:,3)); 
    trans_y = (matched(:,2) - matched(:,4));  
    trans = [mean(trans_x), mean(trans_y)];
end

