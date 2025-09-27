clear all;clc; close all

pth='designs/example2B';

run([pth '.m']);

%Task='compute spot';
Task='find focus';
%Task='quick';

if strcmpi(Task,'find focus'),
numrays=10; %number of rays per axis
resR=10; % factor of interpolation
rtplot=1; %2D raytracing plot: For fast ray tracing choose numrays<=10
spplot=0;%spot plot: For accurate spot shape simulation choose numrays>30
plot3dr=1;%3D raytracing plot, but very slow
elseif strcmpi(Task,'compute spot'),
numrays=60; %number of rays per axis
resR=20; % factor of interpolation
rtplot=0; %2D raytracing plot: For fast ray tracing choose numrays<=10
spplot=1;%spot plot: For accurate spot shape simulation choose numrays>30
plot3dr=0;%3D raytracing plot, but very slow
elseif strcmpi(Task,'quick'),
numrays=10; %number of rays per axis
resR=1; % factor of interpolation
rtplot=1; %2D raytracing plot: For fast ray tracing choose numrays<=10
spplot=0;%spot plot: For accurate spot shape simulation choose numrays>30
plot3dr=0;%3D raytracing plot, but very slow
end


[E,i_SensPlane]=initializeSurroundingBox(E,Sensor.lastdistance);
[E]=preprocessElements(E);


conditions.B=1;% Total optical power of the target in W (Assumedn to be totally diffusive)
conditions.coeff=0.1;%Atmospheric Attenuation Coeffecient per km
R0_in_m=1000;%3.3*2.54*1e-2;% Range from target to first lens in meters

w=3*pi/180;%Horizontal: += ray is going right
w2=0*pi/180;%vertical: +=ray is going up

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_outermost=7;
R0=R0_in_m*1000;%convert to mm
%[x y z] coordinates of the source
csource=-R0*[sin(pi/2-w2)*cos(w) sin(pi/2-w2)*sin(w) cos(pi/2-w2)];
[ray,yin0]=generateRaysFromDistance(csource ,E(i_outermost),conditions,numrays,1);

clrz='rgbykmc';

% RayM is a stack for all unporcessed rays. It will be initialized to the rays coming from the source
RayM=ray;
cntB=1;
while length(RayM>1)
    %Take the ray at the top of the stack
    rayp=RayM(1,:);
    % Find the next intersection, and the resultant rays
    [rayReflected,rayRefracted,raycmp]=extendRay(E,rayp);
    %Collect all the completed rays
    raycmpM(cntB,:)=raycmp;cntB=cntB+1;
    %Need a threshold condition on the reflected rays, otherwise the code will follow very weak rays resonating between two surfaces
    if length(rayReflected)>1; if rayReflected(7)>0.01;RayM(end+1,:)=rayReflected;end;end;
    if length(rayRefracted)>1; RayM(end+1,:)=rayRefracted;end;
    % Reduce the stack by removing the first ray (which was just processed)
    RayM=RayM(2:end,:);
end




if rtplot
    figure;
    [~,num4]=size(E);
    for i=1:num4
        if strcmpi(E(i).type,'sphericalSurface') || strcmpi(E(i).type,'aspheric') || strcmpi(E(i).type,'circularPlanarSurface')
            xx0=E(i).cc3d(:,:,1);zz0=E(i).cc3d(:,:,3);
            dnp=E(i).dnp;
            xx=xx0(~dnp);zz=zz0(~dnp);
            if strcmpi(E(i).type,'sphericalSurface')
            scatter(xx(:),zz(:));hold on;
          else
            scatter(xx(:),zz(:),'+');hold on;
            end
        end
    end
    [num5,~]=size(raycmpM);
    for i=1:num5
        plot(raycmpM(i,[1 14]),raycmpM(i,[3 16]),clrz(raycmpM(i,9)),'linewidth',5*raycmpM(i,7));
    end
    %debugging
    %{
         cnd=raycmpM(:,1);
        scatter3(raycmpM(:,1),raycmpM(:,2),raycmpM(:,3),'+');

        for i=1:50:num5
              text(raycmpM(:,1),raycmpM(:,2),raycmpM(:,3),num2str(raycmpM(:,8)));
        end
%}
% end debug
    XposofSensor=E(i_SensPlane).center(1);
    if strcmpi(Sensor.Type,'circular')
        plot([XposofSensor XposofSensor],[-Sensor.radius Sensor.radius],'k')
    elseif strcmpi(Sensor.Type,'rectangular')
        %2D drawing, draw the sensor as a line , showing only its extension in the verical axis
        plot([XposofSensor XposofSensor],[-Sensor.SensLength2/2 Sensor.SensLength2/2],'k')
    end
    axis equal;
    title('Ray Tracing'),xlabel('x'),ylabel('z');
    nn0=num2str(floor(time*1e3));


end


raySens=[];raySensPlane=[];
[a1,~]=size(raycmpM);
%Collect the completed rays falling on the sensor plane (not necessaily the sensor)
for j=1:a1
    if (raycmpM(j,14)==E(i_SensPlane).center(1))
          raySensPlane(end+1,:)=raycmpM(j,:);
    end
