function jointHistogram()
%JOINTHISTOGRAM jointHistogram computes the joint histogram 
% between the reference and moving image
% parameters: REG structure

    global REG;
    
    % validation
    if isempty(REG) || isempty(REG.img)
        return;
    end

    % validation
    if isempty(REG.img(REG.refIdx))
        return;
    end

    % validation
    if isempty(REG.img(REG.movIdx))
        return;
    end
    
    T = REG.img(REG.movIdx).T;
    D = REG.img(REG.movIdx).D;
    if isempty(REG.img(REG.movIdx).data_resample)
        REG.img(REG.movIdx).T = [];
        REG.img(REG.movIdx).D = [];
    end
    
    % calculate joint histogram
    H = pvi(REG);
    
    REG.img(REG.movIdx).T = T;
    REG.img(REG.movIdx).D = D;
    
    % show joint histogram
    figure('name', 'Joint Histogram', 'numbertitle', 'off');
    imagesc(log(H+1)); colormap gray;
end

