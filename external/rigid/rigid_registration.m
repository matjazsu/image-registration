function [O_error, O_grad] = rigid_registration(x)

    global REG;

    % get transformation parameters
    t = [x(1) x(2) x(3)];
    r = [x(4) x(5) x(6)];

    % calculate rigid transformation
    T = rigid_transform(t, r);
    
    % save transformation matrix
    REG.img(REG.movIdx).T = single(T);
    
    % get reference image
    I1 = REG.img(REG.refIdx).data;
    
    % get transformed image
    TI2 = resampleMov2Ref_(REG);
    
    % calculate mutual information
    % O_error = mi();
    O_error=mad_error(double(I1), double(TI2));
    
    % display temp. error
    disp(['O_error: ' num2str(O_error)]);

    % not computing gradients
    % using methods that do not require them!
    if (nargout > 1)
        O_grad = 0;
    end
    
end

