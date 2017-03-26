addpath('./MMread');

path = '/Users/anand/Desktop/sem8/vision/assgn/Project';
fileName = 'vid.mp4';
fileFullName = strcat(path, '/', fileName);

[video, audio_orig] = mmread(fileFullName);

vid = uint8(zeros(360, 640, 1179));
for i = 1:video.nrFramesTotal
    size(rgb2gray(video.frames(i).cdata));
    vid(:,:,i) = rgb2gray(video.frames(i).cdata);
end
writevideo('op.avi', vid, video.rate);