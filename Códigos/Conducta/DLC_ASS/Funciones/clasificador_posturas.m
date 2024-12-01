% FUNCION PARA CLASIFICAR ENSAYOS 
% Funcion que va a alinear los archivos de DLC con los ASS conductuales
% para clasificarlos en los ensayos de 500, 1000 y 1500 ms de preparación y
% sacar las posturas promedio por ensayo de cada una de la fases

function [plan_500,plan_1000,plan_1500,ejec_500,ejec_1000,ejec_1500,correcto_out_500,correcto_out_1000,correcto_out_1500] = clasificador_posturas(correcto_500,correcto_1000,correcto_1500,dlc_matrix,umbral_barra,umbral_bebedero,umbral_actividad)


%% FASE PLANEACION

% Ensayos 500ms de sosten de barra %

sosten_barra        = correcto_500.Go_Cue_essay - 30; %Aqui estoy restando 90 frames (posibilidad de 1500 ms que dura el estimulo) 
senal_go            = correcto_500.Go_Cue_essay;
ventanas_planeacion = [sosten_barra senal_go];


%Realizar los graficos de planeacion recortando los eventos del dlc 
esqueleto_completo_x = NaN(length(ventanas_planeacion),9);
esqueleto_completo_y = NaN(length(ventanas_planeacion),9);

