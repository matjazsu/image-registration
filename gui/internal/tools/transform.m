function transform()
%TRANSFORM transform is used by gui to 
% execute rigid or nonrigid transformation
% over the moving image

    global REG;

    % validation
    if isempty(REG)
        return;
    end

    % validation
    if isempty(REG.img)
        return;
    end
    
    % validation
    if isempty(REG.img(REG.movIdx))
        return;
    end

    % resample the moving image to the 
    % space of the reference image
    REG.img(REG.movIdx).data_resample = resampleMov2Ref_(REG);
end

