function [E,i_SensPlane]=initializeSurroundingBox(E,SensorXDisplacementFromLastElement)

[~,last] = size(E);
apertures=[];
for j=1:last
    apertures=[apertures;E(j).aperture];
end

L=100*max(apertures);

i=1;
E(i).type='plane';E(i).axis=[0 1 0];E(i).isBoundary=1;E(i).center=[0 -L 0];
i=2;
E(i).type='plane';E(i).axis=[0 1 0];E(i).isBoundary=1;E(i).center=[0 +L 0];
i=3;
E(i).type='plane';E(i).axis=[1 0 0];E(i).isBoundary=1;E(i).center=[-L 0 0];


%Element #+4 is always the sensor plane (TODO: Arbitrary Sensor plane)
i=4;
E(i).type='plane';E(i).axis=[1 0 0];E(i).isBoundary=1;E(i).center=E(last).center+[SensorXDisplacementFromLastElement 0 0];
i_SensPlane=i;



i=5;
E(i).type='plane';E(i).axis=[0 0 1];E(i).isBoundary=1;E(i).center=[0 0 L];
i=6;
E(i).type='plane';E(i).axis=[0 0 1];E(i).isBoundary=1;E(i).center=[0 0 -L];
end
