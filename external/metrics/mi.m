function [M] = mi()
% MI mi computes the Mutual Information
% similarity measure

    global REG;

    % calculate joint histogram
    H = pvi(REG);
    
    % normalized joint histogram
    hn = H./sum(H(:)); 
    X_marg = sum(hn,2);
    Y_marg = sum(hn,1); 

    % entropy of X
    Hx = -sum(X_marg.*log2(X_marg+(X_marg==0))); 
    % Entropy of Y
    Hy = -sum(Y_marg.*log2(Y_marg+(Y_marg==0)));

    % mutual information
    arg_XY = hn.*(log2(hn+(hn==0)));
    Hxy = sum(-arg_XY(:));
    
    M = Hx + Hy - Hxy;
end

