function [trayec_500,trayec_1000,trayec_1500,tabla_cinematica_500,tabla_cinematica_1000,tabla_cinematica_1500] = primera_trayectoria(correcto_500,correcto_1000,correcto_1500,dlc_matrix,umbral_barra,umbral_bebedero)
%Pendientes: Todavia puedo suavizar un poco esas trayectorias
%frame_go_cue no lo ocupo aquí al menos que quiera plotear la velocidad
%donde en planeación esta en 0, pero podría ser 30; 60; 90 frames
%respectivamente
%NOTAS:
%122 pixeles = 2.5 cm
% 50 pixeles = 1.02 cm
%Barra-bebedero = 3 cm (146 px)



%% Delimitar donde esta la barra a partir del bebedero
posicion_bebedero_x = umbral_bebedero(1,1);
posicion_bebedero_y = umbral_bebedero(1,2);
posicion_bebedero   = [posicion_bebedero_x posicion_bebedero_y];
posicion_barra_x    = umbral_barra(1,1);
posicion_barra_y    = umbral_barra(1,2);
posicion_barra      = [posicion_barra_x posicion_barra_y];

%% TODA LA TRAYECTORIA
if height(correcto_500) > 1
   
% EJECUCION 500 ms 
frames_retorno     = 8;
frame_dur          = 16.67 / 1000;
go_cue             = correcto_500.Go_Cue_essay;
correcto           = correcto_500.Recompensa_essay + frames_retorno;  
ventanas_ejecucion = [go_cue correcto];
frames_totales     = ventanas_ejecucion(:,2)- ventanas_ejecucion(:,1);

%Tiempos de reaccion
tiempo_reaccion_500 = (correcto_500.Bar_essay - correcto_500.Go_Cue_essay)*frame_dur;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_general_500   = NaN(max(frames_totales)+1,length(ventanas_ejecucion));
muneca_y_general_500   = NaN(max(frames_totales)+1,length(ventanas_ejecucion));

for ii = 1:length(ventanas_ejecucion)
    inicio = ventanas_ejecucion(ii,1);
    final  = ventanas_ejecucion(ii,2);

    % Extraer el fragmento de dlc_matrix
    matrix      = dlc_matrix(inicio:final,:); % Extraer toda la información de la ventana de planeación según DLC
    
    muneca_x    = matrix(:,17); % Extraer solo la trayectoria de la muñeca
    muneca_y    = matrix(:,18);
    
    % Encontrar los índices donde muneca_x es mayor a posicion_barra_x
    indices_validos = find(muneca_x >= posicion_barra_x & muneca_x <= posicion_bebedero);
    
    % Comprobar si hay 3 valores consecutivos
    inicio_muneca_x = [];
    for idx = 1:length(indices_validos)-2
        if indices_validos(idx+1) == indices_validos(idx) + 1 && indices_validos(idx+2) == indices_validos(idx+1) + 1
            inicio_muneca_x = indices_validos(idx:idx+2);
            break;
        end
    end
    
    % Si se encontro un inicio válido
    if ~isempty(inicio_muneca_x)
        % Guardar el valor inicial de la muñeca
        posicion_inicial_muneca_x = muneca_x(inicio_muneca_x(1));
        
        % Buscar el final de la trayectoria cuando muneca_x sea menor o igual a posicion_inicial_muneca_x
        fin_muneca_x = find(muneca_x(inicio_muneca_x(end):end) <= posicion_inicial_muneca_x, 1, 'first') + inicio_muneca_x(end) - 1;
        
        if ~isempty(fin_muneca_x)
            % Extraer la ventana de trayectoria recortada entre inicio_muneca_x y fin_muneca_x
            trayectoria_x_recortada = muneca_x(inicio_muneca_x(1):fin_muneca_x);
            trayectoria_y_recortada = muneca_y(inicio_muneca_x(1):fin_muneca_x);
            
            % Guardar solo la trayectoria recortada
            muneca_x_general_500(1:length(trayectoria_x_recortada), ii) = trayectoria_x_recortada;
            muneca_y_general_500(1:length(trayectoria_y_recortada), ii) = trayectoria_y_recortada;
        end
    else
        fin_muneca_x = []; % Si no hay inicio, no se puede determinar el fin
    end
