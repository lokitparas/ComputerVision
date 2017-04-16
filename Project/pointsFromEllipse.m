function [points] = pointsFromEllipse(ax, center, image_size)
center = round(center);
a = round(ax(1));
b = round(ax(2));
x = (-a):(a);
y = -b:+b;
[X,Y] = meshgrid(x, y);
% two semi-axis
ax1 = [a; 0];
ax2 = [0 b];
W = [ax1(:) ax2(:)];
in = reshape(sum(( [X(:) Y(:)]/W.').^2,2)<1, size(X));
X = X(:); Y = Y(:); in = in(:);
X = X + center(1);
Y = Y + center(2);
points = [X(in), Y(in)];
ind = points(:,1) > 0 & points(:,1) < image_size(2) & points(:,2) > 0 & points(:,2) < image_size(1);
points = points(ind,:);
end