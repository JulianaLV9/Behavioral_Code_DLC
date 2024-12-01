function [trayec_500,trayec_1000,trayec_1500,cont_figura,tabla_cinematica] = trayectorias(correcto_500,correcto_1000,correcto_1500,dlc_matrix,cont_figura)
%Pendientes: Todavia puedo suavizar un poco esas trayectorias
%frame_go_cue no lo ocupo aquí al menos que quiera plotear la velocidad
%donde en planeación esta en 0, pero podría ser 30; 60; 90 frames
%respectivamente
%NOTAS:
%122 pixeles = 2.5 cm
% 50 pixeles = 1.02 cm
%Barra-bebedero = 3 cm (146 px)

cont_figura = cont_figura +1;

%% Delimitar donde esta la barra a partir del bebedero
posicion_bebedero_x = mean(dlc_matrix(:,2),'omitnan');
posicion_bebedero_y = mean(dlc_matrix(:,3),'omitnan');
posicion_bebedero   = [posicion_bebedero_x posicion_bebedero_y];
posicion_barra_x    = posicion_bebedero_x - 174;
posicion_barra_y    = posicion_bebedero_y + 174;
posicion_barra      = [posicion_barra_x posicion_barra_y];

%% TODA LA TRAYECTORIA

% EJECUCION 500 ms 
frames_go_cue      = 0; %Cambiar a 30 si es el caso
frames_retorno     = 8;
frame_dur          = 16.67 / 1000;
go_cue             = correcto_500.Go_Cue_essay;
%go_cue            = correcto_500.Go_Cue_essay - frames_go_cue; %Aqui estoy restando 30 frames (posibilidad de 500 ms que dura el estimulo) 
correcto           = correcto_500.Recompensa_essay + frames_retorno;  %Aqui agregue 16 frames equivalente a 300 ms posterior a que toco el bebedero
ventanas_ejecucion = [go_cue correcto];
frames_totales     = ventanas_ejecucion(:,2)- ventanas_ejecucion(:,1);

%Tiempos de reaccion
tiempo_reaccion_500 = (correcto_500.Bar_essay - correcto_500.Go_Cue_essay)*frame_dur;

%Definir la línea temporal (Alineacion con la senal Go)
tiempo_inicial     = frame_dur * 30;
tiempo_final       = frame_dur * (max(frames_totales) - 30);
tiempo_500         = -tiempo_inicial:frame_dur:tiempo_final;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_general_500   = NaN(max(frames_totales)+1,length(ventanas_ejecucion));
muneca_y_general_500   = NaN(max(frames_totales)+1,length(ventanas_ejecucion));

