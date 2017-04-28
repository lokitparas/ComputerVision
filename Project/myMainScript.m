%%% with RGB

addpath('./MMread');

num_bins = 2;
num_bins = num_bins^3;
% todo
path = '/home/maitreyee/Desktop/Sem8/vision/ComputerVision/Project';
fileName = 'anand.mp4';
fileFullName = strcat(path, '/', fileName);

[video, audio_orig] = mmread(fileFullName);

%%RGB

vid = uint8(zeros(video.height, video.width, 3, video.nrFramesTotal));
for i = 1:video.nrFramesTotal
%     vid(:,:,i) = rgb2gray(video.frames(i).cdata);
    vid(:,:,:,i) = video.frames(i).cdata;
end

imshow(rgb2gray(vid(:,:,:,1)));
% hold on;
% First click on top left corner and 
[x, y] = getpts();

ax=[(x(2)-x(1))/2, (y(2)-y(1))/2]; 
% horizontal radius vertical radius
center=[round((x(2)+x(1))/2), round((y(2)+y(1))/2)]; 
% c ellipse centre coordinates
drawEllipse(ax, center);
% hold off;

y0_points = pointsFromEllipse(ax, center, size(vid(:,:,1)));
y0_bins = points2bins(y0_points, vid(:,:,:,1), num_bins);
q = getModel(y0_points, y0_bins, num_bins, ax, center);

%todo
% mov = VideoWriter('anand_tracked_test.mp4','MPEG-4');
% mov.FrameRate = video.rate;
% open(mov)
% for i = 2:video.nrFramesTotal
for i = 2:video.nrFramesTotal
    [ax, center] = meanShift(vid(:,:,:,i), ax, center, q, num_bins);
    disp(i);
    disp(center);
    imshow(rgb2gray(vid(:,:,:,i)));
    hold on;
    drawEllipse(ax, center);
    hold off;
%     writeVideo(mov,getframe(gca));
    pause(0.1)
end
% close(mov);
