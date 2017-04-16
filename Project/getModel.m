function [ q ] = getModel( points, bins, num_bins, ax, center)
q = zeros(num_bins, 1);
scaled_dist = (bsxfun(@minus,points,center).^2);
scaled_dist = bsxfun(@rdivide, scaled_dist, (ax.^2));
scaled_dist = sum(scaled_dist, 2);
scaled_dist = kernel(scaled_dist);
scaled_dist = scaled_dist/sum(scaled_dist);

for i = 1:num_bins
    q(i) = sum(scaled_dist(bins==i));
end

end

function val = kernel(x)
val = zeros(size(x));
val(x<1) = (1-x(x<1))*3/(2*pi);
end