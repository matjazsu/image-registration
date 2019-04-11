function dicom()
%DICOM dicom is used by gui to 
% read 3D images in dicom format
    global REG;
    global GUI;
    
    if isempty(GUI.internal.images.file_path)
        GUI.internal.images.file_path = '~';
    end
    
    % read input
    Dir_Path = uigetdir(GUI.internal.images.file_path, 'Pick a Directory');
    
    % input validation
    if isequal(Dir_Path, 0)
        return;
    end
    
    % set file_path
    GUI.internal.images.file_path = Dir_Path;
    
    if ~isempty(REG.img)
        REG.movIdx = int32(length(REG.img) + 1);
    else 
        REG.movIdx = int32(1);
    end
    
    LoadDicomVolume(REG.movIdx, Dir_Path);
    
    if size(REG.img) < REG.movIdx
        REG.movIdx = int32(REG.movIdx - 1);
        if REG.movIdx <= 0
            REG.movIdx = int32(1);
        end
    end
end

