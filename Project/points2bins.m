function [ bins ] = points2bins( points, image, num_bins )
    values = image(sub2ind(size(image),points(:,2),points(:,1)));
    bins = idivide(values, 256/num_bins, 'floor') + 1;
end

