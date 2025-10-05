function [in]=findLastElementIndex(E);

[~,n]=size(E);

%log all non aperture elements or terminal simulation box planes.
A=[];

for i=1:n
     if ((~strcmpi(E(i).type,'circularAperture'))  && (~strcmpi(E(i).type,'plane')))
    A(end+1,:)= [i E(i).center(1)];
    end
end

[~,iw]=max(A(:,2));
in=A(iw,1);


end