end

tiempo_inicial     = 0;
tiempo_final       = frame_dur * (max(frames_totales));
tiempo_500         = tiempo_inicial:frame_dur:tiempo_final;

%Sacar velocidad y aceleracion
[velocidad_500,~,aceleracion_500,~,duracion_500] = velocidad_aceleracion(muneca_x_general_500,muneca_y_general_500,tiempo_500);

%Sacar outliers respecto a la velocidad 
%[velocidad_500_out,aceleracion_500_out,indices_muneca_x_500,indices_muneca_y_500] = interquartil(velocidad_500_out,aceleracion_500_out,muneca_x_out,muneca_y_out);

%Promedios out
mean_velocidad_500   = mean(velocidad_500,1,'omitnan');
mean_aceleracion_500 = mean(aceleracion_500,1,'omitnan');

promedio_muneca_x_500   = mean(muneca_x_general_500,2,'omitnan');
promedio_muneca_y_500   = mean(muneca_y_general_500,2,'omitnan');

%Generar figura representativa
name          = 'Trayectoria con 500 ms de preparación';
generador_trayectoria(muneca_x_general_500,muneca_y_general_500,promedio_muneca_x_500,promedio_muneca_y_500,posicion_bebedero,posicion_barra,name);

%Matriz de trayectorias (Intercalar las columnas corresponde a la taryectoria de la muneca)
trayec_500 = table(muneca_x_general_500,muneca_y_general_500);

end 


% EJECUCION 1000 ms 

if height(correcto_1000) > 1

frames_retorno     = 8;
frame_dur          = 16.67 / 1000;
go_cue             = correcto_1000.Go_Cue_essay;
correcto           = correcto_1000.Recompensa_essay + frames_retorno;  %Aqui agregue 16 frames equivalente a 300 ms posterior a que toco el bebedero
ventanas_ejecucion = [go_cue correcto];
frames_totales     = ventanas_ejecucion(:,2)- ventanas_ejecucion(:,1);

%Tiempos de reaccion
tiempo_reaccion_1000 = (correcto_1000.Bar_essay - correcto_1000.Go_Cue_essay)*frame_dur;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_general_1000   = NaN(max(frames_totales)+1,length(ventanas_ejecucion));
muneca_y_general_1000   = NaN(max(frames_totales)+1,length(ventanas_ejecucion));

for ii = 1:length(ventanas_ejecucion)
    inicio = ventanas_ejecucion(ii,1);
    final  = ventanas_ejecucion(ii,2);

    % Extraer el fragmento de dlc_matrix
    matrix      = dlc_matrix(inicio:final,:); % Extraer toda la información de la ventana de planeación según DLC
    
    muneca_x    = matrix(:,17); % Extraer solo la trayectoria de la muñeca
    muneca_y    = matrix(:,18);
    
    % Encontrar los índices donde muneca_x es mayor a posicion_barra_x
    indices_validos = find(muneca_x >= posicion_barra_x & muneca_x <= posicion_bebedero);
    
    % Comprobar si hay 3 valores consecutivos
    inicio_muneca_x = [];
    for idx = 1:length(indices_validos)-2
        if indices_validos(idx+1) == indices_validos(idx) + 1 && indices_validos(idx+2) == indices_validos(idx+1) + 1
            inicio_muneca_x = indices_validos(idx:idx+2);
            break;
        end
    end
    
    % Si se encontró un inicio válido
    if ~isempty(inicio_muneca_x)
        % Guardar el valor inicial de la muñeca
        posicion_inicial_muneca_x = muneca_x(inicio_muneca_x(1));
        
        % Buscar el final de la trayectoria cuando muneca_x sea menor o igual a posicion_inicial_muneca_x
        fin_muneca_x = find(muneca_x(inicio_muneca_x(end):end) <= posicion_inicial_muneca_x, 1, 'first') + inicio_muneca_x(end) - 1;
        
        if ~isempty(fin_muneca_x)
            % Extraer la ventana de trayectoria recortada entre inicio_muneca_x y fin_muneca_x
            trayectoria_x_recortada = muneca_x(inicio_muneca_x(1):fin_muneca_x);
            trayectoria_y_recortada = muneca_y(inicio_muneca_x(1):fin_muneca_x);
            
            % Guardar solo la trayectoria recortada
            muneca_x_general_1000(1:length(trayectoria_x_recortada), ii) = trayectoria_x_recortada;
            muneca_y_general_1000(1:length(trayectoria_y_recortada), ii) = trayectoria_y_recortada;
        end
    else
        fin_muneca_x = []; % Si no hay inicio, no se puede determinar el fin
    end
