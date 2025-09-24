% This file is where you configure the setup

%Here you define the boundaries of ray tracing. You need 6 planes to define in order to enclose the simulation
%The center is just a point that lies on the plane defining the boundary
%The axis is the normal describing the plane
%isBoundary indicates that this plane terminates rays and does not reflect or refract


%Sensor.Type='circular';
%Sensor.radius=11.5/2;

Sensor.Type='rectangular';
Sensor.SensLength1=10;
Sensor.SensLength2=12;

%Units are in mm
SensorXDisplacementFromLastElement=50;


%Instead of defining lenses, I define the surfaces of the lenses.

% For a spherical surface, the axis will be the direction where the positive part of the lens surface is pointing at.
% I treat the spherical surface as a spherical section terminated by plane, which I will call the 'end plane'
%aperture: is the diameter of the circle at the intersection of the 'end plane' and the spherical surface
%center: is the point at the center of the circle at the intersection of the 'end plane' and the spherical surface
%radius : Radius of curvature of the spherical surface
% indexcenter: refractive index of the side of the spherical surface closest to the center of the sphere defining the surface
% indexout : refractive index of the other side of the spherical surface
%Element #7 is always the outermost optical element facing the object. This will be used to define the rays.



i=7;
E(i).type='sphericalSurface';
E(i).center=[16 0 0]; E(i).axis=[-1 0 0];E(i).autoStop=1;
E(i).aperture=12.5*10;E(i).radius=25*10;
E(i).indexout=1;E(i).indexcenter=1.50;

i=i+1;
E(i).type='sphericalSurface';
E(i).center=E(i-1).center+[1 0 0]; E(i).axis=[1 0 0];E(i).autoStop=1;
E(i).aperture=12.5*10;E(i).radius=25*10;
E(i).indexout=1;E(i).indexcenter=1.50;

i=i+1;
E(i).type='sphericalSurface';
E(i).center=E(i-1).center+[30*10 0 0]; E(i).axis=[-1 0 0];E(i).autoStop=1;
E(i).aperture=7.4*10;E(i).radius=33*10;
E(i).indexout=1;E(i).indexcenter=1.5066;

i=i+1;
E(i).type='sphericalSurface';
E(i).center=E(i-1).center+[0.4 0 0]; E(i).axis=[1 0 0];E(i).autoStop=1;
E(i).aperture=7.4*10;E(i).radius=33*10;
E(i).indexout=1;E(i).indexcenter=1.5066;



i=i+1;
E(i).type='sphericalSurface';
E(i).center=E(i-1).center+[(33+5)*10 0 0]; E(i).axis=[-1 0 0];E(i).autoStop=1;
E(i).aperture=5*10;E(i).radius=5*10;
E(i).indexout=1;E(i).indexcenter=1.5066;

i=i+1;
E(i).type='sphericalSurface';
E(i).center=E(i-1).center+[1 0 0]; E(i).axis=[1 0 0];E(i).autoStop=1;
E(i).aperture=5*10;E(i).radius=5*10;
E(i).indexout=1;E(i).indexcenter=1.5066;