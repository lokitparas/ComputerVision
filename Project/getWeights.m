function w =  getWeights(y0_bins, q, p, num_bins, points, center, ax)
    w = zeros(size(y0_bins));
    for i = 1:num_bins
        w(y0_bins == i) = sqrt(q(i)/(p(i)+eps));
    end


	scaled_dist = (bsxfun(@minus,points,center).^2);
	scaled_dist = bsxfun(@rdivide, scaled_dist, (ax.^2));
	scaled_dist = sum(scaled_dist, 2);
	w= w.*kernel_derivative(scaled_dist);
end

function val = kernel_derivative(x)
val = zeros(size(x));
val(x<1) = 3/(2*pi);
end