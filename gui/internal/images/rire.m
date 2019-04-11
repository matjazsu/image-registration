function rire()
%RIRE rire is used by gui to 
% read 3D images in rire format
    global REG;
    global GUI;
    
    if isempty(GUI.internal.images.file_path)
        GUI.internal.images.file_path = '~';
    end
    
    % read input
    [File_Name, File_Path] = uigetfile([GUI.internal.images.file_path '/*.ascii'], 'Pick a file...');
    
    % input validation
    if isequal(File_Name, 0) || isequal(File_Path, 0)
        return;
    end
    
    % set file_path
    GUI.internal.images.file_path = File_Path;
    
    % get header
    imageHeader = helperReadHeaderRIRE(strcat(File_Path, File_Name));
    
    % header validation
    if isempty(imageHeader)
        msgbox('Select *.ascii file!');
        return;
    end
    
    % get image
    imageName = strrep(File_Name, '.ascii', '.bin');
    
    % image validation
    if isempty(imageName)
        msgbox('.bin file not found!');
        return;
    end
    
    if ~isempty(REG.img)
        REG.movIdx = int32(length(REG.img) + 1);
    else 
        REG.movIdx = int32(1);
    end
    
    % read image from file
    I = read(strcat(File_Path, imageName),...
         [imageHeader.Rows, ...
          imageHeader.Columns, ...
          imageHeader.Slices],...
         'int16=>int16', ...
         'ieee-be');
     
    %save image to REG
    REG.img(REG.movIdx).uid = REG.movIdx;
    REG.img(REG.movIdx).name = imageName;
    REG.img(REG.movIdx).path = File_Path;
    REG.img(REG.movIdx).data_orig = I;
    REG.img(REG.movIdx).data = im2uint8(I);
    REG.img(REG.movIdx).data_resample = [];
    REG.img(REG.movIdx).voxelSize = single( ...
        [imageHeader.PixelSize(1), ...
         imageHeader.PixelSize(2), ...
         imageHeader.SliceThickness]);
    REG.img(REG.movIdx).O = single(...
        [(imageHeader.Rows/2) ...
         (imageHeader.Columns/2) ...
         (imageHeader.Slices/2)]);
    REG.img(REG.movIdx).mask = [];
    REG.img(REG.movIdx).ROI = [];
    REG.img(REG.movIdx).T = [];
    REG.img(REG.movIdx).D = [];
end

