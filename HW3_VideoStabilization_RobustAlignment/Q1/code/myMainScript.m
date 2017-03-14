% %% MyMainScript
% addpath('./MMread');
% addpath('./sift');
% 
% tic;
% 
% % path = uigetdir();
% path = 'C:\Users\lokit\OneDrive_1\Documents\sem8\Vision\ComputerVision\HW3_VideoStabilization_RobustAlignment\Q1\input';
% fileName = strcat(path, '\shaky_cars.avi');
% 
% [video, audio_orig] = mmread(fileName);
% 
% trans = [0,0];
% 
% for i = 2:length(video.frames)
%     [num, matched] = match(video.frames(i-1).cdata, video.frames(i).cdata);
%     trans_last = trans(end,:);
%     trans = [trans; trans_last+leastSqTrans(matched)];
% end
% 
% plot3(1:length(trans),trans(:,1), trans(:,2));

windowsize = 5;
b= (1/windowsize)*ones(1,windowsize);
a=1;

smoothed = filter(b,a,trans);
plot3(1:length(trans),trans(:,1), trans(:,2));
hold on;
plot3(1:length(trans),smoothed(:,1), smoothed(:,2));
hold off;

error = smoothed - trans;

video1 = video;







% toc;