end

tiempo_inicial     = 0;
tiempo_final       = frame_dur * (max(frames_totales));
tiempo_1000         = tiempo_inicial:frame_dur:tiempo_final;

%Sacar velocidad y aceleracion
[velocidad_1000,~,aceleracion_1000,~,duracion_1000] = velocidad_aceleracion(muneca_x_general_1000,muneca_y_general_1000,tiempo_1000);

%Sacar outliers respecto a la velocidad 
%[velocidad_1000_out,aceleracion_1000_out,indices_muneca_x_1000,indices_muneca_y_1000] = interquartil(velocidad_1000_out,aceleracion_1000_out,muneca_x_out,muneca_y_out);

%Promedios out
mean_velocidad_1000   = mean(velocidad_1000,1,'omitnan');
mean_aceleracion_1000 = mean(aceleracion_1000,1,'omitnan');

promedio_muneca_x_1000   = mean(muneca_x_general_1000,2,'omitnan');
promedio_muneca_y_1000   = mean(muneca_y_general_1000,2,'omitnan');

%Generar figura representativa
name          = 'Trayectoria con 1000 ms de preparación';
generador_trayectoria(muneca_x_general_1000,muneca_y_general_1000,promedio_muneca_x_1000,promedio_muneca_y_1000,posicion_bebedero,posicion_barra,name);

%Matriz de trayectorias (Intercalar las columnas corresponde a la taryectoria de la muneca)
trayec_1000 = table(muneca_x_general_1000,muneca_y_general_1000);

end 

% EJECUCION 1500 ms 

if height(correcto_1500) > 1
frames_retorno     = 8;
frame_dur          = 16.67 / 1000;
go_cue             = correcto_1500.Go_Cue_essay;
correcto           = correcto_1500.Recompensa_essay + frames_retorno;  %Aqui agregue 16 frames equivalente a 300 ms posterior a que toco el bebedero
ventanas_ejecucion = [go_cue correcto];
frames_totales     = ventanas_ejecucion(:,2)- ventanas_ejecucion(:,1);

%Tiempos de reaccion
tiempo_reaccion_1500 = (correcto_1500.Bar_essay - correcto_1500.Go_Cue_essay)*frame_dur;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_general_1500   = NaN(max(frames_totales)+1,length(ventanas_ejecucion));
muneca_y_general_1500   = NaN(max(frames_totales)+1,length(ventanas_ejecucion));

