clear;

path = 'C:\Users\lokit\OneDrive_1\Documents\sem8\Vision\ComputerVision\HW3_VideoStabilization_RobustAlignment\Q1\input\SampleVideos';

fileName = strcat(path, '\cars.avi');

addpath('./MMread');


a = mmread(fileName);
framerate = a.rate;
vid = zeros(a.height,a.width,a.nrFramesTotal);

for i=1:a.nrFramesTotal 
    b = rgb2gray(a.frames(i).cdata); 
    [H,W] = size(b);
    if i > 1, tx = round(rand(1)*3); else tx = 0; end;
    if i > 1, ty = round(rand(1)*3); else ty = 0; end;

    d = b; d(:,:) = 0;
    d(ty+1:H,tx+1:W) = b(1:H-ty,1:W-tx);
        
    vid(:,:,i) = d;
end
  
filename = '../input/shaky_cars.avi';
writevideo(filename,vid/max(vid(:)),framerate);
    