for ii = 1:size(ventanas_planeacion,1)
    inicio = ventanas_planeacion(ii,1);
    final  = ventanas_planeacion(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    [esqueleto_x, esqueleto_y] = extraccion_postural_planeacion(matrix,umbral_barra);
    esqueleto_completo_x(ii,1:length(esqueleto_x)) = esqueleto_x;
    esqueleto_completo_y(ii,1:length(esqueleto_y)) = esqueleto_y;

end

% Sacar outliers de las trayectorias con base a hombro, codo y muneca
[esqueleto_general_x, esqueleto_general_y,correcto_out_500] = outliers(esqueleto_completo_x,esqueleto_completo_y,correcto_500,umbral_actividad);

bocaX    = esqueleto_general_x(:,1);
bocaY    = esqueleto_general_y(:,1);
hombroX  = esqueleto_general_x(:,2);
hombroY  = esqueleto_general_y(:,2);
codoX    = esqueleto_general_x(:,3);
codoY    = esqueleto_general_y(:,3);
munecaX  = esqueleto_general_x(:,4);
munecaY  = esqueleto_general_y(:,4);
centroX  = esqueleto_general_x(:,5);
centroY  = esqueleto_general_y(:,5);
segundoX = esqueleto_general_x(:,6);
segundoY = esqueleto_general_y(:,6);
terceroX = esqueleto_general_x(:,7);
terceroY = esqueleto_general_y(:,7);
cuartoX  = esqueleto_general_x(:,8);
cuartoY  = esqueleto_general_y(:,8);
quintoX  = esqueleto_general_x(:,9);
quintoY  = esqueleto_general_y(:,9);

figure, clf
axis equal
set(gca, 'YDir', 'reverse')
n = length(esqueleto_general_x);  % Número de ensayos
gradiente = linspace(0.5, 1, n)';  % Gradiente de color entre 0.5 (más claro) y 1 (más oscuro)
grid on
for kk = 1:size(esqueleto_general_x,1)
    hold on

    % Aplicar el gradiente de intensidad a cada color específico
    color_hombro = [gradiente(kk), 0, 0];  % Rojo para el hombro
    color_codo = [0, gradiente(kk), 0];    % Verde para el codo
    color_muneca = [0, 0, gradiente(kk)];  % Azul para la muñeca
    color_linea = [gradiente(kk), gradiente(kk), gradiente(kk)];

    plot(hombroX(kk), hombroY(kk), 'o', 'Color', color_hombro, 'MarkerFaceColor', color_hombro,'MarkerSize', 14, 'DisplayName', 'Hombro')
    plot(codoX(kk), codoY(kk), 'o', 'Color', color_codo, 'MarkerFaceColor', color_codo,'MarkerSize', 12,'DisplayName', 'Codo')
    plot(munecaX(kk), munecaY(kk), 'o', 'Color', color_muneca, 'MarkerFaceColor', color_muneca,'MarkerSize', 10, 'DisplayName', 'Muñeca')

    % Unir los puntos con líneas
    plot([hombroX(kk), codoX(kk)], [hombroY(kk), codoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Hombro a Codo');
    plot([codoX(kk), munecaX(kk)], [codoY(kk), munecaY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Codo a Muñeca');
end
legend('Hombro','Codo','Muñeca','Location','southwest')
xlabel('Coordenada X')
ylabel('Coordenada Y')
xticks(450:25:700)
yticks(125:25:350)
xticklabels(0:25:225)
yticklabels(0:25:225)
xlim([450 700])
ylim([125 375])
title('Fase planeación 500 ms (Ensayos correctos)');

%Matriz esqueleto postural (Intercalar las columnas corresponde a cada uno
%de los puntos asignados en DLC (Hombro, Codo, Muneca)
plan_500 = table(bocaX,bocaY,hombroX,hombroY,codoX,codoY,munecaX,munecaY,centroX,centroY,segundoX,segundoY,terceroX,terceroY,cuartoX,cuartoY,quintoX,quintoY);

% Ensayos 1000ms de sosten de barra %

%Fase de planeacion
sosten_barra        = correcto_1000.Go_Cue_essay - 60; %Aqui estoy restando 60 frames (posibilidad de 1000 ms que dura el estimulo) 
senal_go            = correcto_1000.Go_Cue_essay;
ventanas_planeacion = [sosten_barra senal_go];


%Realizar los graficos de planeacion recortando los eventos del dlc 
esqueleto_completo_x = NaN(length(ventanas_planeacion),9);
esqueleto_completo_y = NaN(length(ventanas_planeacion),9);

for ii = 1:size(ventanas_planeacion,1)
    inicio = ventanas_planeacion(ii,1);
    final  = ventanas_planeacion(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    [esqueleto_x, esqueleto_y] = extraccion_postural_planeacion(matrix,umbral_barra);
    esqueleto_completo_x(ii,1:length(esqueleto_x)) = esqueleto_x;
    esqueleto_completo_y(ii,1:length(esqueleto_y)) = esqueleto_y;

end 

% Sacar outliers de las trayectorias con base a hombro, codo y muneca
[esqueleto_general_x, esqueleto_general_y,correcto_out_1000] = outliers(esqueleto_completo_x,esqueleto_completo_y,correcto_1000,umbral_actividad);

bocaX   = esqueleto_general_x(:,1);
bocaY   = esqueleto_general_y(:,1);
hombroX = esqueleto_general_x(:,2);
hombroY = esqueleto_general_y(:,2);
codoX   = esqueleto_general_x(:,3);
codoY   = esqueleto_general_y(:,3);
munecaX = esqueleto_general_x(:,4);
munecaY = esqueleto_general_y(:,4);
centroX = esqueleto_general_x(:,5);
centroY = esqueleto_general_y(:,5);
segundoX = esqueleto_general_x(:,6);
segundoY = esqueleto_general_y(:,6);
terceroX = esqueleto_general_x(:,7);
terceroY = esqueleto_general_y(:,7);
cuartoX = esqueleto_general_x(:,8);
cuartoY = esqueleto_general_y(:,8);
quintoX = esqueleto_general_x(:,9);
quintoY = esqueleto_general_y(:,9);

figure, clf
set(gca, 'YDir', 'reverse')
axis equal
n = length(esqueleto_general_x);  % Número de ensayos
gradiente = linspace(0.5, 1, n)';  % Gradiente de color entre 0.5 (más claro) y 1 (más oscuro)
grid on
for kk = 1:size(esqueleto_general_x,1)
    hold on

    % Aplicar el gradiente de intensidad a cada color específico
    color_hombro = [gradiente(kk), 0, 0];  % Rojo para el hombro
    color_codo = [0, gradiente(kk), 0];    % Verde para el codo
    color_muneca = [0, 0, gradiente(kk)];  % Azul para la muñeca
    color_linea = [gradiente(kk), gradiente(kk), gradiente(kk)];

    plot(hombroX(kk), hombroY(kk), 'o', 'Color', color_hombro, 'MarkerFaceColor', color_hombro,'MarkerSize', 14, 'DisplayName', 'Hombro')
    plot(codoX(kk), codoY(kk), 'o', 'Color', color_codo, 'MarkerFaceColor', color_codo,'MarkerSize', 12,'DisplayName', 'Codo')
    plot(munecaX(kk), munecaY(kk), 'o', 'Color', color_muneca, 'MarkerFaceColor', color_muneca,'MarkerSize', 10, 'DisplayName', 'Muñeca')
    
    % Unir los puntos con líneas
    plot([hombroX(kk), codoX(kk)], [hombroY(kk), codoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Hombro a Codo');
    plot([codoX(kk), munecaX(kk)], [codoY(kk), munecaY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Codo a Muñeca');
end
legend('Hombro','Codo','Muñeca','Location','southwest')
xlabel('Coordenada X')
ylabel('Coordenada Y')
xticks(450:25:700)
yticks(125:25:350)
xticklabels(0:25:225)
yticklabels(0:25:225)
xlim([450 700])
ylim([125 375])
title('Fase planeación 1000 ms (Ensayos correctos)');

%Matriz esqueleto postural (Intercalar las columnas corresponde a cada uno
%de los puntos asignados en DLC (Hombro, Codo, Muneca)
plan_1000 = table(bocaX,bocaY,hombroX,hombroY,codoX,codoY,munecaX,munecaY,centroX,centroY,segundoX,segundoY,terceroX,terceroY,cuartoX,cuartoY,quintoX,quintoY);

% Ensayos 1500ms de sosten de barra %

%Fase de planeacion
sosten_barra        = correcto_1500.Go_Cue_essay - 90; %Aqui estoy restando 90 frames (posibilidad de 1500 ms que dura el estimulo) 
senal_go            = correcto_1500.Go_Cue_essay;
ventanas_planeacion = [sosten_barra senal_go];


%Realizar los graficos de planeacion recortando los eventos del dlc 
esqueleto_completo_x = NaN(length(ventanas_planeacion),9);
esqueleto_completo_y = NaN(length(ventanas_planeacion),9);

for ii = 1:size(ventanas_planeacion,1)
    inicio = ventanas_planeacion(ii,1);
    final  = ventanas_planeacion(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    [esqueleto_x, esqueleto_y] = extraccion_postural_planeacion(matrix,umbral_barra);
    esqueleto_completo_x(ii,1:length(esqueleto_x)) = esqueleto_x;
    esqueleto_completo_y(ii,1:length(esqueleto_y)) = esqueleto_y;

end 

% Sacar outliers de las trayectorias con base a hombro, codo y muneca
[esqueleto_general_x, esqueleto_general_y,correcto_out_1500] = outliers(esqueleto_completo_x,esqueleto_completo_y,correcto_1500,umbral_actividad);

bocaX   = esqueleto_general_x(:,1);
bocaY   = esqueleto_general_y(:,1);
hombroX = esqueleto_general_x(:,2);
hombroY = esqueleto_general_y(:,2);
codoX   = esqueleto_general_x(:,3);
codoY   = esqueleto_general_y(:,3);
munecaX = esqueleto_general_x(:,4);
munecaY = esqueleto_general_y(:,4);
centroX = esqueleto_general_x(:,5);
centroY = esqueleto_general_y(:,5);
segundoX = esqueleto_general_x(:,6);
segundoY = esqueleto_general_y(:,6);
terceroX = esqueleto_general_x(:,7);
terceroY = esqueleto_general_y(:,7);
cuartoX = esqueleto_general_x(:,8);
cuartoY = esqueleto_general_y(:,8);
quintoX = esqueleto_general_x(:,9);
quintoY = esqueleto_general_y(:,9);

figure, clf
axis equal
set(gca, 'YDir', 'reverse')
n = length(esqueleto_general_x);  % Número de ensayos
gradiente = linspace(0.5, 1, n)';  % Gradiente de color entre 0.5 (más claro) y 1 (más oscuro)
grid on
for kk = 1:size(esqueleto_general_x,1)
    hold on

    % Aplicar el gradiente de intensidad a cada color específico
    color_hombro = [gradiente(kk), 0, 0];  % Rojo para el hombro
    color_codo = [0, gradiente(kk), 0];    % Verde para el codo
    color_muneca = [0, 0, gradiente(kk)];  % Azul para la muñeca
    color_linea = [gradiente(kk), gradiente(kk), gradiente(kk)];

    plot(hombroX(kk), hombroY(kk), 'o', 'Color', color_hombro, 'MarkerFaceColor', color_hombro,'MarkerSize', 14, 'DisplayName', 'Hombro')
    plot(codoX(kk), codoY(kk), 'o', 'Color', color_codo, 'MarkerFaceColor', color_codo,'MarkerSize', 12,'DisplayName', 'Codo')
    plot(munecaX(kk), munecaY(kk), 'o', 'Color', color_muneca, 'MarkerFaceColor', color_muneca,'MarkerSize', 10, 'DisplayName', 'Muñeca')

    % Unir los puntos con líneas
    plot([hombroX(kk), codoX(kk)], [hombroY(kk), codoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Hombro a Codo');
    plot([codoX(kk), munecaX(kk)], [codoY(kk), munecaY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Codo a Muñeca');
end
legend('Hombro','Codo','Muñeca','Location','southwest')
xlabel('Coordenada X')
ylabel('Coordenada Y')
xticks(450:25:700)
yticks(125:25:350)
xticklabels(0:25:225)
yticklabels(0:25:225)
xlim([450 700])
ylim([125 375])
title('Fase planeación 1500 ms (Ensayos correctos)');

%Matriz esqueleto postural (Intercalar las columnas corresponde a cada uno
%de los puntos asignados en DLC (Hombro, Codo, Muneca)
plan_1500 = table(bocaX,bocaY,hombroX,hombroY,codoX,codoY,munecaX,munecaY,centroX,centroY,segundoX,segundoY,terceroX,terceroY,cuartoX,cuartoY,quintoX,quintoY);

%% FASE EJECUCION
% Ensayos 500ms de sosten de barra %

inicio_corr         = correcto_out_500.Go_Cue_essay; %Iniciar de la señal GO para agarrar la primer ida
correcto            = correcto_out_500.Recompensa_essay + 30; 
ventanas_ejecucion  = [inicio_corr correcto];

%Realizar los graficos de planeacion recortando los eventos del dlc 
esqueleto_completo_x = NaN(length(ventanas_ejecucion),9);
esqueleto_completo_y = NaN(length(ventanas_ejecucion),9);

for ii = 1:size(ventanas_ejecucion,1)
    inicio = ventanas_ejecucion(ii,1);
    final  = ventanas_ejecucion(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    [esqueleto_x, esqueleto_y] = extraccion_postural_ejecucion(matrix,umbral_barra,umbral_bebedero);
    esqueleto_completo_x(ii,1:length(esqueleto_x)) = esqueleto_x;
    esqueleto_completo_y(ii,1:length(esqueleto_y)) = esqueleto_y;

end 

% Sacar outliers de las trayectorias con base a hombro, codo y muneca
[esqueleto_general_x, esqueleto_general_y,correcto_out_500] = outliers(esqueleto_completo_x,esqueleto_completo_y,correcto_out_500,umbral_actividad);

bocaX   = esqueleto_general_x(:,1);
bocaY   = esqueleto_general_y(:,1);
hombroX = esqueleto_general_x(:,2);
hombroY = esqueleto_general_y(:,2);
codoX   = esqueleto_general_x(:,3);
codoY   = esqueleto_general_y(:,3);
munecaX = esqueleto_general_x(:,4);
munecaY = esqueleto_general_y(:,4);
centroX = esqueleto_general_x(:,5);
centroY = esqueleto_general_y(:,5);
segundoX = esqueleto_general_x(:,6);
segundoY = esqueleto_general_y(:,6);
terceroX = esqueleto_general_x(:,7);
terceroY = esqueleto_general_y(:,7);
cuartoX = esqueleto_general_x(:,8);
cuartoY = esqueleto_general_y(:,8);
quintoX = esqueleto_general_x(:,9);
quintoY = esqueleto_general_y(:,9);

figure, clf
axis equal
set(gca, 'YDir', 'reverse')
n = length(esqueleto_general_x);  % Número de ensayos
gradiente = linspace(0.5, 1, n)';  % Gradiente de color entre 0.5 (más claro) y 1 (más oscuro)
grid on
for kk = 1:size(esqueleto_general_x,1)
    hold on

    % Aplicar el gradiente de intensidad a cada color específico
    color_hombro = [gradiente(kk), 0, 0];  % Rojo para el hombro
    color_codo = [0, gradiente(kk), 0];    % Verde para el codo
    color_muneca = [0, 0, gradiente(kk)];  % Azul para la muñeca
    color_centro = [0.5 * gradiente(kk), 0.5 * gradiente(kk), 0.5 * gradiente(kk)];  % Gris para el centro de la mano
    color_segundo = [gradiente(kk), 0.5 * gradiente(kk), 0];     % Naranja para el segundo dedo
    color_tercero = [0.5 * gradiente(kk), 0, 0.5 * gradiente(kk)];   % Púrpura para el tercer dedo
    color_cuarto = [0, gradiente(kk), gradiente(kk)];        % Cian para el cuarto dedo
    color_quinto = [gradiente(kk), gradiente(kk), 0];        % Amarillo para el quinto dedo
    color_linea = [gradiente(kk), gradiente(kk), gradiente(kk)];

    plot(hombroX(kk), hombroY(kk), 'o', 'Color', color_hombro, 'MarkerFaceColor', color_hombro,'MarkerSize', 14, 'DisplayName', 'Hombro')
    plot(codoX(kk), codoY(kk), 'o', 'Color', color_codo, 'MarkerFaceColor', color_codo,'MarkerSize', 12,'DisplayName', 'Codo')
    plot(munecaX(kk), munecaY(kk), 'o', 'Color', color_muneca, 'MarkerFaceColor', color_muneca,'MarkerSize', 10, 'DisplayName', 'Muñeca')
    plot(centroX(kk), centroY(kk), 'o', 'Color', color_centro, 'MarkerFaceColor', color_centro,'MarkerSize', 8, 'DisplayName', 'Centro de la mano')
    plot(segundoX(kk), segundoY(kk), 'o', 'Color', color_segundo, 'MarkerFaceColor', color_segundo,'MarkerSize', 6, 'DisplayName', 'Segundo dedo')
    plot(terceroX(kk), terceroY(kk), 'o', 'Color', color_tercero, 'MarkerFaceColor', color_tercero,'MarkerSize', 6, 'DisplayName', 'Tercer dedo')
    plot(cuartoX(kk), cuartoY(kk), 'o', 'Color', color_cuarto, 'MarkerFaceColor', color_cuarto,'MarkerSize', 6, 'DisplayName', 'Cuarto dedo')
    plot(quintoX(kk), quintoY(kk), 'o', 'Color', color_quinto, 'MarkerFaceColor', color_quinto,'MarkerSize', 6, 'DisplayName', 'Quinto dedo')

    % Unir los puntos con líneas
    plot([hombroX(kk), codoX(kk)], [hombroY(kk), codoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Hombro a Codo');
    plot([codoX(kk), munecaX(kk)], [codoY(kk), munecaY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Codo a Muñeca');
    plot([munecaX(kk), centroX(kk)], [munecaY(kk), centroY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Muñeca a Centro de la mano');
    plot([centroX(kk), segundoX(kk)], [centroY(kk), segundoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Centro de la mano a segundo dedo');
    plot([centroX(kk), terceroX(kk)], [centroY(kk), terceroY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Centro de la mano a tercer dedo');
    plot([centroX(kk), cuartoX(kk)], [centroY(kk), cuartoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Centro de la mano a cuarto dedo');
    plot([centroX(kk), quintoX(kk)], [centroY(kk), quintoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Centro de la mano a quinto dedo');

end
legend('Hombro','Codo','Muñeca','Location','southwest')
xlabel('Coordenada X');
ylabel('Coordenada Y');
xticks(475:25:850)
yticks(50:25:425)
xticklabels(0:25:375)
yticklabels(0:25:375)
xlim([475 850])
ylim([50 300])
title('Fase ejecución 500 ms (Ensayos correctos)');

%Matriz esqueleto postural (Intercalar las columnas corresponde a cada uno
%de los puntos asignados en DLC (Hombro, Codo, Muneca)
ejec_500 = table(bocaX,bocaY,hombroX,hombroY,codoX,codoY,munecaX,munecaY,centroX,centroY,segundoX,segundoY,terceroX,terceroY,cuartoX,cuartoY,quintoX,quintoY);

% Ensayos 1000ms de sosten de barra %

%Fase de ejecucion
inicio_corr         = correcto_out_1000.Go_Cue_essay; %Quite dos frames 
correcto            = correcto_out_1000.Recompensa_essay + 30; 
ventanas_ejecucion = [inicio_corr correcto];


%Realizar los graficos de planeacion recortando los eventos del dlc 
esqueleto_completo_x = NaN(length(ventanas_ejecucion),9);
esqueleto_completo_y = NaN(length(ventanas_ejecucion),9);

for ii = 1:size(ventanas_ejecucion,1)
    inicio = ventanas_ejecucion(ii,1);
    final  = ventanas_ejecucion(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    [esqueleto_x, esqueleto_y] = extraccion_postural_ejecucion(matrix,umbral_barra,umbral_bebedero);
    esqueleto_completo_x(ii,1:length(esqueleto_x)) = esqueleto_x;
    esqueleto_completo_y(ii,1:length(esqueleto_y)) = esqueleto_y;

end 

% Sacar outliers de las trayectorias con base a hombro, codo y muneca
[esqueleto_general_x, esqueleto_general_y,correcto_out_1000] = outliers(esqueleto_completo_x,esqueleto_completo_y,correcto_out_1000,umbral_actividad);

bocaX   = esqueleto_general_x(:,1);
bocaY   = esqueleto_general_y(:,1);
hombroX = esqueleto_general_x(:,2);
hombroY = esqueleto_general_y(:,2);
codoX   = esqueleto_general_x(:,3);
codoY   = esqueleto_general_y(:,3);
munecaX = esqueleto_general_x(:,4);
munecaY = esqueleto_general_y(:,4);
centroX = esqueleto_general_x(:,5);
centroY = esqueleto_general_y(:,5);
segundoX = esqueleto_general_x(:,6);
segundoY = esqueleto_general_y(:,6);
terceroX = esqueleto_general_x(:,7);
terceroY = esqueleto_general_y(:,7);
cuartoX = esqueleto_general_x(:,8);
cuartoY = esqueleto_general_y(:,8);
quintoX = esqueleto_general_x(:,9);
quintoY = esqueleto_general_y(:,9);

figure, clf
axis equal
set(gca, 'YDir', 'reverse')
n = length(esqueleto_general_x);  % Número de ensayos
gradiente = linspace(0.5, 1, n)';  % Gradiente de color entre 0.5 (más claro) y 1 (más oscuro)
grid on
for kk = 1:size(esqueleto_general_x,1)
    hold on

    % Aplicar el gradiente de intensidad a cada color específico
    color_hombro = [gradiente(kk), 0, 0];  % Rojo para el hombro
    color_codo = [0, gradiente(kk), 0];    % Verde para el codo
    color_muneca = [0, 0, gradiente(kk)];  % Azul para la muñeca
    color_centro = [0.5 * gradiente(kk), 0.5 * gradiente(kk), 0.5 * gradiente(kk)];  % Gris para el centro de la mano
    color_segundo = [gradiente(kk), 0.5 * gradiente(kk), 0];     % Naranja para el segundo dedo
    color_tercero = [0.5 * gradiente(kk), 0, 0.5 * gradiente(kk)];   % Púrpura para el tercer dedo
    color_cuarto = [0, gradiente(kk), gradiente(kk)];        % Cian para el cuarto dedo
    color_quinto = [gradiente(kk), gradiente(kk), 0];        % Amarillo para el quinto dedo
    color_linea = [gradiente(kk), gradiente(kk), gradiente(kk)];

    plot(hombroX(kk), hombroY(kk), 'o', 'Color', color_hombro, 'MarkerFaceColor', color_hombro,'MarkerSize', 14, 'DisplayName', 'Hombro')
    plot(codoX(kk), codoY(kk), 'o', 'Color', color_codo, 'MarkerFaceColor', color_codo,'MarkerSize', 12,'DisplayName', 'Codo')
    plot(munecaX(kk), munecaY(kk), 'o', 'Color', color_muneca, 'MarkerFaceColor', color_muneca,'MarkerSize', 10, 'DisplayName', 'Muñeca')
    plot(centroX(kk), centroY(kk), 'o', 'Color', color_centro, 'MarkerFaceColor', color_centro,'MarkerSize', 8, 'DisplayName', 'Centro de la mano')
    plot(segundoX(kk), segundoY(kk), 'o', 'Color', color_segundo, 'MarkerFaceColor', color_segundo,'MarkerSize', 6, 'DisplayName', 'Segundo dedo')
    plot(terceroX(kk), terceroY(kk), 'o', 'Color', color_tercero, 'MarkerFaceColor', color_tercero,'MarkerSize', 6, 'DisplayName', 'Tercer dedo')
    plot(cuartoX(kk), cuartoY(kk), 'o', 'Color', color_cuarto, 'MarkerFaceColor', color_cuarto,'MarkerSize', 6, 'DisplayName', 'Cuarto dedo')
    plot(quintoX(kk), quintoY(kk), 'o', 'Color', color_quinto, 'MarkerFaceColor', color_quinto,'MarkerSize', 6, 'DisplayName', 'Quinto dedo')

    % Unir los puntos con líneas
    plot([hombroX(kk), codoX(kk)], [hombroY(kk), codoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Hombro a Codo');
    plot([codoX(kk), munecaX(kk)], [codoY(kk), munecaY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Codo a Muñeca');
    plot([munecaX(kk), centroX(kk)], [munecaY(kk), centroY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Muñeca a Centro de la mano');
    plot([centroX(kk), segundoX(kk)], [centroY(kk), segundoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Centro de la mano a segundo dedo');
    plot([centroX(kk), terceroX(kk)], [centroY(kk), terceroY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Centro de la mano a tercer dedo');
    plot([centroX(kk), cuartoX(kk)], [centroY(kk), cuartoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Centro de la mano a cuarto dedo');
    plot([centroX(kk), quintoX(kk)], [centroY(kk), quintoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Centro de la mano a quinto dedo');

end
%legend({'Shoulder','Elbow','Wrist',"Center of the hand","2nd","3rd", "4th", "5th"},'Location','northwest')
xlabel('Coordenada X')
ylabel('Coordenada Y')
xticks(475:25:850)
yticks(50:25:425)
xticklabels(0:25:375)
yticklabels(0:25:375)
xlim([475 850])
ylim([50 300])
title('Fase ejecución 1000 ms (Ensayos correctos)');

%Matriz esqueleto postural (Intercalar las columnas corresponde a cada uno
%de los puntos asignados en DLC (Hombro, Codo, Muneca)
ejec_1000 = table(bocaX,bocaY,hombroX,hombroY,codoX,codoY,munecaX,munecaY,centroX,centroY,segundoX,segundoY,terceroX,terceroY,cuartoX,cuartoY,quintoX,quintoY);

% Ensayos 1500ms de sosten de barra %

%Fase de planeacion
inicio_corr         = correcto_out_1500.Go_Cue_essay; %Quite dos frames 
correcto            = correcto_out_1500.Recompensa_essay + 30; 
ventanas_ejecucion = [inicio_corr correcto];

%Realizar los graficos de planeacion recortando los eventos del dlc 
esqueleto_completo_x = NaN(length(ventanas_ejecucion),9);
esqueleto_completo_y = NaN(length(ventanas_ejecucion),9);

for ii = 1:size(ventanas_ejecucion,1)
    inicio = ventanas_ejecucion(ii,1);
    final  = ventanas_ejecucion(ii,2);

    %Extraer el fragmento de dlc_matrix
    matrix = dlc_matrix(inicio:final,:); %Vamos a extraer toda la informacion de la ventana de planeacion segun DLC
    [esqueleto_x, esqueleto_y] = extraccion_postural_ejecucion(matrix,umbral_barra,umbral_bebedero);
    esqueleto_completo_x(ii,1:length(esqueleto_x)) = esqueleto_x;
    esqueleto_completo_y(ii,1:length(esqueleto_y)) = esqueleto_y;

end 

% Sacar outliers de las trayectorias con base a hombro, codo y muneca
[esqueleto_general_x, esqueleto_general_y,correcto_out_1500] = outliers(esqueleto_completo_x,esqueleto_completo_y,correcto_out_1500,umbral_actividad);

bocaX   = esqueleto_general_x(:,1);
bocaY   = esqueleto_general_y(:,1);
hombroX = esqueleto_general_x(:,2);
hombroY = esqueleto_general_y(:,2);
codoX   = esqueleto_general_x(:,3);
codoY   = esqueleto_general_y(:,3);
munecaX = esqueleto_general_x(:,4);
munecaY = esqueleto_general_y(:,4);
centroX = esqueleto_general_x(:,5);
centroY = esqueleto_general_y(:,5);
segundoX = esqueleto_general_x(:,6);
segundoY = esqueleto_general_y(:,6);
terceroX = esqueleto_general_x(:,7);
terceroY = esqueleto_general_y(:,7);
cuartoX = esqueleto_general_x(:,8);
cuartoY = esqueleto_general_y(:,8);
quintoX = esqueleto_general_x(:,9);
quintoY = esqueleto_general_y(:,9);

figure, clf
axis equal
set(gca, 'YDir', 'reverse')
n = length(esqueleto_general_x);  % Número de ensayos
gradiente = linspace(0.5, 1, n)';  % Gradiente de color entre 0.5 (más claro) y 1 (más oscuro)
grid on
for kk = 1:size(esqueleto_general_x,1)
    hold on

    % Aplicar el gradiente de intensidad a cada color específico
    color_hombro = [gradiente(kk), 0, 0];  % Rojo para el hombro
    color_codo = [0, gradiente(kk), 0];    % Verde para el codo
    color_muneca = [0, 0, gradiente(kk)];  % Azul para la muñeca
    color_centro = [0.5 * gradiente(kk), 0.5 * gradiente(kk), 0.5 * gradiente(kk)];  % Gris para el centro de la mano
    color_segundo = [gradiente(kk), 0.5 * gradiente(kk), 0];     % Naranja para el segundo dedo
    color_tercero = [0.5 * gradiente(kk), 0, 0.5 * gradiente(kk)];   % Púrpura para el tercer dedo
    color_cuarto = [0, gradiente(kk), gradiente(kk)];        % Cian para el cuarto dedo
    color_quinto = [gradiente(kk), gradiente(kk), 0];        % Amarillo para el quinto dedo
    color_linea = [gradiente(kk), gradiente(kk), gradiente(kk)];

    plot(hombroX(kk), hombroY(kk), 'o', 'Color', color_hombro, 'MarkerFaceColor', color_hombro,'MarkerSize', 14, 'DisplayName', 'Hombro')
    plot(codoX(kk), codoY(kk), 'o', 'Color', color_codo, 'MarkerFaceColor', color_codo,'MarkerSize', 12,'DisplayName', 'Codo')
    plot(munecaX(kk), munecaY(kk), 'o', 'Color', color_muneca, 'MarkerFaceColor', color_muneca,'MarkerSize', 10, 'DisplayName', 'Muñeca')
    plot(centroX(kk), centroY(kk), 'o', 'Color', color_centro, 'MarkerFaceColor', color_centro,'MarkerSize', 8, 'DisplayName', 'Centro de la mano')
    plot(segundoX(kk), segundoY(kk), 'o', 'Color', color_segundo, 'MarkerFaceColor', color_segundo,'MarkerSize', 6, 'DisplayName', 'Segundo dedo')
    plot(terceroX(kk), terceroY(kk), 'o', 'Color', color_tercero, 'MarkerFaceColor', color_tercero,'MarkerSize', 6, 'DisplayName', 'Tercer dedo')
    plot(cuartoX(kk), cuartoY(kk), 'o', 'Color', color_cuarto, 'MarkerFaceColor', color_cuarto,'MarkerSize', 6, 'DisplayName', 'Cuarto dedo')
    plot(quintoX(kk), quintoY(kk), 'o', 'Color', color_quinto, 'MarkerFaceColor', color_quinto,'MarkerSize', 6, 'DisplayName', 'Quinto dedo')

    % Unir los puntos con líneas
    plot([hombroX(kk), codoX(kk)], [hombroY(kk), codoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Hombro a Codo');
    plot([codoX(kk), munecaX(kk)], [codoY(kk), munecaY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Codo a Muñeca');
    plot([munecaX(kk), centroX(kk)], [munecaY(kk), centroY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Muñeca a Centro de la mano');
    plot([centroX(kk), segundoX(kk)], [centroY(kk), segundoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Centro de la mano a segundo dedo');
    plot([centroX(kk), terceroX(kk)], [centroY(kk), terceroY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Centro de la mano a tercer dedo');
    plot([centroX(kk), cuartoX(kk)], [centroY(kk), cuartoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Centro de la mano a cuarto dedo');
    plot([centroX(kk), quintoX(kk)], [centroY(kk), quintoY(kk)], '-', 'Color', color_linea, 'DisplayName', 'Centro de la mano a quinto dedo');

end
%legend('Hombro','Codo','Muñeca','Location','southwest')
xlabel('Coordenada X')
ylabel('Coordenada Y')
xticks(475:25:850)
yticks(50:25:425)
xticklabels(0:25:375)
yticklabels(0:25:375)
xlim([475 850])
ylim([50 300])
title('Fase ejecución 1500 ms (Ensayos correctos)');

%Matriz esqueleto postural (Intercalar las columnas corresponde a cada uno
%de los puntos asignados en DLC (Hombro, Codo, Muneca)
ejec_1500 = table(bocaX,bocaY,hombroX,hombroY,codoX,codoY,munecaX,munecaY,centroX,centroY,segundoX,segundoY,terceroX,terceroY,cuartoX,cuartoY,quintoX,quintoY);

end


