%MODELO DE CIGÜEÑAL PARA ESTUDIO DE BALANCEO.
%NOTAS VARIAS--------------------------------------------------------------
% + Primero definir la ecuación, despues aplicar el rango en donde debe
%   estar definida.

% + convertir a double para las gráficas. pasar de simbolico a numérico.

%--------------------------------------------------------------------------
clear;  %limpiar variables del workspace
close all;  
clc;        %limpiar pantalla del command windows


%PARAMETROS DE ENTRADA-----------------------------------------------------
R = 24.95;
L = 103.5;
n = 8000;
e = 2;
diam_p = 63;
h = 70.67;
d = 2.45;
alpha_deg = 178;

Me = 2930; %masa de las tortas del cigüeñal en gramos.
Mb = 157.7; %masa de la biela
Mp = 205.4; %masa del piston con perno, aros y trabas.

%--------------------------------------------------------------------------

%PARÁMETRO VARIABLE Y OTROS------------------------------------------------
syms theta

alpha = alpha_deg*pi/180;


%--------------------------------------------------------------------------

%ECUACIONES----------------------------------------------------------------
%velocidad angunar en radianes por segundo
w = 2*pi*n/60;
%Planteo de ecuaciones base para derivar posteriormente.
%piston posición
Xp = R*(1-cos(theta))+L*(1- sqrt(1-((R*sin(theta)-e).^2)/L.^2));
%biela posición
Xb = h*sqrt(1-((R*sin(theta)-e).^2)/L.^2);
Yb = e + h*(R*sin(theta)-e)/L;
%excentrico
Xe = L + R - d*cos(theta+alpha);
Ye = d*sin(theta+alpha);


theta = 0:2*pi/100:2*pi;
%conversion a double y derivadas.\|/-\|/-\|/-\|/-\|/
%                       -PISTON-
%piston posición
PXp = double(subs(Xp));
%piston velocidad
d1Xp = diff(Xp);
Pd1Xp=w*double(subs(d1Xp))/1000; %el /1000 es para convertir a metro las unidades
                                %luego al multiplicar por w me queda en m/s
%piston aceleracion
d2Xp = diff(Xp,2);
Pd2Xp = (w.^2)*double(subs(d2Xp))/1000;
%                           -BIELA-
% %biela posición
PXb=double(subs(Xb))+ PXp;
PYb=double(subs(Yb));
%biela velocidad
d1Xb=diff(Xb);
Pd1Xb = w*double(subs(d1Xb))/1000 + Pd1Xp;
d1Yb=diff(Yb);
Pd1Yb = w*double(subs(d1Yb))/1000;
%biela aceleración
d2Xb=diff(Xb,2);
Pd2Xb = (w.^2)*double(subs(d2Xb))/1000 + Pd2Xp;
d2Yb=diff(Yb,2);
Pd2Yb = (w.^2)*double(subs(d2Yb))/1000;

%manivela (masas del cigüeñal)
%Excentrico posición[mm]
PXe=double(subs(Xe));
PYe=double(subs(Ye));
%Excentrico velocidad
d1Xe = diff(Xe);
d1Ye = diff(Ye);
Pd1Xe = w*double(subs(d1Xe))/1000;
Pd1Ye = w*double(subs(d1Ye))/1000;
%Excentrico aceleracion
d2Xe = diff(Xe,2);
d2Ye = diff(Ye,2);
Pd2Xe = (w.^2)*double(subs(d2Xe))/1000;
Pd2Ye = (w.^2)*double(subs(d2Ye))/1000;

%--------------------------------------------------------------------------

%GRÁFICAS------------------------------------------------------------------
% Referencias_:
% 1 : Posición del piston
% 2 : Velocidad del piston
% 3 : Aceleración del piston
% 4 : Posición del CM de la biela
% 5 : Velocidad del CM de la biela
% 6 : Aceleración del CM de la biela
% 7 : Posición del excentrico
% 8 : Velocidad del excentrico
% 9 : Aceleración del excentrico
%10 : Fuerzas en los vínculos

Grafica=10;
switch(Grafica)
    case 1 %grafica de la posición del piston [mm]
        plot(theta*180/pi,PXp,'r')
        grid on
        grid minor
        title('Posición del piston')
        xlabel('Radianes')
        ylabel('milimetros desde el PMS')
        
    case 2 %grafica de la velocidad del piston [m/s]
        plot(theta*180/pi,Pd1Xp,'b')
        grid on
        grid minor
        title('Velocidad del piston')
        xlabel('Radianes')
        ylabel('m/s')
    case 3 %grafica de la aceleracion del piston [m/s^2]
        plot(theta*180/pi,Pd2Xp,'c')
        grid on
        grid minor
        title('Aceleración del piston')
        xlabel('Radianes')
        ylabel('m/s^{2}')
    case 4 %grafica de la posición del cm de la biela [mm]
        plot(theta*180/pi,PXb,'r--') %grafica del movimiento en el eje X
        grid on
        grid minor
        title('Posición del CM de la biela')
        xlabel('Radianes')
        ylabel('milimetros desde el PMS')
    case 5 %grafica de la velocidad del cm de la biela [m/s]
        hold on;
        plot(theta*180/pi,Pd1Xb,'b--')
        plot(theta*180/pi,Pd1Yb,'m:')
        grid on
        grid minor
        title('Velocidad del CM de la biela')
        xlabel('Radianes')
        ylabel('m/s')
        legend('respecto a X','respecto a Y');
    case 6 %grafica de la aceleración del cm de la biela [m/s^2]
        hold on;
        plot(theta*180/pi,Pd2Xb,'c--');
        plot(theta*180/pi,Pd2Yb,'m:');
        grid on
        grid minor
        title('Aceleración del CM de la biela')
        xlabel('Radianes')
        ylabel('m/s^{2}')
        legend('respecto a X','respecto a Y');
    case 7 %grafica de la posición del cm de la masa excentrica
        plot(theta*180/pi,PXe,'black') 
        grid on
        grid minor
        title('Posición del CM de la masa excentrica')
        xlabel('Radianes')
        ylabel('milimetros desde el PMS')
    case 8 %grafica de la velocidad del cm de la masa excentrica
        plot(theta*180/pi,Pd1Xe,'g--') 
        grid on
        grid minor
        title('Velocidad del CM de la masa excentrica')
        xlabel('Radianes')
        ylabel('m/s')
    case 9 %grafica de la aceleracion del cm de la masa excentrica
        plot(theta*180/pi,Pd2Xe,'g') 
        grid on
        grid minor
        title('Aceleración del CM de la masa excentrica')
        xlabel('Radianes')
        ylabel('m/s^{2}')
    case 10 %grafica de los esfuerzos en los vínculos.
        ReacX = Me*Pd2Xe/1000 + Mp*Pd2Xp/1000 + Mb*Pd2Xb/1000;
        %ReacY = Me*Pd2Ye/1000 + Mb*Pd2Yb/1000;
        hold on
        plot(theta*180/pi,ReacX,'black');
        plot(theta*180/pi,Me*Pd2Xe/1000,'b');
        plot(theta*180/pi,Mp*Pd2Xp/1000,'r');
        plot(theta*180/pi,Mb*Pd2Xb/1000,'m');
        grid on
        grid minor
        title('Esfuerzo sobre los rodamientos');
        xlabel('Grados');
        ylabel('Newton');
        legend('Resultante','Excentrico','Piston','Biela');
end

%--------------------------------------------------------------------------
