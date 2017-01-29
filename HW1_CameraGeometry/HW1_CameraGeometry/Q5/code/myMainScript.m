%% MyMainScript

tic;

data_3d_file = '../input/Calib_data/Features3D_dataset1.mat';
data_2d_file = '../input/Calib_data/Features2D_dataset1.mat';

load(data_3d_file, 'f3D');
load(data_2d_file, 'f2D');

% getCalib(f3D(1:3, :), f2D(1:2, :))

WC = f3D(1:3, :);
IC = f2D(1:2, :);

WC_1 = [WC' ones(size(WC,2),1)];
zero = zeros(size(WC,2),4);
x_vec = -IC(1,:)';
y_vec = -IC(2,:)';
A = [WC_1 zero bsxfun(@times,x_vec, WC_1) ; zero WC_1 bsxfun(@times, y_vec, WC_1)];

[~, ~, V] = svd(A);
M = reshape(V(:,12), 4,3)';
f2 = M*f3D;
f2 = [f2(1,:)./f2(3,:); f2(2,:)./f2(3,:); f2(3,:)./f2(3,:)];
toc;
