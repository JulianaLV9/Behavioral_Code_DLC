clear
clc
close all
%% Parametros
umbral_saturacion = 0.95;
x_p_n = 50;  % Coordenada en "x" positiva/negativa que señala donde comienza uno de los brazos secundarios
dist_origen_brazo = 325; % distancia minima desde el origen a uno de los brazos secundarios que se considera para indicar que el animal llego al sitio de recompensa
min_salida = 15; %  Representa la distancia de la ultima coordenada, si es menor a un valor determinado se considera como la posiscion de salida
figura = 1;
%% Modulo 1: Obtiene matriz de n eventos por tiempo.
% Cargar datos
[~, path_name, data_archivo_videos, ~, ~] = LoadFiles;

% Define los nombres de los eventos de interes (se procesaran en el orden de entrada)
nombres = ["estimulo","puerta","aparicion"];

[seniales_binarias_minimizadas,indices,eventos_conducta] = seniales(nombres,umbral_saturacion,path_name,data_archivo_videos);
%% Modulo 2: Limpia y reconstuye las trayectorias

% cargar datos de ID tracker. Unico archivo con las trayectorias de todos los ensayos. El archivo debe tener la misma hubicacion que los videos
archivo_trajectories = data_archivo_videos{1}(1:find(data_archivo_videos{1} == '\',1,'last'));
load([archivo_trajectories 'trajectories.mat'])
% Reconstruye las trayectorias: quita nans y valores atipicos.
[trayectorias_reconstruidas,indices_numeros,~] = eval_trayectorias(trajectories,200,200);
% Calcula otros eventos de interes como brazo visitado y posiciones
[magnitud_f,magnitud_ttorigen,~,~,trayectorias_reescaladas,Tabla1] = posicion_vectorial(trayectorias_reconstruidas,indices_numeros,50,200,15,1);

%% Modulo 3: Reune la informacion del modulo 1 y 2.
senial_bin = double(eventos_conducta.seniales_binarias);
% senial_bin = senial_bin(:,1:17930);

% fila donde se encuentra el estimulo
luz = 1;
puerta = 2;
ani = 3;

estimulo_luz = senial_bin(luz,:);

% intervalo del estimulo

intervalo_estimulos(:,1) = find(diff(estimulo_luz)==1)+1;
intervalo_estimulos(:,2) = find(diff(estimulo_luz)==-1);

Tabla1.intervalo_estimulos = intervalo_estimulos;

% Apertura de puerta

puerta_apertura = senial_bin(puerta,:);
idx_puerta_apertura = (find(diff(puerta_apertura)==-1)+1)';
Tabla1.idx_puerta_apertura = idx_puerta_apertura;

% deteccion de animal

animal = senial_bin(ani,:);
idx_animal = (find(diff(animal)==-1)+1)';
cortar_por_estimulos = intervalo_estimulos(:,1);
cortar_por_estimulos(end+1) = length(animal);

idx_animal_primera = zeros(1,length(intervalo_estimulos))';
for i = 1:length(intervalo_estimulos)

    
    idx_animal_n = idx_animal<cortar_por_estimulos(i+1) & idx_animal>cortar_por_estimulos(i);
    idx_animal_primera(i) = min(idx_animal(idx_animal_n));
%     idx_animal_primera(i) = idx_animal_n;

end
Tabla1.idx_animal_primera = idx_animal_primera;


% Latencias

Tabla1.Latencias = (Tabla1.idx_animal_primera-idx_puerta_apertura)*0.05;

% Tiempo de regreso

Tabla1.tiempo_regreso = (Tabla1.fin_ensayo - Tabla1.posicion_recompenza(:,1))*0.05;

M = Tabla1.Variables;
%% Modulo 4: Sacar trayectorias de ida para obtener velocidad

ini = Tabla1.inicio_ensayo;
rec = Tabla1.posicion_recompenza(:,1);

long = 150;
velocidades = nan(long,length(ini)); % por simplicidad se cortan las velocidades en el frame 100

for i = 1:length(ini)

en = i;
ida = trayectorias_reescaladas(ini(en):rec(en),:);
vel = (diff(ida)).^2;
vel2 = vel(:,1)+vel(:,2);

l = length(vel2);
velocidades(1:l,i) = vel2;

end
promedio_velocidades = mean(velocidades,2,"omitnan");
promedio_velocidades = promedio_velocidades(1:long);

figure()
plot(promedio_velocidades)
shg


%% Guardar
varia = Tabla1.Variables;
 
ccd = cd;
cd(path_name)
csvwrite('variables.txt',varia)
csvwrite('velocidadprom.txt',promedio_velocidades)
cd(ccd)

path_name
%%

return
for i = 1:length( Tabla1.inicio_ensayo)

en =i;
ini = Tabla1.inicio_ensayo;
rec = Tabla1.posicion_recompenza(:,1);
figure(1)
plot(trayectorias_reescaladas(ini(en):rec(en),1),trayectorias_reescaladas(ini(en):rec(en),2))
figure(2)
plot(trayectorias_reescaladas(indices_numeros(en,1):indices_numeros(en,2),1),trayectorias_reescaladas(indices_numeros(en,1):indices_numeros(en,2),2))
pause(1)
end








