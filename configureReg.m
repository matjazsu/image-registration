function REG = configureReg()
%% REG structure
    % index of current selected reference image
    REG.refIdx = int32(1);
    % index of current selected moving image
    REG.movIdx = int32(1);
    % images array
    REG.img = [];
end

