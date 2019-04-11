function GUI = configureGui()
%% GUI structure
    GUI = {};
    GUI.path = [pwd '/gui/'];
    GUI.name = 'window.m';
    
    %% gui/internal

    GUI.internal = {};
    GUI.internal.path = strcat(GUI.path, 'internal/');
    
    %% gui/internal/images
    
    GUI.internal.images = {};
    GUI.internal.images.file_path = '';
    GUI.internal.images.path = strcat(GUI.internal.path, 'images/');
    
    GUI.internal.images.brainweb = {};
    GUI.internal.images.brainweb.name = 'brainweb.m';
    
    GUI.internal.images.rire = {};
    GUI.internal.images.rire.name = 'rire.m';
    
    GUI.internal.images.dicom = {};
    GUI.internal.images.dicom.name = 'dicom.m';
    
    %% gui/internal/tools
    
    GUI.internal.tools = {};
    GUI.internal.tools.path = strcat(GUI.internal.path, 'tools/');
    
    GUI.internal.tools.selector = {};
    GUI.internal.tools.selector.name = 'selectorHandler.m';
    
    GUI.internal.tools.joint_histogram = {};
    GUI.internal.tools.joint_histogram.name = 'jointHistogram.m';
    
    GUI.internal.tools.transform = {};
    GUI.internal.tools.transform.name = 'transform.m';
    
    GUI.internal.tools.difference = {};
    GUI.internal.tools.difference.name = 'differenceHandler.m';
    
    GUI.internal.tools.checkerboard = {};
    GUI.internal.tools.checkerboard.name = 'checkerboardHandler.m';
    
    %% external
    
    GUI.external = {};
    GUI.external.path = [pwd '/external/'];
    GUI.external.name = '';
end

