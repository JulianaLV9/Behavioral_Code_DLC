% ALCANCE Y RETORNO 1500 ms 
frames_go_cue      = 0; %Cambiar a 30 si es el caso
frames_retorno     = 0;
frame_dur          = 16.67 / 1500;
go_cue             = correcto_1500.Go_Cue_essay;
%go_cue            = correcto_1500.Go_Cue_essay - frames_go_cue;%Aqui estoy restando 30 frames (posibilidad de 1500 ms que dura el estimulo) 
correcto           = correcto_1500.Recompensa_essay + frames_retorno;  %Aqui agregue 16 frames equivalente a 300 ms posterior a que toco el bebedero
ventanas_alcance = [go_cue correcto];
frames_totales     = ventanas_alcance(:,2)- ventanas_alcance(:,1);

%Tiempos de reaccion
tiempo_reaccion_1500 = (correcto_1500.Bar_essay - correcto_1500.Go_Cue_essay)*frame_dur;

%Definir la línea temporal (Alineacion con la senal Go)
tiempo_inicial     = frame_dur * 30;
tiempo_final       = frame_dur * (max(frames_totales));
tiempo_1500         = 0:frame_dur:tiempo_final;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_general_1500   = NaN(max(frames_totales)+1,length(ventanas_alcance));
muneca_y_general_1500   = NaN(max(frames_totales)+1,length(ventanas_alcance));

for ii = 1:length(ventanas_alcance)
    inicio = ventanas_alcance(ii,1);
    final  = ventanas_alcance(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix      = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    muneca_x    = matrix(:,17); %Extraer solo la trayectoria de la muneca para reconstruir la trayectoria tiempo a tiempo
    muneca_y    = matrix(:,18);
    
    muneca_x_general_1500(1:length(muneca_x), ii) = muneca_x; %POSIBLEMENTE ESTE ME INTERESE GUARDAR
    muneca_y_general_1500(1:length(muneca_y), ii) = muneca_y;
 
end 

%Sacar punto maximo
[n_filas, n_columnas] = size(muneca_x_general_1500);
muneca_x_alcance_1500 = NaN(n_filas, n_columnas);  
muneca_y_alcance_1500 = NaN(n_filas, n_columnas); 
muneca_x_retorno_1500 = NaN(n_filas, n_columnas);  
muneca_y_retorno_1500 = NaN(n_filas, n_columnas); 


for ii = 1:n_columnas
    ensayo_x                           = muneca_x_general_1500(:,ii);
    ensayo_y                           = muneca_y_general_1500(:,ii);
    [~, max_idx]                       = max(ensayo_x);  
    muneca_x_alcance_1500(1:max_idx,ii) = ensayo_x(1:max_idx);  
    muneca_y_alcance_1500(1:max_idx,ii) = ensayo_y(1:max_idx);  
    muneca_x_retorno_1500(1:(n_filas-max_idx+1),ii) = ensayo_x(max_idx:end);  
    muneca_y_retorno_1500(1:(n_filas-max_idx+1),ii) = ensayo_y(max_idx:end);  
end


%Obtener la velocidad 
[velocidad_alcance_1500] = velocidad(muneca_x_alcance_1500(frames_go_cue+1:end,:),muneca_y_alcance_1500(frames_go_cue+1:end,:),tiempo_1500);
[velocidad_retorno_1500] = velocidad(muneca_x_retorno_1500(frames_go_cue+1:end,:),muneca_y_retorno_1500(frames_go_cue+1:end,:),tiempo_1500);

%Refinar la ventana y seleccionar el primer intento a partir de la velocidad
[muneca_x_alcance_out,muneca_y_alcance_out] = kernel(velocidad_alcance_1500,muneca_x_alcance_1500,muneca_y_alcance_1500,cont_figura);
[muneca_x_retorno_out,muneca_y_retorno_out] = kernel(velocidad_retorno_1500,muneca_x_retorno_1500,muneca_y_retorno_1500,cont_figura);

%Sacar velocidad y aceleracion
[velocidad_1500_alcance_out,~,aceleracion_1500_alcance_out,~,duracion_alcance_1500] = velocidad_aceleracion(muneca_x_alcance_out,muneca_y_alcance_out,tiempo_1500);
[velocidad_1500_retorno_out,~,aceleracion_1500_retorno_out,~,duracion_retorno_1500] = velocidad_aceleracion(muneca_x_retorno_out,muneca_y_retorno_out,tiempo_1500);

%Sacar outliers respecto a la velocidad 
[velocidad_1500_alcance_out,aceleracion_1500_alcance_out,indices_muneca_x_alcance_1500,indices_muneca_y_alcance_1500] = interquartil(velocidad_1500_alcance_out,aceleracion_1500_alcance_out,muneca_x_alcance_out,muneca_y_alcance_out);
[velocidad_1500_retorno_out,aceleracion_1500_retorno_out,indices_muneca_x_retorno_1500,indices_muneca_y_retorno_1500] = interquartil(velocidad_1500_retorno_out,aceleracion_1500_retorno_out,muneca_x_retorno_out,muneca_y_retorno_out);

%Promedios out
mean_velocidad_alcance_1500   = mean(velocidad_1500_alcance_out,1,'omitnan');
mean_aceleracion_alcance_1500 = mean(aceleracion_1500_alcance_out,1,'omitnan');
mean_velocidad_retorno_1500   = mean(velocidad_1500_retorno_out,1,'omitnan');
mean_aceleracion_retorno_1500 = mean(aceleracion_1500_retorno_out,1,'omitnan');

promedio_muneca_x_alcance_1500   = mean(indices_muneca_x_alcance_1500,2,'omitnan');
promedio_muneca_y_alcance_1500   = mean(indices_muneca_y_alcance_1500,2,'omitnan');
promedio_muneca_x_retorno_1500   = mean(indices_muneca_x_retorno_1500,2,'omitnan');
promedio_muneca_y_retorno_1500   = mean(indices_muneca_y_retorno_1500,2,'omitnan');

%Matriz de trayectorias (Intercalar las columnas corresponde a la taryectoria de la muneca)
trayec_alcance_1500 = table(indices_muneca_x_alcance_1500,indices_muneca_y_alcance_1500);
trayec_retorno_1500 = table(indices_muneca_x_retorno_1500,indices_muneca_y_retorno_1500);