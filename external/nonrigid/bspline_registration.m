function [O_error, O_grad] = bspline_registration(O_grid, sizes, Spacing, I1, I2)

    % convert grid vector to grid matrix
    O_grid=reshape(O_grid, sizes);
    
    % transform the image with the B-spline grid
    [TI2,D]=bspline_transform(O_grid,Spacing,I2);
    
    % calculate the current registration error
    O_error=mad_error(I1, TI2);
    
    % display temp. error
    disp(['O_error: ' num2str(O_error)]);

    % not computing gradients
    % using methods that do not require them!
    if (nargout > 1)
        O_grad = 0;
    end
end

