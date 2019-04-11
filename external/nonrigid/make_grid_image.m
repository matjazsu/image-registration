function [I_grid] = make_grid_image(Spacing, sizeI)

    O_grid=make_init_grid(Spacing, sizeI);

    % make an image for showing the grid.
    I_grid=zeros([sizeI(1) sizeI(2) sizeI(3)]);
    for j=1:size(O_grid,2),
        for k=1:size(O_grid,3),
            py=round(O_grid(1,j,k,2))+1;
            pz=round(O_grid(1,j,k,3))+1;
            if(py>0&&py<=sizeI(2)&&pz>0&&pz<=sizeI(3)), I_grid(:,py,pz)=1; end
        end
    end
    for i=1:size(O_grid,1),
        for k=1:size(O_grid,3),
            px=round(O_grid(i,1,k,1))+1;
            pz=round(O_grid(i,1,k,3))+1;
            if(px>0&&px<=sizeI(1)&&pz>0&&pz<=sizeI(3)), I_grid(px,:,pz)=1; end
        end
    end
    for i=1:size(O_grid,1),
        for j=1:size(O_grid,2),
            px=round(O_grid(i,j,1,1))+1;
            py=round(O_grid(i,j,1,2))+1;
            if(px>0&&px<=sizeI(1)&&py>0&&py<=sizeI(2)), I_grid(px,py,:)=1; end
        end
    end
end

