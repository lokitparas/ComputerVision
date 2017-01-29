function [ M ] = getCalib( WC, IC )
%getCalib Gets M from World and Image coordinates
WC_1 = [WC' ones(size(WC,2),1)];
zero = zeros(size(WC,2),4);
x_vec = -IC(1,:)';
y_vec = -IC(2,:)';
A = [WC_1 zero bsxfun(@times,x_vec, WC_1) ; zero WC_1 bsxfun(@times, y_vec, WC_1)];

[~, ~, V] = svd(A);
M = reshape(V(:,12), 4,3)';

end

