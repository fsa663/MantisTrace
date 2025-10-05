function [BFL_axial,CLC,Points,Pc,PAcircle]=findBFLandCLC(raySensPlane,E);

[n,~]=size(raySensPlane);

Points=[];

for i=1:n
    for j=i+1:n
          p1=(raySensPlane(j,1:3))';p0=(raySensPlane(i,1:3))';
          Pd=(p1-p0);
          v1=(raySensPlane(j,4:6))';v0=(raySensPlane(i,4:6))';
          A=[v0'*v0 -v0'*v1; -v0'*v1 v1'*v1];
          C=[v0'*Pd;-v1'*Pd];
          if det(A) ~=0,
              B=inv(A)*C;
              t0=B(1);t1=B(2);
              Points(end+1:end+2,:)=[ p0'+t0*v0'; p1'+t1*v1'];
          end

    end
end

Pc=mean(Points);


[in]=findLastElementIndex(E); %index of the last element (which should be the last originator of the ray
BFL_axial=(Pc-E(in).center)*(E(in).axis)';


D=Points-Pc;
g=D*(E(in).axis)';
Dp=D-g.*E(in).axis;R=sqrt(Dp(:,1).^2+Dp(:,2).^2+Dp(:,3).^2);
%CLC=norm(R);
CLC=sqrt(R'*R/length(R));




        ax=E(in).axis;
        vecA=[1;1;1];vecA=vecA-(ax(:)'*vecA)*ax(:);vecA=vecA/vecnorm(vecA);
        ang1=0:20:360;

        for ti=1:length(ang1)
              [vecG]=rotateVectorAroundVector(vecA,ax(:),ang1(ti));
                    PAcircle(ti,:)=[Pc(1)+vecG(1)*CLC Pc(2)+vecG(2)*CLC Pc(3)+vecG(3)*CLC];
        end
    %    PAcircle.Pa1=Pa1;
       % PAcircle.Pa2=Pa2;
        %PAcircle.Pa3=Pa3;

end
