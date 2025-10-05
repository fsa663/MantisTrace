function []=circleplot(c,r)
ang=0:5:360;
x=c(1)+cos(ang*pi/180)*r;
y=c(2)+sin(ang*pi/180)*r;
hold on, plot(x,y,'k');
end