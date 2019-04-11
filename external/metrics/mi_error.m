function [ M ] = mi_error(X, Y)
% MI_ERROR mi_error computes the Mutual Information
% similarity measure
    
    % process image X
    X(isnan(X))=0;
    X=double(X);
    
    % process image Y
    Y(isnan(Y))=0;
    Y=double(Y);
    
    X_norm=round(X-min(X(:)))+1;
    Y_norm=round(Y-min(Y(:)))+1;
    
    matXY(:,1)=X_norm(:);
    matXY(:,2)=Y_norm(:);
    
    % joint histogram
    h=accumarray((matXY+1),1);
    
    % normalized joint histogram
    hn = h./sum(h(:)); 
    X_marg=sum(hn,2);
    Y_marg=sum(hn,1); 

    % entropy of X
    Hx=-sum(X_marg.*log2(X_marg+(X_marg==0))); 
    % entropy of Y
    Hy=-sum(Y_marg.*log2(Y_marg+(Y_marg==0)));

    % mutual Information
    arg_XY=hn.*(log2(hn+(hn==0)));
    Hxy=sum(-arg_XY(:));
    
    M = Hx + Hy - Hxy;
end

