%% MyMainScript
addpath('./MMread');
addpath('./sift');

tic;

% path = uigetdir();
path = '/home/maitreyee/Desktop/Sem8/vision/ComputerVision/HW3_VideoStabilization_RobustAlignment/Q1/input';
fileName = strcat(path, '/shaky_cars_x.avi');

[video, audio_orig] = mmread(fileName);

sift_points = {};

for i = 2:length(video.frames)
    [num, matched] = match(video.frames(i-1).cdata, video.frames(i).cdata);
    sift_points{i} = matched;
end

trans = [0,0];
for i = 2:length(video.frames)
    trans_last = trans(end,:);
    trans = [trans; trans_last+ransacTrans(sift_points{i})];
end

plot3(1:length(trans),trans(:,1), trans(:,2));

windowsize = 30;
b= (1/windowsize)*ones(1,windowsize);
a=1;

smoothed = filter(b,a,trans);
plot3(1:length(trans),trans(:,1), trans(:,2));
hold on;
plot3(1:length(trans),smoothed(:,1), smoothed(:,2));
hold off;

error = -smoothed + trans;

stable_video = uint8(zeros(2*video.height, video.width, video.nrFramesTotal));

for i=1:length(video.frames)
    shaky_frame = rgb2gray(video.frames(i).cdata);
    x = error(i, 1);
    y = error(i, 2);
    smooth_frame = imtranslate(shaky_frame, [x, 0]);
    comb_frame = [shaky_frame; smooth_frame];
    stable_video(:,:,i) = comb_frame;
end

% displayvideo(stable_video, 1/video.rate);
writevideo('../output/cars_stable_ls.avi', stable_video, video.rate);



% toc;
