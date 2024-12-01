function [velocidad] = velocidad(muneca_x_general,muneca_y_general,tiempo)

%Sacar la velocidad instantanea entre cada uno de los puntos de la
%trayectoria
un_cm = 48.8; %pixel
frame_dur = 16.67 / 1000;

%Sacar la distancia primero
dx        = diff(muneca_x_general);
dy        = diff(muneca_y_general);
distancia = sqrt(dx.^2 + dy.^2); %pixeles

%Sacar velocidad
tiempo             = diff(tiempo)'; %s
velocidad_px       = distancia ./tiempo; %pixeles/s
velocidad          = velocidad_px/un_cm; %cm/s

end