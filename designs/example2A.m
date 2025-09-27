S = SceneAPI();

% Aperture stop in front
S = S.addSurface('circaper','center',[0 0 0],'axis',[1 0 0],'aperture',25);

% Lens element: spherical front and rear
S = S.addSurface('sphericalSurface', ...
    'center',[10 0 0],'axis',[-1 0 0], ...
    'radius',50,'aperture',25, ...
    'indexcenter',1.50,'indexout',1.0);

S = S.addSurface('sphericalSurface', ...
    'center',[12 0 0],'axis',[+1 0 0], ...
    'radius',50,'aperture',25, ...
    'indexcenter',1.50,'indexout',1.0);

% Sensor plane 100 units behind rear surface
S = S.addSensor('rectangular','size',[20 20],'distance',100);

[E, Sensor] = S.build();
