function rigid_procedure()

    global REG;    
    
    % init parameters
    t = [0 0 0]; % translation in mm
    r = [0 0 0]; % rotation in degrees
    
    % NLopt configuration files
    path(path,'/Applications/MATLAB_R2014a.app/NLopt');
    
    % set NLopt opt structure
    opt.algorithm = NLOPT_LN_COBYLA;
    opt.min_objective = (@(x) rigid_registration(x));
    opt.xtol_rel = 1e-4;
    opt.maxeval = 300;
    opt.verbose = 1;
    
    % execute NLopt optimization
    [xopt] = nlopt_optimize(opt, [t r]);
    
    % get optimized parameters
    t = [xopt(1) xopt(2) xopt(3)];
    r = [xopt(4) xopt(5) xopt(6)];

    % calculate transformation matrix
    T = rigid_transform(t, r);
    
    % set transformation matrix
    REG.img(REG.movIdx).T = single(T);

end

