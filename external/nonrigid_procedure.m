function nonrigid_procedure( )

    global REG;
    
    % get reference image
    I1=REG.img(REG.refIdx).data;
    I1=double(I1);
    
    % get moving image
    I2=double(resampleMov2Ref_(REG));
    
    % grid spacing in mm
    % x, y and z direction
    Spacing=[12 12 2];
    
    % make the Initial b-spline registration grid
    O_grid = make_init_grid(Spacing, size(I2));
    O_grid=double(O_grid);
    
    % make smooth images for fast registration without local minimums
    Hsize=round(0.1667*(size(I1,1)/size(O_grid,1)+size(I1,2)/size(O_grid,2)+size(I1,3)/size(O_grid,3)));
    I1=imgaussian(I1,Hsize/5,[Hsize Hsize Hsize]);
    I2=imgaussian(I2,Hsize/5,[Hsize Hsize Hsize]);
    
    % reshape O_trans from a matrix to a vector
    sizes=size(O_grid); O_grid=O_grid(:);

    % NLopt configuration files
    path(path,'/Applications/MATLAB_R2014a.app/NLopt');

    % set NLopt opt structure 
    opt.algorithm = NLOPT_LD_LBFGS; % Low-storage BFGS
    opt.min_objective = (@(x) bspline_registration_gradient(x, sizes, Spacing, I1, I2));
    opt.vector_storage=15;
    opt.xtol_rel = 1e-4;
    opt.verbose = 1;
    
    % execute NLopt optimization
    [O_grid] = nlopt_optimize(opt, O_grid);

    % reshape xopt from a vector to a matrix
    O_grid=reshape(O_grid, sizes);
    
    % transform the input image with the found optimal grid
    [~, D]=bspline_transform(O_grid, Spacing, I2); 

    % convert result
    D=-single(D);
    
    % save results
    REG.img(REG.movIdx).D=D;
    REG.img(REG.movIdx).O_grid=O_grid;
    REG.img(REG.movIdx).Spacing=Spacing;

    % show transformed grid 
    % of control points
    pointsHandler(O_grid, size(I2), Spacing);
end

