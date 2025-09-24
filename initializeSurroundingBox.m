function [E]=initializeSurroundingBox(E,SensorXDisplacementFromLastElement)

[~,k] = size(E);
apertures=[];
for j=1:k
    apertures=[apertures;E(j).aperture];
end

L=10*max(apertures);

i=1;
E(i).type='plane';E(i).axis=[0 1 0];E(i).isBoundary=1;E(i).center=[0 -L 0];
i=2;
E(i).type='plane';E(i).axis=[0 1 0];E(i).isBoundary=1;E(i).center=[0 +L 0];
i=3;
E(i).type='plane';E(i).axis=[1 0 0];E(i).isBoundary=1;E(i).center=[-L 0 0];
%Element #4 is always the sensor plane (TODO: Arbitrary Sensor plane)
i=4;
E(i).type='plane';E(i).axis=[1 0 0];E(i).isBoundary=1;E(4).center=E(k).center+[SensorXDisplacementFromLastElement 0 0];

i=5;
E(i).type='plane';E(i).axis=[0 0 1];E(i).isBoundary=1;E(i).center=[0 0 L];
i=6;
E(i).type='plane';E(i).axis=[0 0 1];E(i).isBoundary=1;E(i).center=[0 0 -L];
end
