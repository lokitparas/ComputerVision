function w =  getWeights(y0_bins, q, p, num_bins)
    w = zeros(size(y0_bins));
    for i = 1:num_bins
        w(y0_bins == i) = sqrt(q(i)/(p(i)+eps));
    end
end