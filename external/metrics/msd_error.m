function [MSD] = msd_error(I1, I2)
% MSD_ERROR msd_error computes the Mean Squared Difference
% similarity measure
    
    % image size in voxels
    isize = size(I1);
    
    % calculate mean squared difference
    D = (minus(I1,I2)).^2;
    MSD = nansum(D(:))/(isize(1)*isize(2));
end

