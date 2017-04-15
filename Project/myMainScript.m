addpath('./MMread');

path = '/Users/anand/Desktop/sem8/vision/assgn/Project';
fileName = 'vid.mp4';
fileFullName = strcat(path, '/', fileName);

[video, audio_orig] = mmread(fileFullName);

vid = uint8(zeros(video.height, video.width, video.nrFramesTotal));
for i = 1:video.nrFramesTotal
    size(rgb2gray(video.frames(i).cdata));
    vid(:,:,i) = rgb2gray(video.frames(i).cdata);
end

imshow(vid(:,:,1));
hold on;
% First click on top left corner and 
% [x, y] = getpts();
hold off;
drawEllipse(x(1), y(1), x(2), y(2));

for i = 2:video.nrFramesTotal
    
    [y0_vals, y0_locs] = pointsFromEllipse(x(1), y(1), x(2), y(2));
    
    imshow(vid(:,:,i));
    hold on;
    drawEllipse(x(1), y(1), x(2), y(2));
    hold off;
    pause(0.1)
end


writevideo('op.avi', vid, video.rate);