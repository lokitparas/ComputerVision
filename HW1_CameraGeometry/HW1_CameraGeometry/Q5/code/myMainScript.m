%% MyMainScript

tic;

folder = uigetdir();
data_3d_file = strcat(folder, '/Features3D_dataset1.mat');
data_2d_file = strcat(folder, '/Features2D_dataset1.mat');

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
f2D_err = f2D_err + err*randn(size(f2D_err));

M_err = getCalib(f3D_err, f2D_err);
disp('Validating M_err');
findError(f3D, f2D, M_err);


toc;