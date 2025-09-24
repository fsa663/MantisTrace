function [rayReflected,rayRefracted,raycmp]=extendRay(E,ray)
    cnt=1;e0=1e-12;DEBUGMode=0;
    [~,n]=size(E);
    for i=1:n
        F=[ray(4);ray(5);ray(6)];c0=[ray(1);ray(2);ray(3)];
         %Cycle through the optical elements, check if we have an intersection with this given ray
        if strcmpi(E(i).type,'sphericalSurface') && (i~=ray(13))  % second condition to make sure that the ray does not reintersect the same surface
            R=E(i).radius;
            k1=c0(1)-E(i).spherecenter(1);
            k2=c0(2)-E(i).spherecenter(2);
            k3=c0(3)-E(i).spherecenter(3);
            a=F(1)^2+F(2)^2+F(3)^2;
            b=2*k1*F(1)+2*k2*F(2)+2*k3*F(3);
            c=k1^2+k2^2+k3^2-R^2;
            del=sqrt(b^2-4*a*c);
            alpha1=(-b+del)/(2*a);
            alpha2=(-b-del)/(2*a);
            n2=E(i).backplane(1:end-1);d=E(i).backplane(end);
            Ptst=E(i).spherecenter;

            P=c0+alpha1*F;
            s1=(n2*Ptst'+d)>=0;s2=(n2*P+d)>=0;
            cm1=(s1~=s2)&&(alpha1>1e-12)&&(alpha1==real(alpha1));
            if (cm1) ;P1=P;end

            P=c0+alpha2*F;
            s1=(n2*Ptst'+d)>=0;s2=(n2*P+d)>=0;
            cm2=(s1~=s2)&& (alpha2>1e-12)&&(alpha2==real(alpha2));
            if (cm2);P1=P;end

            cm=(cm1||cm2);
        end%%%%%end lens
        if strcmpi(E(i).type,'Aspheric')  && (i~=ray(13))
            %Test code
            %E(1).radius=25;E(1).asphericParam=[0 0 0 0 0] E(1).center=[100 0 0]'; E(1).spherecenter=[110 0 0]'i=1; c0=[10 0 0]';F=[1 0 0]'

            R=E(i).radius;C=1/R;
            K=E(i).asphericParam(1);
            s0=E(i).RSignConvention;
            d1=E(i).spherecenter-c0;
            maxAL=sqrt(vecnorm(d1(:))^2+R^2);
            alpha01=0:0.01:2*maxAL;
            P_cand=c0+alpha01.*F;

            if DEBUGMode==1
                figure(101);scatter3(P_cand(1,:),P_cand(2,:),P_cand(3,:)); hold on;
                xx0=E(i).cc3d(:,:,1);zz0=E(i).cc3d(:,:,3);
                dnp=E(i).dnp;
                xx=xx0(~dnp);zz=zz0(~dnp);
                scatter(xx(:),zz(:));
            end

           D41=P_cand(1,:)-(P_cand(1,:)*E(i).axis(1)+P_cand(2,:)*E(i).axis(2)+P_cand(3,:)*E(i).axis(3))*E(i).axis(1);
           D42=P_cand(2,:)-(P_cand(1,:)*E(i).axis(1)+P_cand(2,:)*E(i).axis(2)+P_cand(3,:)*E(i).axis(3))*E(i).axis(2);
           D43=P_cand(3,:)-(P_cand(1,:)*E(i).axis(1)+P_cand(2,:)*E(i).axis(2)+P_cand(3,:)*E(i).axis(3))*E(i).axis(3);

           rho=sqrt(D41.^2+D42.^2+D43.^2);
           J=sqrt(1-(1+K)*C^2*rho.^2);
           ImaginaryViolations=(real(J)~=J);

           P_cand=P_cand(:,~ImaginaryViolations);rho=rho(~ImaginaryViolations);J=J(~ImaginaryViolations);
           sag=s0*C*rho.^2./(1+J);
           for j1=2:length(E(i).asphericParam)
                sag=sag+E(i).asphericParam(j1)*rho.^(j1*2);
            end

            VectorOfShadowOnLens=E(i).spherecenter(:)+P_cand+ (R-sag-P_cand(1,:)*E(i).axis(1)-P_cand(2,:)*E(i).axis(2)-P_cand(3,:)*E(i).axis(3)).*E(i).axis(:);

            [LP1,LP2]=size(VectorOfShadowOnLens);
            if LP2~=0
                    DirectionVector=VectorOfShadowOnLens-E(i).spherecenter(:);DirectionVector=DirectionVector/vecnorm(DirectionVector);
                    Error=(VectorOfShadowOnLens-P_cand)'*DirectionVector;
                    %figure(102); plot(Error); hold on;
                    ZeroExists=sum(Error>=0)*sum(Error<=0);
                    if ZeroExists>=1
                      P=[interp1(Error,P_cand(1,:),0);interp1(Error,P_cand(2,:),0);interp1(Error,P_cand(3,:),0)];
                      TotallyReal=(P(1)==real(P(1)))*(P(2)==real(P(2)))*(P(3)==real(P(3)));
                      %if ~TotallyReal, 'Warning None Real solution'; end
                      VecBackPlaneToIntersec=P-E(i).center(:);
                      %verify the solution is infront of the backplane
                      if (TotallyReal)&& ((VecBackPlaneToIntersec'*E(i).axis(:))>=0)
                          cm=1;
                          P1=P;
                          %figure(250); scatter3(P1(1),P1(2),P1(3)); hold on;
                      else
                          cm=0;
                      end
                      %figure(109); hold on;scatter3(P1(1),P1(2),P1(3));
                    end % end if zeroexists
           end


        end %End Aspheric

        if strcmp(E(i).type,'plane')  && (i~=ray(13))
            nv=E(i).axis;d=nv*E(i).center';
            if (nv*F==0);cm=0;else
                alpha=(d-nv*c0)/(nv*F);
                P1=c0+alpha*F;
                h1=P1-c0;r=sqrt(h1'*h1);
                cm=(alpha>0);
            end
        end%end plane


        if strcmp(E(i).type,'circularPlanarSurface') && (i~=ray(13))
            nv=E(i).axis;d=nv*E(i).center';
            if (nv*F==0);
                cm=0;
            else
                alpha=(d-nv*c0)/(nv*F);
                P1=c0+alpha*F;
                h1=P1-c0;r=sqrt(h1'*h1);
                cm1=(alpha>0);
            end
            rcv=sqrt(sum((P1-E(i).center').^2));
            cm2=(rcv<=0.5*E(i).aperture);
            cm=(cm1&&cm2);
        end%%%%%end circularPlanarSurface

        if strcmp(E(i).type,'circularAperture') && (i~=ray(13))
            nv=E(i).axis;d=nv*E(i).center';
            if (nv*F==0);
                cm=0;
            else
                alpha=(d-nv*c0)/(nv*F);
                P1=c0+alpha*F;
                h1=P1-c0;r=sqrt(h1'*h1);
                cm1=(alpha>0);
            end
            cm=cm1;
        end%%%%%end circularaperture

       %If there is any possible intersection of the element with the ray,log the result
        if (cm)
            v1=P1-c0;
            %find the distance of the intersection from the source of the ray and log it
            r=sqrt(v1'*v1);
            possIntrsc(cnt,:)=[r c0'   P1' i];
            %                                  1  2-4   5-7  8
            cnt=cnt+1;
        end
    end%%%%%%%%%%%%%%%%%%%%%%%end for

    if cnt>1
        %find the intersection closest to the source
        [~,in]=min(possIntrsc(:,1));
        crctIntrsc=possIntrsc(in,2:end);
        %find the ID of the correct element that the ray intersected
        elsrc=crctIntrsc(7);
        isBoundary=E(elsrc).isBoundary;
        c0=(crctIntrsc(1:3))';P1=(crctIntrsc(4:6))';
        F=P1-c0;
        dir=sign(E(elsrc).axis*F);
        if (dir==1);
            nf1=E(elsrc).indexcenter;nf2=E(elsrc).indexout;
        else
            nf1=E(elsrc).indexout;nf2=E(elsrc).indexcenter;
        end
        %dp=(F'*nv);%has to point at different diretions
        %nv=-sign(dp)*nv;

        if strcmpi(E(elsrc).type,'sphericalSurface')
            nv=(P1-E(elsrc).spherecenter(:));nv=nv/sqrt(nv'*nv);

            %figure(117+elsrc); quiver3(P1(1),P1(2),P1(3),nv(1),nv(2),nv(3),'k'); hold on
        end
        if strcmpi(E(elsrc).type,'Aspheric')
            e1=0.01;
            vecA=ones(3,1);vecA=vecA-(vecA'*E(elsrc).axis(:))*E(elsrc).axis(:);
            vecA=vecA/vecnorm(vecA);
            vecB=cross(E(elsrc).axis(:),vecA(:));vecB=vecB/vecnorm(vecB);
            [Pa]=findShadowOnAsphericSurface(E,elsrc,P1+e1*vecA);
            [Pb]=findShadowOnAsphericSurface(E,elsrc,P1+e1*vecB);
            %{
            figure(109); scatter3(P1(1),P1(2),P1(3),'k'); hold on;
            scatter3(Pa(1),Pa(2),Pa(3),'b');
            scatter3(Pb(1),Pb(2),Pb(3),'r');
            %}
            nv=cross(Pa-P1,Pb-P1);nv=nv/sqrt(nv'*nv);

            %nv=(P1-E(elsrc).spherecenter(:));nv=nv/sqrt(nv'*nv);
            %figure(109); quiver3(P1(1),P1(2),P1(3),10*nv(1),10*nv(2),10*nv(3),'k'); hold on
            %figure(117+elsrc); quiver3(P1(1),P1(2),P1(3),nv(1),nv(2),nv(3),'k'); hold on
        end
        if ((strcmpi(E(elsrc).type,'plane')) || (strcmpi(E(elsrc).type,'circularPlanarSurface')))
            nv=E(elsrc).axis(:);nv=nv/sqrt(nv'*nv);
            %nv=rand(3,1);nv=nv/vecnorm(nv);
        end
        if (strcmpi(E(elsrc).type,'circularAperture'))
            nv=E(elsrc).axis(:);nv=nv/sqrt(nv'*nv);
            %override isbounary for intersections outside the aperture (when killray==1)
            rcv=sqrt(sum((P1-E(elsrc).center').^2));
            isBoundary=(rcv>=0.5*E(elsrc).aperture);
        end
        %Initialize Total Internal Reflection flag to 0

        Fu0=F/sqrt(F'*F);
        th1=acos(abs(-nv'*Fu0));

        if abs(nf1*sin(th1)/nf2)>1,
              TIR=1;
        else
              TIR=0;
              th2=asin(abs(nf1*sin(th1)/nf2));
              Rs=((nf1*cos(th1)-nf2*cos(th2))/(nf1*cos(th1)+nf2*cos(th2)))^2;
              Rp=((nf1*cos(th2)-nf2*cos(th1))/(nf1*cos(th2)+nf2*cos(th1)))^2;
              % For the time being, I do not factor polarization into calculation. Therefore the coeffecient of reflection is the average for TE and TM
              cR=0.5*(Rs+Rp);
              cT=1-cR;
        end;

        Fn=(F'*nv)*nv;
        F21=F-2*Fn;
        ampF=sqrt(F21'*F21); if ampF==0; ampF=1;end;
        F21=F21/ampF;
        %align nv to f
        F=F/sqrt(F'*F);
        nv2=sign(F'*nv)*nv;%aligned nv
        mv=F-(F'*nv2)*nv2;%vector
        mvamp=sqrt(mv'*mv);mvunit=mv/mvamp;
        b1=mvamp;
        thold=th1;
        th1=asin(b1);
        th2=asin(abs(nf1*sin(th1)/nf2));
        a2=cos(th2);b2=sin(th2);
        F22=a2*nv2+b2*mvunit;
        if TIR==1
             F22=[0;0;0];cR=1;cT=0;
        end
        %figure(117+elsrc); quiver3(P1(1),P1(2),P1(3),F21(1),F21(2),F21(3),'r'); hold on
        %figure(117+elsrc); quiver3(P1(1),P1(2),P1(3),F22(1),F22(2),F22(3),'b'); hold on
        raycmp=[ray P1'];

        %Generate next rays (reflected and refracted)
        if (isBoundary)
            rayReflected=rayRefracted=[];
        else
            d=sqrt(sum((P1-c0).^2));
            %reflected
            rayReflected=[P1' F21' ray(7)*cR ray(8)+d ray(9) ray(10)+1 ray(11) ray(12) elsrc];
            rayReflected=[];
            %transmitted
            rayRefracted=[P1' F22' ray(7)*cT ray(8)+d ray(9) ray(10)      ray(11) ray(12) elsrc];
            %rayRefracted
            if (TIR==1), rayRefracted=[];end;
        end
    end

end
