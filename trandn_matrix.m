function t = trandn_matrix(l,r,up,low)
    t = zeros(l,r);
    for i = 1:l
        for j = 1:r
            t(i,j) = trandn(low,up);
        end
    end
end