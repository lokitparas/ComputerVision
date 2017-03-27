    %% MyMainScript
    addpath('./MMread');
    addpath('./sift');

%     tic;

    % path = uigetdir();
    path = '/home/maitreyee/Desktop/Sem8/vision/ComputerVision/HW3_VideoStabilization_RobustAlignment/Q1/input';
    fileName = 'shaky_gbus_rigid.avi';
    fileFullName = strcat(path, '/', fileName);

    [video, audio_orig] = mmread(fileFullName);

    sift_points = {};

    for i = 2:length(video.frames)
        [num, matched] = match(video.frames(i-1).cdata, video.frames(i).cdata);
        sift_points{i} = matched;
    end
    

%     for i = 2:length(video.frames)
%         trans_last = trans(end,:);
%         trans = [trans; trans_last+ransacTrans(sift_points{i}), 0];
%     end
    
    trans = [0, 0, 0]; % tx, ty, angle
    trans_last = eye(3);
    [H1,H2] = size(video.frames(1).cdata);
    xc = round(H2/2); yc = round(H1/2);
            
    for i = 2:length(video.frames)
        curr = ransacRigid(sift_points{i}, xc, yc)*trans_last;
        x = curr(1,3);
        y = curr(2,3);
        angle = asin(curr(1,2))* 180 /pi;
        trans = [trans; x , y, angle];
        trans_last = curr;
    end

    smoothed = trans;
    windowsize = 20;
    b= (1/windowsize)*ones(1,windowsize);
    a=1;
    smoothed(:,1) = filter(b,a,trans(:,1));
    smoothed(:,2) = filter(b,a,trans(:,2));
    smoothed(:,3) = filter(b,a,trans(:,3));
    
    
    figure(),plot3(1:length(trans),trans(:,1), trans(:,2));
    hold on;
    plot3(1:length(trans),smoothed(:,1), smoothed(:,2));
    hold off;
    figure(),plot(1:length(trans),trans(:,3));
    hold on;
    plot(1:length(trans),smoothed(:,3));
    hold off;
    
    error = smoothed - trans;

    stable_video = uint8(zeros(2*video.height, video.width, video.nrFramesTotal));

    for i=1:length(video.frames)
        shaky_frame = rgb2gray(video.frames(i).cdata);
        x = error(i, 1);
        y = error(i, 2);
        angle = error(i, 3);
        smooth_frame = imtranslate(shaky_frame, [x, y]);
        smooth_frame = imrotate(smooth_frame,angle,'bilinear','crop');
        comb_frame = [shaky_frame; smooth_frame];
        stable_video(:,:,i) = comb_frame;
    end

    outputFileName = strcat('../output/corr_', fileName);
    writevideo(outputFileName, stable_video, video.rate);



% toc;
