function [trayec_500,trayec_1000,trayec_1500,cont_figura,tabla_cinematica,tabla_cinematica_alcance, tabla_cinematica_retorno] = trayectorias(correcto_500,correcto_1000,correcto_1500,dlc_matrix,cont_figura)
%Pendientes: Todavia puedo suavizar un poco esas trayectorias
%frame_go_cue no lo ocupo aquí al menos que quiera plotear la velocidad
%donde en planeación esta en 0, pero podría ser 30; 60; 90 frames
%respectivamente
%NOTAS:
%122 pixeles = 2.5 cm
% 50 pixeles = 1.02 cm
%Barra-bebedero = 3 cm (146 px)

cont_figura = cont_figura +1;
%% TODA LA TRAYECTORIA

% EJECUCION 500 ms 
frames_go_cue      = 0; %Cambiar a 30 si es el caso
frames_retorno     = 16;
frame_dur          = 16.67 / 1000;
go_cue             = correcto_500.Go_Cue_essay;
%go_cue            = correcto_500.Go_Cue_essay - frames_go_cue;%Aqui estoy restando 30 frames (posibilidad de 500 ms que dura el estimulo) 
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

%Obtener la velocidad y aceleracion
[velocidad_500,velocidad_ensayos_500,aceleracion_500,aceleracion_ensayos_500,duracion_500] = velocidad_aceleracion(muneca_x_general_500(frames_go_cue+1:end,:),muneca_y_general_500(frames_go_cue+1:end,:),tiempo_500(frames_go_cue+1:end));

%Sacar outliers respecto a la velocidad 
[indices_velocidad,indices_muneca_x,indices_muneca_y] = interquartil(velocidad_500,muneca_x_general_500,muneca_y_general_500);

promedio_muneca_x   = mean(muneca_x_general_500,2,'omitnan');
promedio_muneca_y   = mean(muneca_y_general_500,2,'omitnan');

%Obtener la posición del bebedero y de la barra
barra_500    = [promedio_muneca_x(31, 1),promedio_muneca_y(31, 1)];
bebedero_500 = [promedio_muneca_x(31, 1)+146,promedio_muneca_y(31, 1)-142];

figure(cont_figura),
set(gca, 'YDir', 'reverse')
grid on
for kk = 1 : size(indices_muneca_x,2)

    vector_x = indices_muneca_x(:,kk);
    vector_y = indices_muneca_y(:,kk);

    % Extraer el fragmento sin NaN
    muneca_x = vector_x(~isnan(vector_x));
    muneca_y = vector_y(~isnan(vector_y));

    if length(muneca_x) < 2 || length(muneca_y) < 2
        continue; % Si no hay suficientes puntos para trazar, pasar al siguiente
    end

    figure(cont_figura),
    set(gca, 'YDir', 'reverse')
    grid on

    for kk = 2:length(muneca_x) % Asegurarse de no exceder los límites
        hold on
        if kk > 1
            plot([muneca_x(kk - 1), muneca_x(kk)], [muneca_y(kk - 1), muneca_y(kk)], 'Color', [0.6510 0.6510 0.6510]);
        end
    end
end

