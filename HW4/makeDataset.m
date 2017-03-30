A = [];
for i = 1:2000
% x = rand();
% y = rand();
% label = -1;
%     x = (1/2*sqrt(2*pi))*randn();
%     y = (1/2*sqrt(2*pi))*randn();
%     
    sample = mvnrnd([0,0],[2,2]);
    x= sample(1);
    y = sample(2);
    label = -1;
    dist = sqrt(x*x + y*y);
    if(dist <= 2)
        label =1;
    end
    if(dist <= 3 && dist >=2.5)
        label =1;
    end
    
%     if(x >= 0.3 && x <= 0.7 && y >= 0.3 && y <= 0.7)
%         label = 1;
%     end
%     if((x>=0.15 && x<= 0.25) || (x >=0.75 && x <= 0.85))
%         label =1;
%     end
%     if((y>=0.15 && y<= 0.25) || (y >=0.75 && y <= 0.85))
%         label =1;
%     end

    A = [A ; x, y , label];
end
save dataset4.mat A;
plot(A(:,1), A(:,2),'+');
scatter(A(:,1), A(:,2), 30, A(:,3), 'x');