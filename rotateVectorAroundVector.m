function [A2]=rotateVectorAroundVector(A,Ref,thR)
%force to be horizontal
A=A(:)';
Ref=Ref(:)';
if (A*Ref'==1)
  A2=A(:);
else
Apara=(A*Ref')/(Ref*Ref')*Ref;
Aperp=A-Apara;
omega=cross(Ref,Aperp);
x1=cosd(thR)/norm(Aperp);
x2=sind(thR)/norm(omega);
AperpthR=norm(Aperp)*(x1*Aperp+x2*omega);
A2=AperpthR+Apara;
A2=A2(:);
end



end