% Definir colores para el gradiente
num_puntos = length(promedio_muneca_x);
colores    = [linspace(1, 0, num_puntos)', linspace(1, 0.4, num_puntos)', linspace(1, 0, num_puntos)'];

for ll = 2:length(promedio_muneca_x)
    
    U = promedio_muneca_x(ll) - promedio_muneca_x(ll - 1);
    V = promedio_muneca_y(ll) - promedio_muneca_y(ll - 1);
hold on
quiver(promedio_muneca_x(ll -1),promedio_muneca_y(ll - 1),U, V,'-','Color',colores(ll,:),'LineWidth',1.5,'MaxHeadSize', 1.5, 'AutoScale', 'off', 'AutoScaleFactor', 1.5)
plot(promedio_muneca_x(31, 1), promedio_muneca_y(1, 1), 'o', 'MarkerFaceColor', [0.8196    0.6431    0.4902], 'MarkerEdgeColor', [0.8196    0.6431    0.4902],'MarkerSize',15)
plot(promedio_muneca_x(31, 1) + 146, promedio_muneca_y(1, 1) - 142, 'o', 'MarkerFaceColor', [0.2902    0.3490    0.5098], 'MarkerEdgeColor', [0.2902    0.3490    0.5098],'MarkerSize',15)
end 

xlabel('Coordenada X'); %Convertir esto a mm
ylabel('Coordenada Y');
%set(gca, 'XColor', 'none', 'YColor', 'none'); % Oculta los ejes
set(gca, 'PlotBoxAspectRatio', [1 1 1]);
%xlim([500 800])
%ylim([50 350])
title('Ejecución del movimeinto con 500 ms de preparación');
cont_figura = cont_figura +1;

%Matriz de trayectorias (Intercalar las columnas corresponde a la
%taryectoria de la muneca)
trayec_500 = table(indices_muneca_x,indices_muneca_y);

% EJECUCION 1000 ms
frames_go_cue      = 0;
frames_retorno     = 16;
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
    
    figure(cont_figura),
    set(gca, 'YDir', 'reverse')
    grid on 
    for kk = 2 : length(muneca_x)
    hold on
    plot([muneca_x(kk - 1), muneca_x(kk)], [muneca_y(kk - 1), muneca_y(kk)], '-','Color',[0.8000    0.8000    0.8000])
    end 
   
    muneca_x_general_1000(1:length(muneca_x), ii) = muneca_x;
    muneca_y_general_1000(1:length(muneca_y), ii) = muneca_y;
end 

promedio_muneca_x = mean(muneca_x_general_1000,2,'omitnan');
promedio_muneca_y = mean(muneca_y_general_1000,2);

%Obtener la posición del bebedero y de la barra
barra_1000    = [promedio_muneca_x(61, 1),promedio_muneca_y(61, 1)];
bebedero_1000 = [promedio_muneca_x(61, 1)+146,promedio_muneca_y(61, 1)-142];

% Definir colores para el gradiente
num_puntos = length(promedio_muneca_x);
colores    = [linspace(1, 0, num_puntos)', linspace(1, 0.4, num_puntos)', linspace(1, 0, num_puntos)'];

for ll = 2:length(promedio_muneca_x)
    U = promedio_muneca_x(ll) - promedio_muneca_x(ll - 1);
    V = promedio_muneca_y(ll) - promedio_muneca_y(ll - 1);
hold on
quiver(promedio_muneca_x(ll -1),promedio_muneca_y(ll - 1),U, V,'-','Color',colores(ll,:),'LineWidth',1.5,'MaxHeadSize', 1.5, 'AutoScale', 'off', 'AutoScaleFactor', 1.5)
plot(promedio_muneca_x(61, 1), promedio_muneca_y(61, 1), 'o', 'MarkerFaceColor', [0.8196    0.6431    0.4902], 'MarkerEdgeColor', [0.8196    0.6431    0.4902],'MarkerSize',15)
plot(promedio_muneca_x(61, 1) + 146, promedio_muneca_y(61, 1) - 142, 'o', 'MarkerFaceColor', [0.2902    0.3490    0.5098], 'MarkerEdgeColor', [0.2902    0.3490    0.5098],'MarkerSize',15)
end 

xlabel('Coordenada X'); %Convertir esto a mm
ylabel('Coordenada Y');
set(gca, 'XColor', 'none', 'YColor', 'none'); % Oculta los ejes
set(gca, 'PlotBoxAspectRatio', [1 1 1]);
xlim([500 800])
ylim([50 350])
title('Ejecución del movimeinto con 1000 ms de preparación');
cont_figura = cont_figura +1;

%Matriz de trayectorias (Intercalar las columnas corresponde a la
%taryectoria de la muneca)
trayec_1000 = table(muneca_x_general_1000,muneca_y_general_1000);

[velocidad_1000,velocidad_ensayos_1000,aceleracion_1000,aceleracion_ensayos_1000,duracion_1000] = velocidad_aceleracion(muneca_x_general_1000(frames_go_cue+1:end,:),muneca_y_general_1000(frames_go_cue+1:end,:),tiempo_1000(frames_go_cue+1:end));

% EJECUCION 1500 ms
frames_go_cue      = 0;
frames_retorno     = 16;
go_cue             = correcto_1500.Go_Cue_essay - frames_go_cue; %Aqui estoy restando 90 frames (posibilidad de 1500 ms que dura el estimulo) 
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
    matrix = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    muneca_x   = matrix(:,17); %Extraer solo la trayectoria de la muneca para reconstruir la trayectoria tiempo a tiempo
    muneca_y   = matrix(:,18);
    
    figure(cont_figura),
    set(gca, 'YDir', 'reverse')
    grid on 
    for kk = 2 : length(muneca_x)
    hold on
    plot([muneca_x(kk - 1), muneca_x(kk)], [muneca_y(kk - 1), muneca_y(kk)], '-','Color',[0.8000    0.8000    0.8000])
    end 
   
    muneca_x_general_1500(1:length(muneca_x), ii) = muneca_x;
    muneca_y_general_1500(1:length(muneca_y), ii) = muneca_y;
end 

promedio_muneca_x = mean(muneca_x_general_1500,2,'omitnan');
promedio_muneca_y = mean(muneca_y_general_1500,2,'omitnan');

%Obtener la posición del bebedero y de la barra
barra_1500    = [promedio_muneca_x(91, 1),promedio_muneca_y(91, 1)];
bebedero_1500 = [promedio_muneca_x(91, 1)+146,promedio_muneca_y(91, 1)-142];

% Definir colores para el gradiente
num_puntos = length(promedio_muneca_x);
colores    = [linspace(1, 0, num_puntos)', linspace(1, 0.4, num_puntos)', linspace(1, 0, num_puntos)'];

for ll = 2:length(promedio_muneca_x)
    U = promedio_muneca_x(ll) - promedio_muneca_x(ll - 1);
    V = promedio_muneca_y(ll) - promedio_muneca_y(ll - 1);
hold on
quiver(promedio_muneca_x(ll -1),promedio_muneca_y(ll - 1),U, V,'-','Color',colores(ll,:),'LineWidth',1.5,'MaxHeadSize', 1.5, 'AutoScale', 'off', 'AutoScaleFactor', 1.5)
plot(promedio_muneca_x(91, 1), promedio_muneca_y(91, 1), 'o', 'MarkerFaceColor', [0.8196    0.6431    0.4902], 'MarkerEdgeColor', [0.8196    0.6431    0.4902],'MarkerSize',15)
plot(promedio_muneca_x(91, 1) + 146, promedio_muneca_y(91, 1) - 142, 'o', 'MarkerFaceColor', [0.2902    0.3490    0.5098], 'MarkerEdgeColor', [0.2902    0.3490    0.5098],'MarkerSize',15)
end 

xlabel('Coordenada X'); %Convertir esto a mm
ylabel('Coordenada Y');
set(gca, 'XColor', 'none', 'YColor', 'none'); % Oculta los ejes
set(gca, 'PlotBoxAspectRatio', [1 1 1]);
xlim([500 800])
ylim([50 350])
title('Ejecución del movimeinto con 1500 ms de preparación');
cont_figura = cont_figura +1;

%Matriz de trayectorias (Intercalar las columnas corresponde a la
%taryectoria de la muneca)
trayec_1500 = table(muneca_x_general_1500,muneca_y_general_1500);

[velocidad_1500,velocidad_ensayos_1500,aceleracion_1500,aceleracion_ensayos_1500,duracion_1500] = velocidad_aceleracion(muneca_x_general_1500(frames_go_cue+1:end,:),muneca_y_general_1500(frames_go_cue+1:end,:),tiempo_1500(frames_go_cue+1:end));

%% ALCANCE DEL MOVIMIENTO

% ALCANCE 500 ms 
go_cue             = correcto_500.Go_Cue_essay; %Aqui estoy restando 30 frames (posibilidad de 500 ms que dura el estimulo) 
correcto           = correcto_500.Recompensa_essay;  
ventanas_alcance   = [go_cue correcto];
frames_totales     = ventanas_alcance(:,2)- ventanas_alcance(:,1);

%Definir la línea temporal (Alineacion con la senal Go)
tiempo_inicial     = 0;
tiempo_final       = frame_dur * (max(frames_totales));
tiempo_alcance_500 = -tiempo_inicial:frame_dur:tiempo_final;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_alcance_500   = NaN(max(frames_totales)+1,length(ventanas_alcance));
muneca_y_alcance_500   = NaN(max(frames_totales)+1,length(ventanas_alcance));

for ii = 1:length(ventanas_alcance)
    inicio = ventanas_alcance(ii,1);
    final  = ventanas_alcance(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix      = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    muneca_x    = matrix(:,17); %Extraer solo la trayectoria de la muneca para reconstruir la trayectoria tiempo a tiempo
    muneca_y    = matrix(:,18);
    
    figure(cont_figura),
    set(gca, 'YDir', 'reverse')
    grid on 
    for kk = 2 : length(muneca_x)
    hold on
    plot([muneca_x(kk - 1), muneca_x(kk)], [muneca_y(kk - 1), muneca_y(kk)],'Color',[0.6510    0.6510    0.6510])
    end 

    muneca_x_alcance_500(1:length(muneca_x), ii) = muneca_x; %POSIBLEMENTE ESTE ME INTERESE GUARDAR
    muneca_y_alcance_500(1:length(muneca_y), ii) = muneca_y;
 
end 

promedio_muneca_alcance_x   = mean(muneca_x_alcance_500,2,'omitnan');
promedio_muneca_alcance_y   = mean(muneca_y_alcance_500,2,'omitnan');

% Definir colores para el gradiente
num_puntos = length(promedio_muneca_alcance_x);
colores    = [linspace(1, 0, num_puntos)', linspace(1, 0.4, num_puntos)', linspace(1, 0, num_puntos)'];

for ll = 2:length(promedio_muneca_alcance_x)
    U = promedio_muneca_alcance_x(ll) - promedio_muneca_alcance_x(ll - 1);
    V = promedio_muneca_alcance_y(ll) - promedio_muneca_alcance_y(ll - 1);
hold on
quiver(promedio_muneca_alcance_x(ll -1),promedio_muneca_alcance_y(ll - 1),U, V,'-','Color',colores(ll,:),'LineWidth',1.5,'MaxHeadSize', 1.5, 'AutoScale', 'off', 'AutoScaleFactor', 1.5)
plot(promedio_muneca_alcance_x(1, 1), promedio_muneca_alcance_y(1, 1), 'o', 'MarkerFaceColor', [0.8196    0.6431    0.4902], 'MarkerEdgeColor', [0.8196    0.6431    0.4902],'MarkerSize',15)
plot(promedio_muneca_alcance_x(1, 1) + 146, promedio_muneca_alcance_y(1, 1) - 142, 'o', 'MarkerFaceColor', [0.2902    0.3490    0.5098], 'MarkerEdgeColor', [0.2902    0.3490    0.5098],'MarkerSize',15)
end 

xlabel('Coordenada X'); %Convertir esto a mm
ylabel('Coordenada Y');
set(gca, 'XColor', 'none', 'YColor', 'none'); % Oculta los ejes
set(gca, 'PlotBoxAspectRatio', [1 1 1]);
xlim([500 800])
ylim([50 350])
title('Alcance del movimiento con 500 ms de preparación');
cont_figura = cont_figura +1;

%Obtener la velocidad y aceleracion
[velocidad_alcance_500,velocidad_ensayos_alcance_500,aceleracion_alcance_500,aceleracion_ensayos_alcance_500,duracion_alcance_500] = velocidad_aceleracion(muneca_x_alcance_500,muneca_y_alcance_500,tiempo_alcance_500);

% ALCANCE 1000 ms 
go_cue             = correcto_1000.Go_Cue_essay; %Aqui estoy restando 30 frames (posibilidad de 500 ms que dura el estimulo) 
correcto           = correcto_1000.Recompensa_essay;  
ventanas_alcance   = [go_cue correcto];
frames_totales     = ventanas_alcance(:,2)- ventanas_alcance(:,1);

%Definir la línea temporal (Alineacion con la senal Go)
tiempo_inicial     = 0;
tiempo_final       = frame_dur * (max(frames_totales));
tiempo_alcance_1000 = -tiempo_inicial:frame_dur:tiempo_final;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_alcance_1000   = NaN(max(frames_totales)+1,length(ventanas_alcance));
muneca_y_alcance_1000   = NaN(max(frames_totales)+1,length(ventanas_alcance));

for ii = 1:length(ventanas_alcance)
    inicio = ventanas_alcance(ii,1);
    final  = ventanas_alcance(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix      = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    muneca_x    = matrix(:,17); %Extraer solo la trayectoria de la muneca para reconstruir la trayectoria tiempo a tiempo
    muneca_y    = matrix(:,18);
    
    figure(cont_figura),
    set(gca, 'YDir', 'reverse')
    grid on 
    for kk = 2 : length(muneca_x)
    hold on
    plot([muneca_x(kk - 1), muneca_x(kk)], [muneca_y(kk - 1), muneca_y(kk)],'Color',[0.6510    0.6510    0.6510])
    end 

    muneca_x_alcance_1000(1:length(muneca_x), ii) = muneca_x; %POSIBLEMENTE ESTE ME INTERESE GUARDAR
    muneca_y_alcance_1000(1:length(muneca_y), ii) = muneca_y;
 
end 

promedio_muneca_alcance_x   = mean(muneca_x_alcance_1000,2,'omitnan');
promedio_muneca_alcance_y   = mean(muneca_y_alcance_1000,2,'omitnan');

% Definir colores para el gradiente
num_puntos = length(promedio_muneca_alcance_x);
colores    = [linspace(1, 0, num_puntos)', linspace(1, 0.4, num_puntos)', linspace(1, 0, num_puntos)'];

for ll = 2:length(promedio_muneca_alcance_x)
    U = promedio_muneca_alcance_x(ll) - promedio_muneca_alcance_x(ll - 1);
    V = promedio_muneca_alcance_y(ll) - promedio_muneca_alcance_y(ll - 1);
hold on
quiver(promedio_muneca_alcance_x(ll -1),promedio_muneca_alcance_y(ll - 1),U, V,'-','Color',colores(ll,:),'LineWidth',1.5,'MaxHeadSize', 1.5, 'AutoScale', 'off', 'AutoScaleFactor', 1.5)
plot(promedio_muneca_alcance_x(1, 1), promedio_muneca_alcance_y(1, 1), 'o', 'MarkerFaceColor', [0.8196    0.6431    0.4902], 'MarkerEdgeColor', [0.8196    0.6431    0.4902],'MarkerSize',15)
plot(promedio_muneca_alcance_x(1, 1) + 146, promedio_muneca_alcance_y(1, 1) - 142, 'o', 'MarkerFaceColor', [0.2902    0.3490    0.5098], 'MarkerEdgeColor', [0.2902    0.3490    0.5098],'MarkerSize',15)
end 

xlabel('Coordenada X'); %Convertir esto a mm
ylabel('Coordenada Y');
set(gca, 'XColor', 'none', 'YColor', 'none'); % Oculta los ejes
set(gca, 'PlotBoxAspectRatio', [1 1 1]);
xlim([500 800])
ylim([50 350])
title('Alcance del movimiento con 1000 ms de preparación');
cont_figura = cont_figura +1;

%Obtener la velocidad y aceleracion
[velocidad_alcance_1000,velocidad_ensayos_alcance_1000,aceleracion_alcance_1000,aceleracion_ensayos_alcance_1000,duracion_alcance_1000] = velocidad_aceleracion(muneca_x_alcance_1000,muneca_y_alcance_1000,tiempo_alcance_1000);
 
% ALCANCE 1500 ms 
go_cue             = correcto_1500.Go_Cue_essay; %Aqui estoy restando 30 frames (posibilidad de 500 ms que dura el estimulo) 
correcto           = correcto_1500.Recompensa_essay;  
ventanas_alcance   = [go_cue correcto];
frames_totales     = ventanas_alcance(:,2)- ventanas_alcance(:,1);

%Definir la línea temporal (Alineacion con la senal Go)
tiempo_inicial     = 0;
tiempo_final       = frame_dur * (max(frames_totales));
tiempo_alcance_1500 = -tiempo_inicial:frame_dur:tiempo_final;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_alcance_1500   = NaN(max(frames_totales)+1,length(ventanas_alcance));
muneca_y_alcance_1500   = NaN(max(frames_totales)+1,length(ventanas_alcance));

for ii = 1:length(ventanas_alcance)
    inicio = ventanas_alcance(ii,1);
    final  = ventanas_alcance(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix      = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    muneca_x    = matrix(:,17); %Extraer solo la trayectoria de la muneca para reconstruir la trayectoria tiempo a tiempo
    muneca_y    = matrix(:,18);
    
    figure(cont_figura),
    set(gca, 'YDir', 'reverse')
    grid on 
    for kk = 2 : length(muneca_x)
    hold on
    plot([muneca_x(kk - 1), muneca_x(kk)], [muneca_y(kk - 1), muneca_y(kk)],'Color',[0.6510    0.6510    0.6510])
    end 

    muneca_x_alcance_1500(1:length(muneca_x), ii) = muneca_x; %POSIBLEMENTE ESTE ME INTERESE GUARDAR
    muneca_y_alcance_1500(1:length(muneca_y), ii) = muneca_y;
 
end 

promedio_muneca_alcance_x   = mean(muneca_x_alcance_1500,2,'omitnan');
promedio_muneca_alcance_y   = mean(muneca_y_alcance_1500,2,'omitnan');

% Definir colores para el gradiente
num_puntos = length(promedio_muneca_alcance_x);
colores    = [linspace(1, 0, num_puntos)', linspace(1, 0.4, num_puntos)', linspace(1, 0, num_puntos)'];

for ll = 2:length(promedio_muneca_alcance_x)
    U = promedio_muneca_alcance_x(ll) - promedio_muneca_alcance_x(ll - 1);
    V = promedio_muneca_alcance_y(ll) - promedio_muneca_alcance_y(ll - 1);
hold on
quiver(promedio_muneca_alcance_x(ll -1),promedio_muneca_alcance_y(ll - 1),U, V,'-','Color',colores(ll,:),'LineWidth',1.5,'MaxHeadSize', 1.5, 'AutoScale', 'off', 'AutoScaleFactor', 1.5)
plot(promedio_muneca_alcance_x(1, 1), promedio_muneca_alcance_y(1, 1), 'o', 'MarkerFaceColor', [0.8196    0.6431    0.4902], 'MarkerEdgeColor', [0.8196    0.6431    0.4902],'MarkerSize',15)
plot(promedio_muneca_alcance_x(1, 1) + 146, promedio_muneca_alcance_y(1, 1) - 142, 'o', 'MarkerFaceColor', [0.2902    0.3490    0.5098], 'MarkerEdgeColor', [0.2902    0.3490    0.5098],'MarkerSize',15)
end 

xlabel('Coordenada X'); %Convertir esto a mm
ylabel('Coordenada Y');
set(gca, 'XColor', 'none', 'YColor', 'none'); % Oculta los ejes
set(gca, 'PlotBoxAspectRatio', [1 1 1]);
xlim([500 800])
ylim([50 350])
title('Alcance del movimiento con 1500 ms de preparación');
cont_figura = cont_figura +1;

%Obtener la velocidad y aceleracion
[velocidad_alcance_1500,velocidad_ensayos_alcance_1500,aceleracion_alcance_1500,aceleracion_ensayos_alcance_1500,duracion_alcance_1500] = velocidad_aceleracion(muneca_x_alcance_1500,muneca_y_alcance_1500,tiempo_alcance_1500);


%% RETRONO
% RETORNO 500 ms 
correcto           = correcto_500.Recompensa_essay; 
retorno            = correcto_500.Recompensa_essay + 16; % se agregan 300 ms  
ventanas_retorno   = [correcto retorno];
frames_totales     = ventanas_retorno(:,2)- ventanas_retorno(:,1);

%Definir la línea temporal (Alineacion con la senal Go)
tiempo_inicial     = 0;
tiempo_final       = frame_dur * (max(frames_totales));
tiempo_retorno_500 = -tiempo_inicial:frame_dur:tiempo_final;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_retorno_500   = NaN(max(frames_totales)+1,length(ventanas_retorno));
muneca_y_retorno_500   = NaN(max(frames_totales)+1,length(ventanas_retorno));

for ii = 1:length(ventanas_retorno)
    inicio = ventanas_retorno(ii,1);
    final  = ventanas_retorno(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix      = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    muneca_x    = matrix(:,17); %Extraer solo la trayectoria de la muneca para reconstruir la trayectoria tiempo a tiempo
    muneca_y    = matrix(:,18);
    
    figure(cont_figura),
    set(gca, 'YDir', 'reverse')
    grid on 
    for kk = 2 : length(muneca_x)
    hold on
    plot([muneca_x(kk - 1), muneca_x(kk)], [muneca_y(kk - 1), muneca_y(kk)],'Color',[0.6510    0.6510    0.6510])
    end 

    muneca_x_retorno_500(1:length(muneca_x), ii) = muneca_x; %POSIBLEMENTE ESTE ME INTERESE GUARDAR
    muneca_y_retorno_500(1:length(muneca_y), ii) = muneca_y;
 
end 

promedio_muneca_retorno_x   = mean(muneca_x_retorno_500,2,'omitnan');
promedio_muneca_retorno_y   = mean(muneca_y_retorno_500,2,'omitnan');

% Definir colores para el gradiente
num_puntos = length(promedio_muneca_retorno_x);
colores    = [linspace(1, 0, num_puntos)', linspace(1, 0.4, num_puntos)', linspace(1, 0, num_puntos)'];

for ll = 2:length(promedio_muneca_retorno_x)
    U = promedio_muneca_retorno_x(ll) - promedio_muneca_retorno_x(ll - 1);
    V = promedio_muneca_retorno_y(ll) - promedio_muneca_retorno_y(ll - 1);
hold on
quiver(promedio_muneca_retorno_x(ll -1),promedio_muneca_retorno_y(ll - 1),U, V,'-','Color',colores(ll,:),'LineWidth',1.5,'MaxHeadSize', 1.5, 'AutoScale', 'off', 'AutoScaleFactor', 1.5)
plot(barra_500(1,1), barra_500(1,2), 'o', 'MarkerFaceColor', [0.8196    0.6431    0.4902], 'MarkerEdgeColor', [0.8196    0.6431    0.4902],'MarkerSize',15)
plot(bebedero_500(1,1), bebedero_500(1,2), 'o', 'MarkerFaceColor', [0.2902    0.3490    0.5098], 'MarkerEdgeColor', [0.2902    0.3490    0.5098],'MarkerSize',15)
end 

xlabel('Coordenada X'); %Convertir esto a mm
ylabel('Coordenada Y');
set(gca, 'XColor', 'none', 'YColor', 'none'); % Oculta los ejes
set(gca, 'PlotBoxAspectRatio', [1 1 1]);
xlim([500 800])
ylim([50 350])
title('Regreso del movimiento con 500 ms de preparación');
cont_figura = cont_figura +1;
 
%Obtener la velocidad y aceleracion
[velocidad_retorno_500,velocidad_ensayos_retorno_500,aceleracion_retorno_500,aceleracion_ensayos_retorno_500,duracion_retorno_500] = velocidad_aceleracion(muneca_x_retorno_500,muneca_y_retorno_500,tiempo_retorno_500);

% RETORNO 1000 ms 
correcto           = correcto_1000.Recompensa_essay; 
retorno            = correcto_1000.Recompensa_essay + 16; % se agregan 300 ms  
ventanas_retorno   = [correcto retorno];
frames_totales     = ventanas_retorno(:,2)- ventanas_retorno(:,1);

%Definir la línea temporal (Alineacion con la senal Go)
tiempo_inicial     = 0;
tiempo_final       = frame_dur * (max(frames_totales));
tiempo_retorno_1000 = -tiempo_inicial:frame_dur:tiempo_final;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_retorno_1000   = NaN(max(frames_totales)+1,length(ventanas_retorno));
muneca_y_retorno_1000   = NaN(max(frames_totales)+1,length(ventanas_retorno));

for ii = 1:length(ventanas_retorno)
    inicio = ventanas_retorno(ii,1);
    final  = ventanas_retorno(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix      = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    muneca_x    = matrix(:,17); %Extraer solo la trayectoria de la muneca para reconstruir la trayectoria tiempo a tiempo
    muneca_y    = matrix(:,18);
    
    figure(cont_figura),
    set(gca, 'YDir', 'reverse')
    grid on 
    for kk = 2 : length(muneca_x)
    hold on
    plot([muneca_x(kk - 1), muneca_x(kk)], [muneca_y(kk - 1), muneca_y(kk)],'Color',[0.6510    0.6510    0.6510])
    end 

    muneca_x_retorno_1000(1:length(muneca_x), ii) = muneca_x; %POSIBLEMENTE ESTE ME INTERESE GUARDAR
    muneca_y_retorno_1000(1:length(muneca_y), ii) = muneca_y;
 
end 

promedio_muneca_retorno_x   = mean(muneca_x_retorno_1000,2,'omitnan');
promedio_muneca_retorno_y   = mean(muneca_y_retorno_1000,2,'omitnan');

% Definir colores para el gradiente
num_puntos = length(promedio_muneca_retorno_x);
colores    = [linspace(1, 0, num_puntos)', linspace(1, 0.4, num_puntos)', linspace(1, 0, num_puntos)'];

for ll = 2:length(promedio_muneca_retorno_x)
    U = promedio_muneca_retorno_x(ll) - promedio_muneca_retorno_x(ll - 1);
    V = promedio_muneca_retorno_y(ll) - promedio_muneca_retorno_y(ll - 1);
hold on
quiver(promedio_muneca_retorno_x(ll -1),promedio_muneca_retorno_y(ll - 1),U, V,'-','Color',colores(ll,:),'LineWidth',1.5,'MaxHeadSize', 1.5, 'AutoScale', 'off', 'AutoScaleFactor', 1.5)
plot(barra_1000(1,1), barra_1000(1,2), 'o', 'MarkerFaceColor', [0.8196    0.6431    0.4902], 'MarkerEdgeColor', [0.8196    0.6431    0.4902],'MarkerSize',15)
plot(bebedero_1000(1, 1), bebedero_1500(1,2), 'o', 'MarkerFaceColor', [0.2902    0.3490    0.5098], 'MarkerEdgeColor', [0.2902    0.3490    0.5098],'MarkerSize',15)
end 

xlabel('Coordenada X'); %Convertir esto a mm
ylabel('Coordenada Y');
set(gca, 'XColor', 'none', 'YColor', 'none'); % Oculta los ejes
set(gca, 'PlotBoxAspectRatio', [1 1 1]);
xlim([500 800])
ylim([50 350])
title('Regreso del movimiento con 1000 ms de preparación');
cont_figura = cont_figura +1;

%Obtener la velocidad y aceleracion
[velocidad_retorno_1000,velocidad_ensayos_retorno_1000,aceleracion_retorno_1000,aceleracion_ensayos_retorno_1000,duracion_retorno_1000] = velocidad_aceleracion(muneca_x_retorno_1000,muneca_y_retorno_1000,tiempo_retorno_1000);
 
% RETORNO 1500 ms 
correcto           = correcto_1500.Recompensa_essay; 
retorno            = correcto_1500.Recompensa_essay + 16; % se agregan 300 ms  
ventanas_retorno   = [correcto retorno];
frames_totales     = ventanas_retorno(:,2)- ventanas_retorno(:,1);

%Definir la línea temporal (Alineacion con la senal Go)
tiempo_inicial     = 0;
tiempo_final       = frame_dur * (max(frames_totales));
tiempo_retorno_1500 = -tiempo_inicial:frame_dur:tiempo_final;

%Crear una matriz general de la trayectoria de la muneca
muneca_x_retorno_1500   = NaN(max(frames_totales)+1,length(ventanas_retorno));
muneca_y_retorno_1500   = NaN(max(frames_totales)+1,length(ventanas_retorno));

for ii = 1:length(ventanas_retorno)
    inicio = ventanas_retorno(ii,1);
    final  = ventanas_retorno(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix      = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    muneca_x    = matrix(:,17); %Extraer solo la trayectoria de la muneca para reconstruir la trayectoria tiempo a tiempo
    muneca_y    = matrix(:,18);
    
    figure(cont_figura),
    set(gca, 'YDir', 'reverse')
    grid on 
    for kk = 2 : length(muneca_x)
    hold on
    plot([muneca_x(kk - 1), muneca_x(kk)], [muneca_y(kk - 1), muneca_y(kk)],'Color',[0.6510    0.6510    0.6510])
    end 

    muneca_x_retorno_1500(1:length(muneca_x), ii) = muneca_x; %POSIBLEMENTE ESTE ME INTERESE GUARDAR
    muneca_y_retorno_1500(1:length(muneca_y), ii) = muneca_y;
 
end 

promedio_muneca_retorno_x   = mean(muneca_x_retorno_1500,2,'omitnan');
promedio_muneca_retorno_y   = mean(muneca_y_retorno_1500,2,'omitnan');

% Definir colores para el gradiente
num_puntos = length(promedio_muneca_retorno_x);
colores    = [linspace(1, 0, num_puntos)', linspace(1, 0.4, num_puntos)', linspace(1, 0, num_puntos)'];

for ll = 2:length(promedio_muneca_retorno_x)
    U = promedio_muneca_retorno_x(ll) - promedio_muneca_retorno_x(ll - 1);
    V = promedio_muneca_retorno_y(ll) - promedio_muneca_retorno_y(ll - 1);
hold on
quiver(promedio_muneca_retorno_x(ll -1),promedio_muneca_retorno_y(ll - 1),U, V,'-','Color',colores(ll,:),'LineWidth',1.5,'MaxHeadSize', 1.5, 'AutoScale', 'off', 'AutoScaleFactor', 1.5)
plot(barra_1500(1,1), barra_1500(1,2), 'o', 'MarkerFaceColor', [0.8196    0.6431    0.4902], 'MarkerEdgeColor', [0.8196    0.6431    0.4902],'MarkerSize',15)
plot(bebedero_1500(1,1), bebedero_1500(1,2), 'o', 'MarkerFaceColor', [0.2902    0.3490    0.5098], 'MarkerEdgeColor', [0.2902    0.3490    0.5098],'MarkerSize',15)
end 

xlabel('Coordenada X'); %Convertir esto a mm
ylabel('Coordenada Y');
set(gca, 'XColor', 'none', 'YColor', 'none'); % Oculta los ejes
set(gca, 'PlotBoxAspectRatio', [1 1 1]);
xlim([500 800])
ylim([50 350])
title('Regreso del movimiento con 1500 ms de preparación');
cont_figura = cont_figura +1;

%Obtener la velocidad y aceleracion
[velocidad_retorno_1500,velocidad_ensayos_retorno_1500,aceleracion_retorno_1500,aceleracion_ensayos_retorno_1500,duracion_retorno_1500] = velocidad_aceleracion(muneca_x_retorno_1500,muneca_y_retorno_1500,tiempo_retorno_1500);

%Crear la tabla con la información
[tabla_cinematica]         = cinematica_rt(correcto_500,correcto_1000,correcto_1500,duracion_500,tiempo_reaccion_500,velocidad_ensayos_500,aceleracion_ensayos_500,duracion_1000,tiempo_reaccion_1000,velocidad_ensayos_1000,aceleracion_ensayos_1000,duracion_1500,tiempo_reaccion_1500,velocidad_ensayos_1500,aceleracion_ensayos_1500);
[tabla_cinematica_alcance] = cinematica(correcto_500,correcto_1000,correcto_1500,duracion_alcance_500,velocidad_ensayos_alcance_500,aceleracion_ensayos_alcance_500,duracion_alcance_1000,velocidad_ensayos_alcance_1000,aceleracion_ensayos_alcance_1000,duracion_alcance_1500,velocidad_ensayos_alcance_1500,aceleracion_ensayos_alcance_1500);
[tabla_cinematica_retorno] = cinematica(correcto_500,correcto_1000,correcto_1500,duracion_retorno_500,velocidad_ensayos_retorno_500,aceleracion_ensayos_retorno_500,duracion_retorno_1000,velocidad_ensayos_retorno_1000,aceleracion_ensayos_retorno_1000,duracion_retorno_1500,velocidad_ensayos_retorno_1500,aceleracion_ensayos_retorno_1500);
end 






