S = SceneAPI();
%This file is where you configure the scene setup
% For mini documentation, do: help SceneAPI

% For a spherical surface, the axis will be the direction where the positive part of the lens surface (convex part) is pointing at.
% I treat the spherical surface as a spherical section terminated by plane, which I will call the 'end plane'
%aperture: is the diameter of the circle at the intersection of the 'end plane' and the spherical surface
%center: is the point at the center of the circle at the intersection of the 'end plane' and the spherical surface
%radius : Radius of curvature of the spherical surface
% indexcenter: refractive index of the side of the spherical surface closest to the center of the sphere defining the surface
% indexout : refractive index of the other side of the spherical surface
% autoStop: by default is true, it places a stop on each surface. If you do not want it, explicitly set it true.

% Lens 1 (two faces)
S = S.addSurface('sphericalSurface', 'center',[16 0 0],  'axis',[-1 0 0], 'radius',25*10, 'aperture',12.5*10,'indexcenter',1.50);
S = S.addSurface('sphericalSurface', 'center',[17 0 0],  'axis',[+1 0 0], 'radius',25*10, 'aperture',12.5*10,'indexcenter',1.50);


% Lens 2 (two faces)
S = S.addSurface('sphericalSurface', ...
    'center',[317   0 0], 'axis',[-1 0 0], 'radius',33*10, 'aperture',7.4*10, ...
    'indexcenter',1.5066, 'indexout',1.00, 'autoStop',true);
S = S.addSurface('sphericalSurface', ...
    'center',[317.4 0 0], 'axis',[+1 0 0], 'radius',33*10, 'aperture',7.4*10, ...
    'indexcenter',1.5066, 'indexout',1.00, 'autoStop',true);

% Small lens (two faces)
S = S.addSurface('sphericalSurface', ...
    'center',[697   0 0], 'axis',[-1 0 0], 'radius',5*10,  'aperture',5.0*10, ...
    'indexcenter',1.5066, 'indexout',1.00, 'autoStop',true);
S = S.addSurface('sphericalSurface', ...
    'center',[698   0 0], 'axis',[+1 0 0], 'radius',5*10,  'aperture',5.0*10, ...
    'indexcenter',1.5066, 'indexout',1.00, 'autoStop',true);

% Sensor (rectangular 10x12 mm), 50 mm beyond last surface, same axis
% for the time being, the sensor is always placed at [x 0 0], with its axis=[-1 0 0]
% i.e. the sensor is always a plane, perpendicular to the x axis (long axis), centered around it.
S = S.addSensor('rectangular','size',[10 12],'distance',50);

[E, Sensor] = S.build();




