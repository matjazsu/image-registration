global REG;
global GUI;

if isempty(REG)
    REG = configureReg();
end

for index=1:size(REG.img)
   if ~exist('REG.img(index).data_resample','var')
       REG.img(index).data_resample=[];
   end
end

if isempty(GUI)
   GUI = configureGui(); 
end

% add path
addpath(genpath(pwd));

% init gui
run(fullfile(GUI.path, GUI.name));