end

if strcmpi(Task,'find focus')
         [BFL_axial,CLC,Points,Pc,PAcircle]=findBFLandCLC(raySensPlane,E);
         BFL_axial
         CLC
         %scatter3(Points(:,1),Points(:,2),Points(:,3),'b');
         scatter3(Pc(1),Pc(2),Pc(3),'+b');
         scatter3(PAcircle(:,1),PAcircle(:,2),PAcircle(:,3),'b');
		 nn0=num2str(round(time));
		 hold off
		 a=strcat('images\',nn0,'_',num2str(R0_in_m),'m_',num2str(floor(w*180/pi)),'_',num2str(floor(w2*180/pi)),'.png');
		 saveas(gcf,a);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
[raySensPlaneInterp]=interpolateRays(raySensPlane,numrays,resR);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

[a7,~]=size(raySensPlaneInterp);


cnd1=(raySensPlaneInterp(:,14)==E(4).center(1)); %unneeded repitition (TODO:remove)
if strcmpi(Sensor.Type,'circular')
    cnd2=(sqrt(raySensPlaneInterp(:,15).^2+raySensPlaneInterp(:,16).^2)<Sensor.radius);
elseif strcmpi(Sensor.Type,'rectangular')
    cnd2=((abs(raySensPlaneInterp(:,15))<Sensor.SensLength1/2 ).* (abs(raySensPlaneInterp(:,16))<Sensor.SensLength2/2 ));
end
cnd=logical(cnd1.*cnd2);

raySens=raySensPlaneInterp(cnd,:);
%{
figure;rectangle('position', [-SensLengthY/2 -SensLengthZ/2 SensLengthY SensLengthZ],'facecolor','g'); hold on;
scatter(raySensPlane(:,14),raySensPlane(:,15)),
title('Sensor Plane: Intersection of rays (Original) '), xlabel('y'),ylabel('z');hold off;
%}
%{
figure;rectangle('position', [-SensLengthY/2 -SensLengthZ/2 SensLengthY SensLengthZ],'facecolor','g');hold on;
scatter(raySensPlaneInterp(:,14),raySensPlaneInterp(:,15)),
title('Sensor Plane: Intersection of rays (Interpolated) '), xlabel('y'),ylabel('z');hold off;
%}

%%%%%%%%%%%%%%%%  BINNING of Rays into pixels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dy0=yin0(2)-yin0(1);
pixelSize=0.05;%image resolution
if strcmpi(Sensor.Type,'circular')
    SensorAverageRadius=Sensor.radius;
elseif strcmpi(Sensor.Type,'rectangular')
    SensorAverageRadius=sqrt(Sensor.SensLength1/2*Sensor.SensLength2/2 );
end
numpixels=ceil(((SensorAverageRadius)+dy0)/pixelSize)*2+1;
mid=round(numpixels/2-1);
xt=((1:numpixels)-mid)*pixelSize;
IM=zeros(numpixels,numpixels);IMdots=IM;bx=IM;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[a1,~]=size(raySens);
for j=1:a1
    in0x=round(mid+(raySens(j,15)/pixelSize));in0y=round(mid+(raySens(j,16)/pixelSize));
    IMdots(in0x,in0y)=IMdots(in0x,in0y)+raySens(j,7);
end

bxhw=floor(0.5*dy0/(resR*pixelSize));% box half width
bx(mid-bxhw:mid+bxhw,mid-bxhw:mid+bxhw)=ones(2*bxhw+1,2*bxhw+1);
bx=bx/sum(sum(bx));
IM=conv2(IMdots,bx,'same');


[xx,yy]=meshgrid(xt,xt');


if spplot %spot plot
      figure(14);
      imagesc(xt,xt,IM');hold on;axis equal
      if strcmpi(Sensor.Type,'circular')
            circleplot([0 0],Sensor.radius);
            xlim([-Sensor.radius Sensor.radius]);ylim([-Sensor.radius Sensor.radius]);
      elseif strcmpi(Sensor.Type,'rectangular')
            rectangle('position', [-Sensor.SensLength1/2 -Sensor.SensLength2/2 Sensor.SensLength1 Sensor.SensLength2]);
            xlim([-Sensor.SensLength1/2 Sensor.SensLength1/2]);ylim([-Sensor.SensLength2/2 Sensor.SensLength2/2]);
      end
      xlabel('y (mm)');ylabel('z (mm)');hold off;

      %title(strcat('measured vert=',num2str(thvertical),', measured horiz=',num2str(thhorizontal),' , Power=',num2str(Pwrtot)));
      nn0=num2str(floor(time*1e3));
      a=strcat('images\',nn0,'_',num2str(R0_in_m),'m_',num2str(floor(w*180/pi)),'_',num2str(floor(w2*180/pi)),'.png');
      saveas(gcf,a);

end


if plot3dr
    drawelements=1;Display3dLayout2(raycmpM,E,drawelements);
         if strcmpi(Task,'find focus'), scatter3(Pc(1),Pc(2),Pc(3),'+b');scatter3(PAcircle(:,1),PAcircle(:,2),PAcircle(:,3),'b');end
end








