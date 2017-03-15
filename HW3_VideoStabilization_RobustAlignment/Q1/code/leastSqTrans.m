function [ trans ] = leastSqTrans( matched )
%   Summary of this function goes here
%   Detailed explanation goes here

    trans_x = (matched(:,3) - matched(:,1)); 
    trans_y = (matched(:,4) - matched(:,2));  
    trans = [mean(trans_x), mean(trans_y)];
end

