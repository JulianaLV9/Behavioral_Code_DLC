function [velocidad,velocidad_ensayos,aceleracion,aceleracion_ensayos,duracion] = velocidad_aceleracion(muneca_x_general,muneca_y_general,tiempo)

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
velocidad_ensayos  = mean(velocidad,1,'omitnan');

%Sacar aceleracion
diff_velocidad       = diff(velocidad);
tiempo               = tiempo(1:end-1);
aceleracion          = diff_velocidad./tiempo; %cm/s2
aceleracion_ensayos  = mean(aceleracion,1,'omitnan');

%Duracion
longitud          = sum(~isnan(muneca_x_general));
duracion          = (longitud * frame_dur)'; 

end