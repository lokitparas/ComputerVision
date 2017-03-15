function [ trans ] = ransacTrans( matched )
%   Summary of this function goes here
%   Detailed explanation goes here
    trans_x = (matched(:,3) - matched(:,1)); 
    trans_y = (matched(:,4) - matched(:,2));  
    num_votes = 0;
    trans = [0,0];
    threshold = 0.5;
    for i = 1:length(matched)
       x =trans_x(i);
       y = trans_y(i);
       curr_votes = sum(abs(trans_x(:) -x) < threshold & abs(trans_y(:) -y) < threshold);
       if(curr_votes > num_votes)
           num_votes = curr_votes;
           trans = [x, y];
       end
    end

end