for ii = 1:length(ventanas_ejecucion)
    inicio = ventanas_ejecucion(ii,1);
    final  = ventanas_ejecucion(ii,2);

    % Extraer el fragmento de dlc_matrix
    matrix      = dlc_matrix(inicio:final,:); % Extraer toda la información de la ventana de planeación según DLC
    
    muneca_x    = matrix(:,17); % Extraer solo la trayectoria de la muñeca
    muneca_y    = matrix(:,18);
    
    % Encontrar los índices donde muneca_x es mayor a posicion_barra_x
    indices_validos = find(muneca_x >= posicion_barra_x & muneca_x <= posicion_bebedero);
    
    % Comprobar si hay 3 valores consecutivos
    inicio_muneca_x = [];
    for idx = 1:length(indices_validos)-2
        if indices_validos(idx+1) == indices_validos(idx) + 1 && indices_validos(idx+2) == indices_validos(idx+1) + 1
            inicio_muneca_x = indices_validos(idx:idx+2);
            break;
        end
    end
    
    % Si se encontró un inicio válido
    if ~isempty(inicio_muneca_x)
        % Guardar el valor inicial de la muñeca
        posicion_inicial_muneca_x = muneca_x(inicio_muneca_x(1));
        
        % Buscar el final de la trayectoria cuando muneca_x sea menor o igual a posicion_inicial_muneca_x
        fin_muneca_x = find(muneca_x(inicio_muneca_x(end):end) <= posicion_inicial_muneca_x, 1, 'first') + inicio_muneca_x(end) - 1;
        
        if ~isempty(fin_muneca_x)
            % Extraer la ventana de trayectoria recortada entre inicio_muneca_x y fin_muneca_x
            trayectoria_x_recortada = muneca_x(inicio_muneca_x(1):fin_muneca_x);
            trayectoria_y_recortada = muneca_y(inicio_muneca_x(1):fin_muneca_x);
            
            % Guardar solo la trayectoria recortada
            muneca_x_general_1500(1:length(trayectoria_x_recortada), ii) = trayectoria_x_recortada;
            muneca_y_general_1500(1:length(trayectoria_y_recortada), ii) = trayectoria_y_recortada;
        end
    else
        fin_muneca_x = []; % Si no hay inicio, no se puede determinar el fin
    end
end

tiempo_inicial     = 0;
tiempo_final       = frame_dur * (max(frames_totales));
tiempo_1500         = tiempo_inicial:frame_dur:tiempo_final;

%Sacar velocidad y aceleracion
[velocidad_1500,~,aceleracion_1500,~,duracion_1500] = velocidad_aceleracion(muneca_x_general_1500,muneca_y_general_1500,tiempo_1500);

%Sacar outliers respecto a la velocidad 
%[velocidad_1500_out,aceleracion_1500_out,indices_muneca_x_1500,indices_muneca_y_1500] = interquartil(velocidad_1500_out,aceleracion_1500_out,muneca_x_out,muneca_y_out);

%Promedios out
mean_velocidad_1500   = mean(velocidad_1500,1,'omitnan');
mean_aceleracion_1500 = mean(aceleracion_1500,1,'omitnan');

promedio_muneca_x_1500   = mean(muneca_x_general_1500,2,'omitnan');
promedio_muneca_y_1500   = mean(muneca_y_general_1500,2,'omitnan');

%Generar figura representativa
name          = 'Trayectoria con 1500 ms de preparación';
generador_trayectoria(muneca_x_general_1500,muneca_y_general_1500,promedio_muneca_x_1500,promedio_muneca_y_1500,posicion_bebedero,posicion_barra,name);

%Correlaciones 

%Matriz de trayectorias (Intercalar las columnas corresponde a la taryectoria de la muneca)
trayec_1500 = table(muneca_x_general_1500,muneca_y_general_1500);

end 
%% ALCANCE Y RETORNO DE LA TRAYECTORIA %% Codigo trayectoria_alcance lo deje pendiente debido a que no tiene resolucion epacial de lo cual debo quitar el generador de trayectorias

% ALCANCE 500 ms 

if height(correcto_500) > 1
%Extraer el valor minimo (Es el maximo en pixeles para la mano de la rata a
%partir de la matriz y)
alcance_x_500 = NaN(10,size(muneca_x_general_500,2));
alcance_y_500 = NaN(10,size(muneca_y_general_500,2));
retorno_x_500 = NaN(10,size(muneca_x_general_500,2));
retorno_y_500 = NaN(10,size(muneca_y_general_500,2));


for ii = 1:size(muneca_y_general_500, 2)

    % Quitar los NaN
    muneca_x        = muneca_x_general_500(~isnan(muneca_x_general_500(:, ii)), ii);
    muneca_y        = muneca_y_general_500(~isnan(muneca_y_general_500(:, ii)), ii);

    % Encontar el valor minimo en muneca_y
    [~, idx_min] = min(muneca_y);

    % Trayectoria de alcance
    alcance_x_500(1:idx_min, ii) = muneca_x(1:idx_min);
    alcance_y_500(1:idx_min, ii) = muneca_y(1:idx_min);

    % Trayectoria de retorno
    retorno_x_500(1:length(muneca_x(idx_min+1:end)), ii) = muneca_x(idx_min+1:end);
    retorno_y_500(1:length(muneca_y(idx_min+1:end)), ii) = muneca_y(idx_min+1:end);

