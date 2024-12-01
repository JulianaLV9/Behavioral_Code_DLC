clear
clc
close all
%% Parametros
num_frames = 499; % Numero de frames actual
is_sampled = 1; % Si los videos de calcio fueron tomados a 20FPS y la conducta 30FPS. Ademas si la longitud de los videos es length recordin-1Frame.
umbral_saturacion = 0.8;
x_p_n = 50;  % Coordenada en "x" positiva/negativa que señala donde comienza uno de los brazos secundarios
dist_origen_brazo = 350; % distancia minima desde el origen a uno de los brazos secundarios que se considera para indicar que el animal llego al sitio de recompensa
min_salida = 15; %  Representa la distancia de la ultima coordenada, si es menor a un valor determinado se considera como la posiscion de salida
nans_max = 5; % Numero de nans maximos permitidos en las trayectorias si se pierde el animal  
dist_min = 200; % Distancia minima acumulada en el ensayo. En las trayectorias discontinuas, la distancia acumulada es menor que una completa, por tanto si son menor que dist_min se rellenan con NaNs
numero_bines = 30;
figura = 1;
%% Modulo 1: Obtiene matriz de n eventos conductuales por tiempo.
% Cargar datos: Videos conductuales
[~, path_name, data_archivo_videos, ~, ~] = LoadFiles;
% Define los nombres de los eventos de interes (se procesaran en el orden de entrada)
nombres = ["luz","tono","puerta"];

[~,~,eventos_conducta] = seniales(nombres,umbral_saturacion,path_name,data_archivo_videos);

if is_sampled == 1

    archivo_timeStamp = data_archivo_videos{1}(1:find(data_archivo_videos{1} == '\',1,'last'));
    load([archivo_timeStamp 'timeStamps_conducta.mat'])

    senial = eventos_conducta.seniales_binarias;
    [senial_mas_un_frame] = add_frame(senial,length(data_archivo_videos),num_frames);

    seniales_binarias_sampled = senial_mas_un_frame(:,tsb_sampled(:,1));
    eventos_conducta.seniales_binarias_sampled = seniales_binarias_sampled; 

end

%% Modulo 2: Limpia y reconstuye las trayectorias

% cargar datos de ID tracker. Unico archivo con las trayectorias de todos los ensayos. El archivo debe tener la misma hubicacion que los videos
archivo_trajectories = data_archivo_videos{1}(1:find(data_archivo_videos{1} == '\',1,'last'));
load([archivo_trajectories 'trajectories.mat'])

if is_sampled == 1
    trajectories_permute = permute(trajectories,[3,1,2]);
    [trajectories_mas_un_frame] = add_frame(trajectories_permute,length(data_archivo_videos),num_frames);
    trajectories_mas_un_frame = permute(trajectories_mas_un_frame,[2,3,1]);
    trajectories_sampled = trajectories_mas_un_frame(tsb_sampled(:,1),:,:);

    % Reconstruye las trayectorias: quita nans y valores atipicos.
    [trayectorias_reconstruidas,indices_numeros,~] = eval_trayectorias(trajectories_sampled,nans_max,dist_min);
    % Calcula otros eventos de interes como brazo visitado y posiciones
    [magnitud_f,posicion_vectorial_tiempo_tiempo,~,~,trayectorias_reescaladas,eventos_tabla] = posicion_vectorial(trayectorias_reconstruidas,indices_numeros,x_p_n,dist_origen_brazo,min_salida,figura);
else

    % Reconstruye las trayectorias: quita nans y valores atipicos.
    [trayectorias_reconstruidas,indices_numeros,~] = eval_trayectorias(trajectories,nans_max,dist_min);
    % Calcula otros eventos de interes como brazo visitado y posiciones
    [magnitud_f,posicion_vectorial_tiempo_tiempo,~,~,trayectorias_reescaladas,eventos_tabla] = posicion_vectorial(trayectorias_reconstruidas,indices_numeros,x_p_n,dist_origen_brazo,min_salida,figura);


end

%% Calcula la posicion binarizada
% posicion_binarizada = pos_bin(posicion_vectorial_tiempo_tiempo,numero_bines);
    
%% Modulo 3: Reune la informacion del modulo 1 y 2.

if is_sampled == 1
    seniales_binarias_sampled = eventos_conducta.seniales_binarias_sampled;
    eventos_conducta_tabla = extender_bd(seniales_binarias_sampled,eventos_tabla);
else
    seniales_binarias = eventos_conducta.seniales_binarias;
    eventos_conducta_tabla = extender_bd(seniales_binarias,eventos_tabla);

end

% ejemplo de como filtrar datos. El tipo puede ser de las siguietes cuatro opciones.

% lc = luz correcto
% tc = tono correcto 
% li = luz incorrecto
% ti = tono incorrecto
[tabla_filtrada] = filtrar_base(eventos_conducta_tabla,'ti');


intesti = eventos_conducta_tabla.intervalo_estimulos;
duresti = intesti(:,2) - intesti(:,1);

inicio = eventos_conducta_tabla.inicio_ensayo;
recompenza = eventos_conducta_tabla.posicion_recompenza(:,1);
tiempo_recorrido = (recompenza-inicio);

%% Salvar base de datos
WorkFolder = cd; 
cd(path_name);
Sesion = date;
save(['Eventos conducta' '_' Sesion '.mat'],'eventos_conducta');
save(['Eventos conducta tabla' '_' Sesion '.mat'],'eventos_conducta_tabla','posicion_vectorial_tiempo_tiempo');
save(['trajectories_sampled' '_' Sesion '.mat'],'trajectories_sampled');
cd(WorkFolder);



