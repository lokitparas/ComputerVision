function [points, bins, p] = getProfile(image, ax, center, num_bins)
points = pointsFromEllipse(ax, center, size(image));
bins = points2bins(points, image, num_bins);
p = getModel(points, bins, num_bins, ax, center);
end