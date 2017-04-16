function [new_ax, new_center] = meanShift(image, ax, center, q, num_bins)
num_itt = 0;
while (num_itt < 2000)
    [points, bins, p0] = getProfile(image, ax, center, num_bins);
    bhatta0 = sqrt(dot(p0, q));

    w = getWeights(bins, q, p0, num_bins);
    sum_w = sum(w);
    center1 = sum([w.*points(:,1) w.*points(:,2)])/sum_w;
    [~, ~, p1] = getProfile(image, ax, center1, num_bins);
    bhatta1 = sqrt(dot(p1, q));
    
    if (bhatta1 < bhatta0)
        center1 = center;
        break;
    else
        if dot(center1-center, center1-center) < 0.5
            center1 = round(center1);
            break;
        else
            center = center1;
        end
    end
    num_itt = num_itt +1;
end
new_center = round(center1);
new_ax= ax;
end
