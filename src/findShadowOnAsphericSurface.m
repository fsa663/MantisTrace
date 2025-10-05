function [VectorOfShadowOnLens]=findShadowOnAsphericSurface(E,elsrc,P0)
            D4=P0(:)-(P0(:)'*E(elsrc).axis(:))*E(elsrc).axis(:);
           rho=sqrt(D4'*D4);

            R=E(elsrc).radius;C=1/R;
            K=E(elsrc).asphericParam(1);
            s0=E(elsrc).RSignConvention;
           J=sqrt(1-(1+K)*C^2*rho.^2);
           ImaginaryViolations=(real(J)~=J);
           if ImaginaryViolations
                'Imaginary shadow, intersection very close to edge'
                VectorOfShadowOnLens=[];
           else
                 sag=s0*C*rho.^2./(1+J);
                 for j1=2:length(E(elsrc).asphericParam)
                      sag=sag+E(elsrc).asphericParam(j1)*rho.^(j1*2);
                 end

                  VectorOfShadowOnLens=E(elsrc).spherecenter(:)+P0(:)+ (R-sag-P0(:)'*E(elsrc).axis(:)).*E(elsrc).axis(:);
            end

end
