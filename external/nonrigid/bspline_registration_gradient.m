function [O_error, O_grad]=bspline_registration_gradient(O_grid, sizes, Spacing, I1, I2)
    
    % convert grid vector to grid matrix
    O_grid=reshape(O_grid,sizes);

    % transform the image with the B-spline grid
    [TI2,D]=bspline_transform(O_grid,Spacing,I2);

    % calculate the current registration error
    O_error=mad_error(I1, TI2);
    
    % display temp. error
    disp(['O_error: ' num2str(O_error)]);

    %
    % Code below is only needed, when the error gradient is asked by the optimizer
    %

    % If gradient needed, also determine the gradient.
    if (nargout > 1)
        O_grad=error_gradient_3d(Spacing, I1, I2, TI2, O_grid);

        O_grad=O_grad(:);

        disp(['Min O_grad: ' num2str(min(O_grad))]);
        disp(['Mean O_grad: ' num2str(mean(O_grad))]);
        disp(['Max O_grad: ' num2str(max(O_grad))]);
        disp('##################################################');
    end
    
end

function O_grad=error_gradient_3d(Spacing,I1,I2,TI2,O_grid)
    O_uniform=make_init_grid(Spacing,size(I2));
    O_grad=zeros(size(O_grid));
    step=1;
    
    for zi=0:(4-1),
        for zj=0:(4-1),
            for zk=0:(4-1),
                % the variables which will contain the controlpoints for
                % determining a forward registration error gradient
                O_gradpx=O_grid; O_gradpy=O_grid; O_gradpz=O_grid;

                % set grid movements of every grid node
                for i=(1+zi):4:size(O_grid,1),
                    for j=(1+zj):4:size(O_grid,2),
                        for k=(1+zk):4:size(O_grid,3),
                            O_gradpx(i,j,k,1)=O_gradpx(i,j,k,1)+step;
                            O_gradpy(i,j,k,2)=O_gradpy(i,j,k,2)+step;
                            O_gradpz(i,j,k,3)=O_gradpz(i,j,k,3)+step;
                        end
                    end
                end

                % do the grid b-spline transformation for movement of nodes to
                I_gradpx=bspline_transform(O_gradpx,Spacing,I2);
                I_gradpy=bspline_transform(O_gradpy,Spacing,I2);
                I_gradpz=bspline_transform(O_gradpz,Spacing,I2);

                for i=(1+zi):4:size(O_grid,1),
                    for j=(1+zj):4:size(O_grid,2),
                        for k=(1+zk):4:size(O_grid,3),
                            % calculate pixel region influenced by a grid node
                            [regAx,regAy,regAz,regBx,regBy,regBz]=region_influence_3D(i,j,k,O_uniform,size(I2));                           

                            % determine the registration error in the region
                            E_gradpx=mad_error(I1(regAx:regBx,regAy:regBy,regAz:regBz),I_gradpx(regAx:regBx,regAy:regBy,regAz:regBz));
                            E_gradpy=mad_error(I1(regAx:regBx,regAy:regBy,regAz:regBz),I_gradpy(regAx:regBx,regAy:regBy,regAz:regBz));
                            E_gradpz=mad_error(I1(regAx:regBx,regAy:regBy,regAz:regBz),I_gradpz(regAx:regBx,regAy:regBy,regAz:regBz));
                            E_grid  =mad_error(I1(regAx:regBx,regAy:regBy,regAz:regBz),TI2(regAx:regBx,regAy:regBy,regAz:regBz));

                            % calculate the error registration gradient
                            O_grad(i,j,k,1)=(E_gradpx-E_grid)/step;
                            O_grad(i,j,k,2)=(E_gradpy-E_grid)/step;
                            O_grad(i,j,k,3)=(E_gradpz-E_grid)/step;
                        end
                    end
                end
            end
        end
    end
end

function [regAx,regAy,regAz,regBx,regBy,regBz]=region_influence_3D(i,j,k,O_uniform,sizeI)
    % calculate pixel region influenced by a grid node
    irm=i-2; irp=i+2;
    jrm=j-2; jrp=j+2;
    krm=k-2; krp=k+2;
    irm=max(irm,1); jrm=max(jrm,1); krm=max(krm,1);
    irp=min(irp,size(O_uniform,1)); jrp=min(jrp,size(O_uniform,2)); krp=min(krp,size(O_uniform,3));

    regAx=O_uniform(irm,jrm,krm,1);
    regAy=O_uniform(irm,jrm,krm,2);
    regAz=O_uniform(irm,jrm,krm,3);
    regBx=O_uniform(irp,jrp,krp,1);
    regBy=O_uniform(irp,jrp,krp,2);
    regBz=O_uniform(irp,jrp,krp,3);

    if(regAx>regBx), regAxt=regAx; regAx=regBx; regBx=regAxt; end
    if(regAy>regBy), regAyt=regAy; regAy=regBy; regBy=regAyt; end
    if(regAz>regBz), regAzt=regAz; regAz=regBz; regBz=regAzt; end

    regAx=max(regAx,1); regAy=max(regAy,1); regAz=max(regAz,1);
    regBx=max(regBx,1); regBy=max(regBy,1); regBz=max(regBz,1);
    regAx=min(regAx,sizeI(1)); regAy=min(regAy,sizeI(2)); regAz=min(regAz,sizeI(3));
    regBx=min(regBx,sizeI(1)); regBy=min(regBy,sizeI(2)); regBz=min(regBz,sizeI(3));
end


