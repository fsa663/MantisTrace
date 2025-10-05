function [E]=preprocessElements(E)
[~,n]=size(E);

for i=1:n
    E(i).axis=E(i).axis./sqrt(E(i).axis*E(i).axis');
    Pa1=Pa2=Pa3=[];

    if strcmp(E(i).type,'sphericalSurface')
        R=E(i).radius;
		if R<0, R=-R; E(i).axis=-E(i).axis; end %if a negative radius is specified, reverse the signs of the radius and axis to preserve uniformity
        A=E(i).aperture;
        bm=sqrt(R^2-(A/2)^2);

        E(i).spherecenter=E(i).center-E(i).axis*bm;

        d=E(i).axis*E(i).center';
        E(i).backplane=[E(i).axis -d];
        a=d-R;
        % Generate 2D points for plotting later
        cntA=1;
        for ti=0:5:360
            P=[E(i).spherecenter(1)+R*cos(ti*pi/180) E(i).spherecenter(2)+R*sin(ti*pi/180) 0];
            n2=E(i).backplane(1:end-1);d=E(i).backplane(end);
            Ptst=E(i).spherecenter;
            s1=(n2*Ptst'+d)>=0;s2=(n2*P'+d)>=0;
            if (s1~=s2);
              E(i).cc(cntA,:)=P;cntA=cntA+1;
            end;
        end
       % Generate 3D points for plotting later
       angleTH0=(180/pi)*atan(0.5*A/bm);dth=angleTH0/5;
       %dth=angleTH0/20;
        ang1=0:dth:360;ang2=(0:dth:180)';
        Pa1=E(i).spherecenter(1)+R*sin(ang2*pi/180).*cos(ang1*pi/180);
        Pa2=E(i).spherecenter(2)+R*sin(ang2*pi/180).*sin(ang1*pi/180);
        Pa3=E(i).spherecenter(3)+R*cos(ang2*pi/180).*ones(size(ang1));
        %{
        'test code start, this code gets rid of the separation in the lens when pointing away'

        Pa1=Pa2=Pa3=[];
        FR1=R*sin(ang2*pi/180).*cos(ang1*pi/180);
        FR2=R*sin(ang2*pi/180).*sin(ang1*pi/180);
        FR3=R*cos(ang2*pi/180).*ones(size(ang1));
        %RotationAxis=cross([-1 0 0],E(i).axis);
        ax=E(i).axis;
        RotationAxis=[1;1;1];RotationAxis=RotationAxis-(ax(:)'*RotationAxis)*ax(:);RotationAxis=RotationAxis/vecnorm(RotationAxis);
        RotationAxis=RotationAxis-([-1;0;0]'*RotationAxis)*[-1;0;0];RotationAxis=RotationAxis/vecnorm(RotationAxis);
        RotationAngle=acosd([-1 0 0]*E(i).axis(:));
        [a1,a2]=size(FR1);
        for ti=1:a1
          for tj=1:a2
              [GR]=rotateVectorAroundVector([FR1(ti,tj);FR2(ti,tj);FR3(ti,tj)],RotationAxis(:), RotationAngle);
        Pa1(ti,tj)=E(i).spherecenter(1)+GR(1);
        Pa2(ti,tj)=E(i).spherecenter(2)+GR(2);
        Pa3(ti,tj)=E(i).spherecenter(3)+GR(3);
      end
      end
        'end test code'
        %}
        n2=E(i).backplane(1:end-1);d=E(i).backplane(end);
        Ptst=E(i).spherecenter;
        s1=(n2*Ptst'+d)>=0;s2=(n2(1)*Pa1+n2(2)*Pa2+n2(3)*Pa3+d)>=0;
        %figure;imagesc(s2)
        E(i).cc3d(:,:,1)=Pa1;
        E(i).cc3d(:,:,2)=Pa2;
        E(i).cc3d(:,:,3)=Pa3;
        E(i).dnp=(s2==s1);
         %figure;imagesc(E(i).dnp)
         [E(i).cc3d,E(i).dnp]=shiftUnwrapping(E(i).cc3d,E(i).dnp);
         %figure;imagesc(E(i).dnp);title('after')
    end %sphericalSurface

if strcmp(E(i).type,'Aspheric')
        R=E(i).radius;
		if R<0, R=-R; E(i).axis=-E(i).axis; end %if a negative radius is specified, reverse the signs of the radius and axis to preserve uniformity

        A=E(i).aperture;C=1/R;
        K=E(i).asphericParam(1);
        s0=E(i).RSignConvention;
        %{
        rho=A/2;
        J=sqrt(1-(1+K)*C^2*rho.^2);
        sag=C*rho.^2./(1+J);
        for j1=2:length(E(i).asphericParam)
               sag=sag+E(i).asphericParam(j1)*rho.^(j1*2);
        end
        bm=sqrt(R^2-(A/2)^2)+sag;E(i).spherecenter=E(i).center-E(i).axis*bm;
        %}
        %bm=sqrt(R^2-(A/2)^2)
        rho=A/2;
        J=sqrt(1-(1+K)*C^2*rho.^2);
        SagAtEdge=s0*C*rho.^2./(1+J);
        for j1=2:length(E(i).asphericParam)
             SagAtEdge=SagAtEdge+E(i).asphericParam(j1)*rho.^(j1*2);
        end

        E(i).spherecenter=E(i).center-E(i).axis*(R-SagAtEdge);

        d=E(i).axis*E(i).center';
        E(i).backplane=[E(i).axis -d];
        a=d-R;
        % Generate 2D points for plotting later
        cntA=1;
        %{
        for ti=0:5:360
            P=[E(i).spherecenter(1)+R*cos(ti*pi/180) E(i).spherecenter(2)+R*sin(ti*pi/180) 0]';
            %Now aspheric addition
            D4=P-(P'*E(i).axis')*E(i).axis';
            rho=sqrt(D4'*D4);
            J=sqrt(1-(1+K)*C^2*rho.^2);
            sag=C*rho.^2./(1+J);
            for j1=2:length(E(i).asphericParam)
                sag=sag+E(i).asphericParam(j1)*rho.^(j1*2);
            end
            P=P-sag*E(i).axis';
            % end of aspheric correction
            n2=E(i).backplane(1:end-1);d=E(i).backplane(end);
            Ptst=E(i).spherecenter;
            s1=(n2*Ptst'+d')>=0;s2=(n2*P+d')>=0;
            if (s1~=s2);
              E(i).cc(cntA,:)=P;cntA=cntA+1;
            end;
        end
        %}
       % Generate 3D points for plotting later
        %{
        angleTH0=(180/pi)*atan(0.5*A/(R-SagAtEdge));dth=angleTH0/5;
        ang1=0:dth:360;ang2=(0:dth:180)';
        Pa1=E(i).spherecenter(1)+R*sin(ang2*pi/180).*cos(ang1*pi/180);
        Pa2=E(i).spherecenter(2)+R*sin(ang2*pi/180).*sin(ang1*pi/180);
        Pa3=E(i).spherecenter(3)+R*cos(ang2*pi/180).*ones(size(ang1));
        %}
        ax=E(i).axis;
        vecA=[1;1;1];vecA=vecA-(ax(:)'*vecA)*ax(:);vecA=vecA/vecnorm(vecA);
        ang1=0:20:360;
        fa=linspace(0,A/2,10);
        for ti=1:length(ang1)
              [vecG]=rotateVectorAroundVector(vecA,E(i).axis(:),ang1(ti));
              for tj=1:length(fa)
                    Pa1(ti,tj)=E(i).center(1)+vecG(1)*fa(tj);
                    Pa2(ti,tj)=E(i).center(2)+vecG(2)*fa(tj);
                    Pa3(ti,tj)=E(i).center(3)+vecG(3)*fa(tj);
               end
        end

        % now aspheric addition
        %D4=P-(P'*E(i).axis)*E(i).axis;
        D41=Pa1-(Pa1*E(i).axis(1)+Pa2*E(i).axis(2)+Pa3*E(i).axis(3))*E(i).axis(1);
        D42=Pa2-(Pa1*E(i).axis(1)+Pa2*E(i).axis(2)+Pa3*E(i).axis(3))*E(i).axis(2);
        D43=Pa3-(Pa1*E(i).axis(1)+Pa2*E(i).axis(2)+Pa3*E(i).axis(3))*E(i).axis(3);
        rho=sqrt(D41.^2+D42.^2+D43.^2);
        J=sqrt(1-(1+K)*C^2*rho.^2);
        sag=s0*C*rho.^2./(1+J);
        for j1=2:length(E(i).asphericParam)
             sag=sag+E(i).asphericParam(j1)*rho.^(j1*2);
        end
        %{
        Pa1=Pa1-sag*E(i).axis(1);
        Pa2=Pa2-sag*E(i).axis(2);
        Pa3=Pa3-sag*E(i).axis(3);
        %}
        Pa1=E(i).spherecenter(1)+(R-sag)*E(i).axis(1)+D41;
        Pa2=E(i).spherecenter(2)+(R-sag)*E(i).axis(2)+D42;
        Pa3=E(i).spherecenter(3)+(R-sag)*E(i).axis(3)+D43;
        ImaginaryViolations=(real(Pa1)~=Pa1) | (real(Pa2)~=Pa2) | (real(Pa3)~=Pa3);
        Pa1=Pa1.*(1-ImaginaryViolations);
        Pa2=Pa2.*(1-ImaginaryViolations);
        Pa3=Pa3.*(1-ImaginaryViolations);

        % end of spherical correction
        n2=E(i).backplane(1:end-1);d=E(i).backplane(end);

        Ptst=E(i).spherecenter;
        s1=(n2*Ptst'+d)>=0;s2=(n2(1)*Pa1+n2(2)*Pa2+n2(3)*Pa3+d)>=0;
        %figure;imagesc(s2)
        E(i).cc3d(:,:,1)=Pa1;
        E(i).cc3d(:,:,2)=Pa2;
        E(i).cc3d(:,:,3)=Pa3;
        E(i).dnp=(s2==s1) | ImaginaryViolations;
        %figure(111); imagesc((s2==s1));
        %figure(112); imagesc((ImaginaryViolations));
            %figure;imagesc(E(i).dnp)
    end %end aspheric

    if strcmp(E(i).type,'circularPlanarSurface')
        E(i).axis=E(i).axis./sqrt(E(i).axis*E(i).axis');
        A=E(i).aperture;
        ax=E(i).axis;
        f=[ax(2) -ax(1) 0];
        cnt=1;
        for ti=-10:10
            E(i).cc(cnt,:)=E(i).center+ti*f/10*E(i).aperture*0.5;cnt=cnt+1;
        end
        vecA=[1;1;1];vecA=vecA-(ax(:)'*vecA)*ax(:);vecA=vecA/vecnorm(vecA);
        ang1=0:20:360;
        fa=linspace(0,A/2,5);%fa(end+1)=fa(end)+1;fa(end+1)=fa(end)+1;
        for ti=1:length(ang1)
              [vecG]=rotateVectorAroundVector(vecA,E(i).axis(:),ang1(ti));
              %figure(320); hold on; quiver3(0,0,0,vecG(1),vecG(2),vecG(3)); axis equal
              for tj=1:length(fa)
                    Pa1(ti,tj)=E(i).center(1)+vecG(1)*fa(tj);
                    Pa2(ti,tj)=E(i).center(2)+vecG(2)*fa(tj);
                    Pa3(ti,tj)=E(i).center(3)+vecG(3)*fa(tj);
               end
        end

        %debugging
        %{
        vecB=cross(ax(:),vecA);
        fa=linspace(-A/2,A/2,10);
        'ToDO: regenerate the circle effeciently and beautifully'
        Pa1=E(i).center(1)+fa*vecA(1)+fa'*vecB(1);
        Pa2=E(i).center(2)+fa*vecA(2)+fa'*vecB(2);
        Pa3=E(i).center(3)+fa*vecA(3)+fa'*vecB(3);
        %}

        E(i).cc3d(:,:,1)=Pa1;
        E(i).cc3d(:,:,2)=Pa2;
        E(i).cc3d(:,:,3)=Pa3;
        cnd=((Pa1-E(i).center(1)).^2+(Pa2-E(i).center(2)).^2+(Pa3-E(i).center(3)).^2)>(A/2)^2;
        cnd=0*cnd;
        E(i).dnp=cnd;
    end

    if strcmp(E(i).type,'circularAperture')
        E(i).axis=E(i).axis./sqrt(E(i).axis*E(i).axis');
        A=E(i).aperture;
        ax=E(i).axis;
        f=[ax(2) -ax(1) 0];
        cnt=1;
        for ti=-10:10
            E(i).cc(cnt,:)=E(i).center+ti*f/10*E(i).aperture*0.5;cnt=cnt+1;
        end
        vecA=[1;1;1];vecA=vecA-(ax(:)'*vecA)*ax(:);vecA=vecA/vecnorm(vecA);
        ang1=0:20:360;
        fa=linspace(0,A/2,5);%fa(end+1)=fa(end)+1;fa(end+1)=fa(end)+1;
        for ti=1:length(ang1)
              [vecG]=rotateVectorAroundVector(vecA,E(i).axis(:),ang1(ti));
              %figure(320); hold on; quiver3(0,0,0,vecG(1),vecG(2),vecG(3)); axis equal
              for tj=1:length(fa)
                    Pa1(ti,tj)=E(i).center(1)+vecG(1)*fa(tj);
                    Pa2(ti,tj)=E(i).center(2)+vecG(2)*fa(tj);
                    Pa3(ti,tj)=E(i).center(3)+vecG(3)*fa(tj);
               end
        end

        E(i).cc3d(:,:,1)=Pa1;
        E(i).cc3d(:,:,2)=Pa2;
        E(i).cc3d(:,:,3)=Pa3;
        cnd=((Pa1-E(i).center(1)).^2+(Pa2-E(i).center(2)).^2+(Pa3-E(i).center(3)).^2)>(A/2)^2;
        cnd=0*cnd;
        E(i).dnp=cnd;
    end
	
	
    if (length(E(i).indexout)==0);E(i).indexout=1;end;
    if (length(E(i).indexcenter)==0);E(i).indexcenter=1;end;
    if length(E(i).isBoundary)==0;E(i).isBoundary=0;end

    if (length(E(i).autoStop)==1) % the main loop does not cycle over the new elements
    if (E(i).autoStop==1) % add more elements (stops) for each autostop encountered
          i_New=length(E)+1;
          E(i_New).type='circularAperture';
          E(i_New).center=E(i).center;  E(i_New).axis=[1 0 0];
          E(i_New).aperture=E(i).aperture;
          E(i_New).aperture=E(i).aperture;
          E(i_New).indexout=1;E(i_New).indexcenter=1; % does not necessarily have to be vacuum, but the ray will be killed anyways
    end
    end

end


end
