function brainweb()
%BRAINWEB brainweb is used by gui to 
% read 3D images in brainweb format
    global REG;
    global GUI;
    
    if isempty(GUI.internal.images.file_path)
        GUI.internal.images.file_path = '~';
    end
    
    % read input
    [File_Name, File_Path] = uigetfile([GUI.internal.images.file_path '/*.rawb'], 'Pick a file...');

    % input validation
    if isequal(File_Name, 0) || isequal(File_Path, 0)
        return;
    end
    
    % set file_path
    GUI.internal.images.file_path = File_Path;
    
    if ~isempty(REG.img)
        REG.movIdx = int32(length(REG.img) + 1);
    else 
        REG.movIdx = int32(1);
    end
    
    % read image from file
    I = read(strcat(File_Path, File_Name), ...
        [181 217 181], ...
        'uint8=>uint8', ...
        'ieee-le'); 
    
    % save image to REG
    REG.img(REG.movIdx).uid = REG.movIdx;
    REG.img(REG.movIdx).name = File_Name;
    REG.img(REG.movIdx).path = File_Path;
    REG.img(REG.movIdx).data_orig = I;
    REG.img(REG.movIdx).data = im2uint8(I);
    REG.img(REG.movIdx).data_resample = [];
    REG.img(REG.movIdx).voxelSize = single([1 1 1]);
    REG.img(REG.movIdx).O = single([90 126 72]);
    REG.img(REG.movIdx).mask = [];
    REG.img(REG.movIdx).ROI = [];
    REG.img(REG.movIdx).T = [];
    REG.img(REG.movIdx).D = [];
end