end

%Sacar velocidad, aceleracion, duracion de alcance
[velocidad_alcance_500,~,aceleracion_alcance_500,~,duracion_alcance_500] = velocidad_aceleracion(alcance_x_500,alcance_y_500,tiempo_500(1:length(alcance_x_500)));
mean_velocidad_alcance_500   = mean(velocidad_alcance_500,1,'omitnan');
mean_aceleracion_alcance_500 = mean(aceleracion_alcance_500,1,'omitnan');

%Sacar velocidad, aceleracion, duracion de alcance
[velocidad_retorno_500,~,aceleracion_retorno_500,~,duracion_retorno_500] = velocidad_aceleracion(retorno_x_500,retorno_y_500,tiempo_500(1:length(retorno_x_500)));
mean_velocidad_retorno_500   = mean(velocidad_retorno_500,1,'omitnan');
mean_aceleracion_retorno_500 = mean(aceleracion_retorno_500,1,'omitnan');

%Sacar promedios de las trayectorias
mean_alcance_x_500 = mean(alcance_x_500,2,'omitnan');
mean_alcance_y_500 = mean(alcance_y_500,2,'omitnan');
mean_retorno_x_500 = mean(retorno_x_500,2,'omitnan');
mean_retorno_y_500 = mean(retorno_y_500,2,'omitnan');

name = "Reaching with 500 ms of preparation";
%Generar trayectoria de alcance 
%generador_trayectoria(alcance_x_500,alcance_y_500,mean_alcance_x_500,mean_alcance_y_500,posicion_bebedero,posicion_barra,name);

name = "Return with 500 ms of preparation";
%Generar trayectoria de retorno
%generador_trayectoria(retorno_x_500,retorno_y_500,mean_retorno_x_500,mean_retorno_y_500,posicion_bebedero,posicion_barra,name);

%Crear tablas 
[tabla_cinematica_500]         = table(tiempo_reaccion_500,duracion_500,mean_velocidad_500',mean_aceleracion_500',duracion_alcance_500,mean_velocidad_alcance_500',mean_aceleracion_alcance_500',duracion_retorno_500,mean_velocidad_retorno_500',mean_aceleracion_retorno_500');
%[tabla_cinematica_alcance_500] = table(correcto_500,duracion_alcance_500,mean_velocidad_alcance_500',mean_aceleracion_alcance_500');
%[tabla_cinematica_retorno_500] = table(correcto_500,duracion_retorno_500,mean_velocidad_retorno_500',mean_aceleracion_retorno_500');

end 

% ALCANCE 1000 ms 

if height(correcto_1000) > 1

%Extraer el valor minimo (Es el maximo en pixeles para la mano de la rata a
%partir de la matriz y)
alcance_x_1000 = NaN(10,size(muneca_x_general_1000,2));
alcance_y_1000 = NaN(10,size(muneca_y_general_1000,2));
retorno_x_1000 = NaN(10,size(muneca_x_general_1000,2));
retorno_y_1000 = NaN(10,size(muneca_y_general_1000,2));


for ii = 1:size(muneca_y_general_1000, 2)

    % Quitar los NaN
    muneca_x = muneca_x_general_1000(~isnan(muneca_x_general_1000(:, ii)), ii);
    muneca_y = muneca_y_general_1000(~isnan(muneca_y_general_1000(:, ii)), ii);

    % Encontar el valor minimo en muneca_y
    [~, idx_min] = min(muneca_y);

    % Trayectoria de alcance
    alcance_x_1000(1:idx_min, ii) = muneca_x(1:idx_min);
    alcance_y_1000(1:idx_min, ii) = muneca_y(1:idx_min);

    % Trayectoria de retorno
    retorno_x_1000(1:length(muneca_x(idx_min+1:end)), ii) = muneca_x(idx_min+1:end);
    retorno_y_1000(1:length(muneca_y(idx_min+1:end)), ii) = muneca_y(idx_min+1:end);

