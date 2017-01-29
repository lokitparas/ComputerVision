function [] = findError( f3D, f2D, M )
%findError Outputs maximum error


%Using the obtained 'M' matrix on the given 3D points
f2 = M*f3D;
%Homogenous coordinates
f2 = [f2(1,:)./f2(3,:); f2(2,:)./f2(3,:); f2(3,:)./f2(3,:)];

% Using given image coordinates to validate
K = (f2 - f2D)./f2D;
disp('Maximum error:');
disp(max(max(K)));

end

