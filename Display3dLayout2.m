function []=Display3dLayout2(raycmpM,E,drawelements)
    figure(109);axis equal;
    [~,num4]=size(E);
    if drawelements
        for i=1:num4
            if strcmpi(E(i).type,'sphericalSurface') || strcmpi(E(i).type,'aspheric') || strcmpi(E(i).type,'circularPlanarSurface')
                Q=E(i).cc3d;
                dnp=E(i).dnp;
                hold on;

                %DrawLens(Q,dnp,E(i).type)
                DrawLens2(Q,dnp,E(i).type)
            end%end spherical surface
        end %for elements
    end %end if drawelements
    %not implemented yet
    %if strcmp(E(i).type,'circularPlanarSurface'),scatter(E(i).cc(:,1),E(i).cc(:,2));hold on;end

    %plot rays
    clrz='rgykmc';
    [a11,a12]=size(raycmpM);
    for i=1:a11
        figure(109);hold on;
        raycmp=raycmpM(i,:);
        crr=clrz(mod(i,6)+1);
        plot3(raycmp([1 14]),raycmp([2 15]),raycmp([3 16]),'r','linewidth',5*raycmp(7));
    end
    xlabel('x'); ylabel('y');zlabel('z');
end %end function