end

%Sacar velocidad, aceleracion, duracion de alcance
[velocidad_alcance_1000,~,aceleracion_alcance_1000,~,duracion_alcance_1000] = velocidad_aceleracion(alcance_x_1000,alcance_y_1000,tiempo_1000(1:length(alcance_x_1000)));
mean_velocidad_alcance_1000   = mean(velocidad_alcance_1000,1,'omitnan');
mean_aceleracion_alcance_1000 = mean(aceleracion_alcance_1000,1,'omitnan');

%Sacar velocidad, aceleracion, duracion de alcance
[velocidad_retorno_1000,~,aceleracion_retorno_1000,~,duracion_retorno_1000] = velocidad_aceleracion(retorno_x_1000,retorno_y_1000,tiempo_1000(1:length(retorno_x_1000)));
mean_velocidad_retorno_1000   = mean(velocidad_retorno_1000,1,'omitnan');
mean_aceleracion_retorno_1000 = mean(aceleracion_retorno_1000,1,'omitnan');

%Sacar promedios de las trayectorias
mean_alcance_x_1000 = mean(alcance_x_1000,2,'omitnan');
mean_alcance_y_1000 = mean(alcance_y_1000,2,'omitnan');
mean_retorno_x_1000 = mean(retorno_x_1000,2,'omitnan');
mean_retorno_y_1000 = mean(retorno_y_1000,2,'omitnan');

name = "Reaching with 1000 ms of preparation";
%Generar trayectoria de alcance 
%generador_trayectoria(alcance_x_1000,alcance_y_1000,mean_alcance_x_1000,mean_alcance_y_1000,posicion_bebedero,posicion_barra,name);

name = "Return with 1000 ms of preparation";
%Generar trayectoria de retorno
%generador_trayectoria(retorno_x_1000,retorno_y_1000,mean_retorno_x_1000,mean_retorno_y_1000,posicion_bebedero,posicion_barra,name);

%Crear tablas 
[tabla_cinematica_1000]         = table(tiempo_reaccion_1000,duracion_1000,mean_velocidad_1000',mean_aceleracion_1000',duracion_alcance_1000,mean_velocidad_alcance_1000',mean_aceleracion_alcance_1000',duracion_retorno_1000,mean_velocidad_retorno_1000',mean_aceleracion_retorno_1000');
%[tabla_cinematica_alcance_1000] = table(correcto_1000,duracion_alcance_1000,mean_velocidad_alcance_1000',mean_aceleracion_alcance_1000');
%[tabla_cinematica_retorno_1000] = table(correcto_1000,duracion_retorno_1000,mean_velocidad_retorno_1000',mean_aceleracion_retorno_1000');

end



% ALCANCE 1500 ms 

if height(correcto_1500) > 1

%Extraer el valor minimo (Es el maximo en pixeles para la mano de la rata a
%partir de la matriz y)
alcance_x_1500 = NaN(10,size(muneca_x_general_1500,2));
alcance_y_1500 = NaN(10,size(muneca_y_general_1500,2));
retorno_x_1500 = NaN(10,size(muneca_x_general_1500,2));
retorno_y_1500 = NaN(10,size(muneca_y_general_1500,2));


for ii = 1:size(muneca_y_general_1500, 2)

    % Quitar los NaN
    muneca_x = muneca_x_general_1500(~isnan(muneca_x_general_1500(:, ii)), ii);
    muneca_y = muneca_y_general_1500(~isnan(muneca_y_general_1500(:, ii)), ii);

    % Encontar el valor minimo en muneca_y
    [~, idx_min] = min(muneca_y);

    % Trayectoria de alcance
    alcance_x_1500(1:idx_min, ii) = muneca_x(1:idx_min);
    alcance_y_1500(1:idx_min, ii) = muneca_y(1:idx_min);

    % Trayectoria de retorno
    retorno_x_1500(1:length(muneca_x(idx_min+1:end)), ii) = muneca_x(idx_min+1:end);
    retorno_y_1500(1:length(muneca_y(idx_min+1:end)), ii) = muneca_y(idx_min+1:end);

