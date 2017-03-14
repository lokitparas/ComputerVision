%% MyMainScript
addpath('./MMread');
addpath('./sift');

tic;

% path = uigetdir();
path = '/Users/anand/Desktop/sem8/vision/assgn/HW3_VideoStabilization_RobustAlignment/Q1/input';
fileName = strcat(path, '/shaky_cars.avi');

[video, audio_orig] = mmread(fileName);
type(video.frames(1).cdata)

match(video.frames(1).cdata, video.frames(2).cdata);
toc;
