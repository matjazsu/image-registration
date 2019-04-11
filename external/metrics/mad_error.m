function [MAD] = mad_error(I1, I2)
% MAD_ERROR mad_errir calculates Mean Absolute Difference 
% similarity measure

    % image size in voxels
    isize = size(I1);
    
    % calculate mean absolute difference
    D = abs(minus(I1,I2));
    MAD = nansum(D(:))/(isize(1)*isize(2));
end

