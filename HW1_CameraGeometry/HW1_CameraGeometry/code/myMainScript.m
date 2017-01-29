%% MyMainScript

tic;

data_3d_file = '../input/Calib_data/Features3D_dataset2.mat';
data_2d_file = '../input/Calib_data/Features2D_dataset2.mat';

load(data_3d_file, 'f3D');
load(data_2d_file, 'f2D');

M = getCalib(f3D(1:3, :), f2D(1:2, :));
disp('M:');
disp(M);

disp('Validating M');
findError(f3D, f2D, M);

% Introducing error
err = max(max(abs(f3D(1:3,:))));
err = err*0.05;
f3D_err = f3D(1:3, :);
f2D_err = f2D(1:2, :);
f3D_err = f3D_err + err*randn(size(f3D_err));
f3D_err = [f3D_err; ones(1,size(f3D,2))];
f2D_err = f2D_err + err*randn(size(f2D_err));
f2D_err = [f2D_err; ones(1,size(f2D,2))];

M_err = getCalib(f3D_err(1:3, :), f2D_err(1:2, :));
disp('Validating M_err');
findError(f3D, f2D, M_err);

% P = (f2D_err(:,:)-f2D); P=P(1:3,:); std2(P)
% P = (f3D_err(:,:)-f3D); P=P(1:3,:); std2(P)
% P = err*randn(size(f3D_err)); std2(P)

toc;