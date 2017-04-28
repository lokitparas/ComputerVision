function [ bins ] = points2bins( points, image, num_bins )
    one = ones(size(points,1),1);
    num_bins = floor(nthroot(num_bins, 3));
    R = image(sub2ind(size(image),points(:,2),points(:,1), one));
    G = image(sub2ind(size(image),points(:,2),points(:,1), 2*one));
    B = image(sub2ind(size(image),points(:,2),points(:,1), 3*one));
    Rbins = idivide(R, 256/num_bins, 'floor') + 1;
    Gbins = idivide(G, 256/num_bins, 'floor') + 1;
    Bbins = idivide(B, 256/num_bins, 'floor') + 1;
    bins = Rbins*num_bins*num_bins + Gbins*num_bins + Bbins; 
end

% function [ bins ] = points2bins( points, image, num_bins )
%     values = image(sub2ind(size(image),points(:,2),points(:,1)));
%     bins = idivide(values, 256/num_bins, 'floor') + 1;
% end
