function [new_ax, new_center] = meanShift(image, ax_prev, center, q, num_bins)
num_itt = 0;
max_bhatta = 0;

for ax_ratio = 0.9:0.01:1.1
    ax = ax_ratio*ax_prev;
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
            bhatta1 = bhatta0;
            break;
        else
            if dot(center1-center, center1-center) < 0.5
                center1 = round(center1);
                % bhatta1 = bhatta1;
                break;
            else
                center = center1;
                bhatta0 = bhatta1;
            end
        end
        num_itt = num_itt+1;
    end
    if bhatta1 > max_bhatta
        % disp(max_bhatta);
        % disp(bhatta1);
        new_center = round(center1);
        new_ax = ax;
        max_bhatta = bhatta1;
    end
end

end