end

%Sacar velocidad, aceleracion, duracion de alcance
[velocidad_alcance_1500,~,aceleracion_alcance_1500,~,duracion_alcance_1500] = velocidad_aceleracion(alcance_x_1500,alcance_y_1500,tiempo_1500(1:length(alcance_x_1500)));
mean_velocidad_alcance_1500   = mean(velocidad_alcance_1500,1,'omitnan');
mean_aceleracion_alcance_1500 = mean(aceleracion_alcance_1500,1,'omitnan');

%Sacar velocidad, aceleracion, duracion de alcance
[velocidad_retorno_1500,~,aceleracion_retorno_1500,~,duracion_retorno_1500] = velocidad_aceleracion(retorno_x_1500,retorno_y_1500,tiempo_1500(1:length(retorno_x_1500)));
mean_velocidad_retorno_1500   = mean(velocidad_retorno_1500,1,'omitnan');
mean_aceleracion_retorno_1500 = mean(aceleracion_retorno_1500,1,'omitnan');

%Sacar promedios de las trayectorias
mean_alcance_x_1500 = mean(alcance_x_1500,2,'omitnan');
mean_alcance_y_1500 = mean(alcance_y_1500,2,'omitnan');
mean_retorno_x_1500 = mean(retorno_x_1500,2,'omitnan');
mean_retorno_y_1500 = mean(retorno_y_1500,2,'omitnan');

name = "Reaching with 1500 ms of preparation";
%Generar trayectoria de alcance 
%generador_trayectoria(alcance_x_1500,alcance_y_1500,mean_alcance_x_1500,mean_alcance_y_1500,posicion_bebedero,posicion_barra,name);

name = "Return with 1500 ms of preparation";
%Generar trayectoria de retorno

%generador_trayectoria(retorno_x_1500,retorno_y_1500,mean_retorno_x_1500,mean_retorno_y_1500,posicion_bebedero,posicion_barra,name);

%Crear tablas
[tabla_cinematica_1500]         = table(tiempo_reaccion_1500,duracion_1500,mean_velocidad_1500',mean_aceleracion_1500',duracion_alcance_1500,mean_velocidad_alcance_1500',mean_aceleracion_alcance_1500',duracion_retorno_1500,mean_velocidad_retorno_1500',mean_aceleracion_retorno_1500');
%[tabla_cinematica_alcance_1500] = table(correcto_1500,duracion_alcance_1500,mean_velocidad_alcance_1500',mean_aceleracion_alcance_1500');
%[tabla_cinematica_retorno_1500] = table(correcto_1500,duracion_retorno_1500,mean_velocidad_retorno_1500',mean_aceleracion_retorno_1500');

end 

%Verificar que existen las variables

if exist('trayec_500','var') == 1
    trayec_500 = trayec_500;

else
    trayec_500 = NaN;
end

if exist('trayec_1000','var') == 1
    trayec_1000 = trayec_1000;

else
    trayec_1000 = NaN;
end

if exist('trayec_1500','var') == 1
    trayec_1500 = trayec_1500;

else
    trayec_1500 = NaN;
end

if exist('tabla_cinematica_500','var') == 1
    tabla_cinematica_500 = tabla_cinematica_500;

else
    tabla_cinematica_500 = NaN;
end

if exist('tabla_cinematica_1000','var') == 1
    tabla_cinematica_1000 = tabla_cinematica_1000;

else
    tabla_cinematica_1000 = NaN;
end

if exist('tabla_cinematica_1500','var') == 1
    tabla_cinematica_1500 = tabla_cinematica_1500;

else
    tabla_cinematica_1500 = NaN;
end

%% Sacar las velocidades para graficar (A ver si salen)
%[velocidades_totales] = velocidades(velocidad_500,velocidad_1000,velocidad_1500);
end 