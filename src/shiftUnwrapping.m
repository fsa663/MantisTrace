function [Q,dnp]=shiftUnwrapping(Q,dnp)
% updated to circshift for octave10
Q1=Q(:,:,1);
Q2=Q(:,:,2);
Q3=Q(:,:,3);

[a1,a2]=size(Q1);
flagDone=0;
for i=0:a1
  if flagDone==0
    dnp2=circshift(dnp,i,1);
     cnd=all(dnp2(1,:)) && all(dnp2(end,:));
     if cnd
          flagDone=1;ic=i;
      end
   end
end

dnp=circshift(dnp,ic,1);
Q1=circshift(Q1,ic,1);
Q2=circshift(Q2,ic,1);
Q3=circshift(Q3,ic,1);

flagDone=0;
for i=0:a2
  if flagDone==0
    dnp2=circshift(dnp,i,2);
     cnd=all(dnp2(:,1)) && all(dnp2(:,end));
     if cnd
          flagDone=1;ic=i;
      end
   end
end

dnp=circshift(dnp,ic,2);
Q1=circshift(Q1,ic,2);
Q2=circshift(Q2,ic,2);
Q3=circshift(Q3,ic,2);
Q(:,:,1)=Q1;
Q(:,:,2)=Q2;
Q(:,:,3)=Q3;

end %end function
