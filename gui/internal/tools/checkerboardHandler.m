function checkerboardHandler()
%CHECKERBOARDHANDLER checkerboardHandler is used by gui to 
% initialize the window for viewing the checkerboard pattern
% between the reference and the moving image
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

    handle = checker_board;
    waitfor(handle);
end

