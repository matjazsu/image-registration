function pointsHandler(O_grid, sizes, Spacing)
%POINTSHANDLER pointsHandler is used to 
% initialize the window for viewing the 
% grid of control points
    % validation
    if isempty(O_grid)
        return;
    end

    % validation
    if isempty(sizes)
        return;
    end

    % validation
    if isempty(Spacing)
        return;
    end

    handle = points(O_grid, sizes, Spacing);    
end