for ii = 1:length(ventanas_ejecucion)
    inicio = ventanas_ejecucion(ii,1);
    final  = ventanas_ejecucion(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix      = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    muneca_x    = matrix(:,17); %Extraer solo la trayectoria de la muneca para reconstruir la trayectoria tiempo a tiempo
    muneca_y    = matrix(:,18);
    
    muneca_x_general_500(1:length(muneca_x), ii) = muneca_x; %POSIBLEMENTE ESTE ME INTERESE GUARDAR
    muneca_y_general_500(1:length(muneca_y), ii) = muneca_y;
 
end 

%Obtener la velocidad 
[velocidad_500] = velocidad(muneca_x_general_500(frames_go_cue+1:end,:),muneca_y_general_500(frames_go_cue+1:end,:),tiempo_500(frames_go_cue+1:end));

%Refinar la ventana y seleccionar el primer intento a partir de la velocidad
[muneca_x_out,muneca_y_out] = kernel(velocidad_500,muneca_x_general_500,muneca_y_general_500,cont_figura);

%Sacar velocidad y aceleracion
[velocidad_500_out,~,aceleracion_500_out,~,duracion_500] = velocidad_aceleracion(muneca_x_out,muneca_y_out,tiempo_500);

%Sacar outliers respecto a la velocidad 
[velocidad_500_out,aceleracion_500_out,indices_muneca_x_500,indices_muneca_y_500] = interquartil(velocidad_500_out,aceleracion_500_out,muneca_x_out,muneca_y_out);

%Promedios out
mean_velocidad_500   = mean(velocidad_500_out,1,'omitnan');
mean_aceleracion_500 = mean(aceleracion_500_out,1,'omitnan');

promedio_muneca_x_500   = mean(indices_muneca_x_500,2,'omitnan');
promedio_muneca_y_500   = mean(indices_muneca_y_500,2,'omitnan');

%Generar figura representativa
name          = 'Trajectory with 500 ms of preparation';
[cont_figura] = generador_trayectoria(indices_muneca_x_500,indices_muneca_y_500,promedio_muneca_x_500,promedio_muneca_y_500,posicion_bebedero,posicion_barra,cont_figura,name);

%Matriz de trayectorias (Intercalar las columnas corresponde a la taryectoria de la muneca)
trayec_500 = table(indices_muneca_x_500,indices_muneca_y_500);

% EJECUCION 1000 ms
frames_go_cue      = 0;
frames_retorno     = 8;
go_cue             = correcto_1000.Go_Cue_essay; %Aqui estoy restando 60 frames (posibilidad de 1000 ms que dura el estimulo) 
correcto           = correcto_1000.Recompensa_essay + frames_retorno;  %Aqui agregue 8 frames equivalente a 300 ms posterior a que toco el bebedero
ventanas_ejecucion = [go_cue correcto];
frames_totales     = ventanas_ejecucion(:,2)- ventanas_ejecucion(:,1);

%Tiempos de reaccion
tiempo_reaccion_1000 = (correcto_1000.Bar_essay - correcto_1000.Go_Cue_essay)*frame_dur;

%Definir la línea temporal (Alineacion con la senal Go)
tiempo_inicial     = frame_dur * frames_go_cue;
tiempo_final       = frame_dur * (max(frames_totales) - frames_go_cue);
tiempo_1000         = -tiempo_inicial:frame_dur:tiempo_final;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_general_1000 = NaN(max(frames_totales)+1,length(ventanas_ejecucion));
muneca_y_general_1000 = NaN(max(frames_totales)+1,length(ventanas_ejecucion));

for ii = 1:length(ventanas_ejecucion)
    inicio = ventanas_ejecucion(ii,1);
    final  = ventanas_ejecucion(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    muneca_x   = matrix(:,17); %Extraer solo la trayectoria de la muneca para reconstruir la trayectoria tiempo a tiempo
    muneca_y   = matrix(:,18);
    
    muneca_x_general_1000(1:length(muneca_x), ii) = muneca_x; %POSIBLEMENTE ESTE ME INTERESE GUARDAR
    muneca_y_general_1000(1:length(muneca_y), ii) = muneca_y;
 
end 

%Obtener la velocidad 
[velocidad_1000] = velocidad(muneca_x_general_1000(frames_go_cue+1:end,:),muneca_y_general_1000(frames_go_cue+1:end,:),tiempo_1000(frames_go_cue+1:end));

%Refinar la ventana y seleccionar el primer intento a partir de la velocidad
[muneca_x_out,muneca_y_out] = kernel(velocidad_1000,muneca_x_general_1000,muneca_y_general_1000,cont_figura);

%Sacar velocidad y aceleracion
[velocidad_1000_out,~,aceleracion_1000_out,~,duracion_1000] = velocidad_aceleracion(muneca_x_out,muneca_y_out,tiempo_1000);

%Sacar outliers respecto a la velocidad 
[velocidad_1000_out,aceleracion_1000_out,indices_muneca_x_1000,indices_muneca_y_1000] = interquartil(velocidad_1000_out,aceleracion_1000_out,muneca_x_out,muneca_y_out);

%Promedios out
mean_velocidad_1000   = mean(velocidad_1000_out,1,'omitnan');
mean_aceleracion_1000 = mean(aceleracion_1000_out,1,'omitnan');

promedio_muneca_x_1000   = mean(indices_muneca_x_1000,2,'omitnan');
promedio_muneca_y_1000   = mean(indices_muneca_y_1000,2,'omitnan');

%Generar figura representativa
name          = 'Trajectory with 1000 ms of preparation';
[cont_figura] = generador_trayectoria(indices_muneca_x_1000,indices_muneca_y_1000,promedio_muneca_x_1000,promedio_muneca_y_1000,posicion_bebedero,posicion_barra,cont_figura,name);

%Matriz de trayectorias (Intercalar las columnas corresponde a la taryectoria de la muneca)
trayec_1000 = table(indices_muneca_x_1000,indices_muneca_y_1000);

% EJECUCION 1500 ms
frames_go_cue      = 0;
frames_retorno     = 8;
go_cue             = correcto_1500.Go_Cue_essay; %Aqui estoy restando 90 frames (posibilidad de 1500 ms que dura el estimulo) 
correcto           = correcto_1500.Recompensa_essay + frames_retorno;  %Aqui agregue 8 frames equivalente a 300 ms posterior a que toco el bebedero
ventanas_ejecucion = [go_cue correcto];
frames_totales     = ventanas_ejecucion(:,2)- ventanas_ejecucion(:,1);

%Tiempos de reaccion
tiempo_reaccion_1500 = (correcto_1500.Bar_essay - correcto_1500.Go_Cue_essay)*frame_dur;

%Definir la línea temporal (Alineacion con la senal Go)
tiempo_inicial     = frame_dur * frames_go_cue;
tiempo_final       = frame_dur * (max(frames_totales) - frames_go_cue);
tiempo_1500         = -tiempo_inicial:frame_dur:tiempo_final;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_general_1500 = NaN(max(frames_totales)+1,length(ventanas_ejecucion));
muneca_y_general_1500 = NaN(max(frames_totales)+1,length(ventanas_ejecucion));

for ii = 1:length(ventanas_ejecucion)
    inicio = ventanas_ejecucion(ii,1);
    final  = ventanas_ejecucion(ii,2);

        %Extraer el fragmento de dlc_matrix
    matrix      = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    muneca_x    = matrix(:,17); %Extraer solo la trayectoria de la muneca para reconstruir la trayectoria tiempo a tiempo
    muneca_y    = matrix(:,18);
    
    muneca_x_general_1500(1:length(muneca_x), ii) = muneca_x; %POSIBLEMENTE ESTE ME INTERESE GUARDAR
    muneca_y_general_1500(1:length(muneca_y), ii) = muneca_y;
 
end 

%Obtener la velocidad 
[velocidad_1500] = velocidad(muneca_x_general_1500(frames_go_cue+1:end,:),muneca_y_general_1500(frames_go_cue+1:end,:),tiempo_1500(frames_go_cue+1:end));

%Refinar la ventana y seleccionar el primer intento a partir de la velocidad
[muneca_x_out,muneca_y_out] = kernel(velocidad_1500,muneca_x_general_1500,muneca_y_general_1500,cont_figura);

%Sacar velocidad y aceleracion
[velocidad_1500_out,~,aceleracion_1500_out,~,duracion_1500] = velocidad_aceleracion(muneca_x_out,muneca_y_out,tiempo_1500);

%Sacar outliers respecto a la velocidad 
[velocidad_1500_out,aceleracion_1500_out,indices_muneca_x_1500,indices_muneca_y_1500] = interquartil(velocidad_1500_out,aceleracion_1500_out,muneca_x_out,muneca_y_out);

%Promedios out
mean_velocidad_1500   = mean(velocidad_1500_out,1,'omitnan');
mean_aceleracion_1500 = mean(aceleracion_1500_out,1,'omitnan');

promedio_muneca_x_1500   = mean(indices_muneca_x_1500,2,'omitnan');
promedio_muneca_y_1500   = mean(indices_muneca_y_1500,2,'omitnan');

%Generar figura representativa
name          = 'Trajectory with 1500 ms of preparation';
[cont_figura] = generador_trayectoria(indices_muneca_x_1500,indices_muneca_y_1500,promedio_muneca_x_1500,promedio_muneca_y_1500,posicion_bebedero,posicion_barra,cont_figura,name);

%Matriz de trayectorias (Intercalar las columnas corresponde a la trayectoria de la muneca)
trayec_1500 = table(indices_muneca_x_1500,indices_muneca_y_1500);

%% ALCANCE %% Codigo trayectoria_alcance lo deje pendiente debido a que no tiene resolucion epacial de lo cual debo quitar el generador de trayectorias

%Crear la tabla con la información
[tabla_cinematica]          = cinematica_rt(correcto_500,correcto_1000,correcto_1500,duracion_500,tiempo_reaccion_500,mean_velocidad_500',mean_aceleracion_500',duracion_1000,tiempo_reaccion_1000,mean_velocidad_1000',mean_aceleracion_1000',duracion_1500,tiempo_reaccion_1500,mean_velocidad_1500',mean_aceleracion_1500');
%[tabla_cinematica_alcance] = cinematica(correcto_500,correcto_1000,correcto_1500,duracion_alcance_500,velocidad_500_alcance_out,aceleracion_500_alcance_out,duracion_alcance_out_1000,velocidad_1000_alcance_out,aceleracion_1000_alcance_out,duracion_alcance_out_1500,velocidad_1500_alcance_out,aceleracion_1500_alcance_out);
%[tabla_cinematica_retorno] = cinematica(correcto_500,correcto_1000,correcto_1500,duracion_retorno_500,velocidad_500_retorno_out,aceleracion_500_retorno_out,duracion_retorno_1000,velocidad_1000_retorno_out,aceleracion_1000_retorno_out,duracion_retorno_1500,velocidad_1500_retorno_out,aceleracion_1500_retorno_out);

end 