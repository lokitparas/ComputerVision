function [ trans ] = ransacRigid( matched )
%   Summary of this function goes here
%   Detailed explanation goes here
    A_pt = matched(:,3:4);
    C_pt = matched(:,1:2);
    
    num_votes = 0;
    trans = eye(3);
    threshold = 0.5;
    for n = 1:length(matched)
        i= round(rand(1)*(length(matched)-1)+1);
        j= round(rand(1)*(length(matched)-1)+1);
        if i == j continue; end;
%         for j= i+1:length(matched)
            A = [A_pt(i,:); A_pt(j,:)];
            C = [C_pt(i,:); C_pt(j,:)];
            mean_c = mean(C);
            mean_a = mean(A);

            C1 = C -ones(size(C))*diag(mean_c);
            A1 = A -ones(size(A))*diag(mean_a);

            [U,S,V] = svd(C1'*A1);
            J = [1,0;0,det(V*U')];
            R = V*J*U';
            % disp(R);
            T = mean_a' - R*mean_c';
            curr_trans = [R T; 0,0,1];
            
            pred = C*R' + ones(size(C))*diag(T);
            
            curr_votes = sum(abs(pred(:,1) - A(:,1)) < threshold & abs(pred(:,2) - A(:,2)) < threshold);
            if(curr_votes > num_votes)
                num_votes = curr_votes;
                trans = curr_trans;
            end
%         end
    end
    
end

