%FUNCION PARA SACAR EL PROMEDIO DE LA TRTAYECTORIA SEGUN LA MATRIZ SEGUN LA CLASIFICACION DE LOS
%ENSAYOS 

function [mean_esqueleto_x, mean_esqueleto_y] = extraccion_postural_planeacion(matrix,umbral_barra)

%%% Identificar las partes del cuerpo analizadas en DLC %%%
bebedero_x = matrix(:,2);
bebedero_y = matrix(:,3);
nariz_x    = matrix(:,5);
nariz_y    = matrix(:,6);
boca_x     = matrix(:,8);
boca_y     = matrix(:,9);
hombro_x   = matrix(:,11);
hombro_y   = matrix(:,12);
codo_x     = matrix(:,14);
codo_y     = matrix(:,15);
muneca_x   = matrix(:,17);
muneca_y   = matrix(:,18);
centro_x   = matrix(:,20);
centro_y   = matrix(:,21);
segundo_x  = matrix(:,23);
segundo_y  = matrix(:,24);
tercero_x  = matrix(:,26);
tercero_y  = matrix(:,27);
cuarto_x   = matrix(:,29);
cuarto_y   = matrix(:,30);
quinto_x   = matrix(:,32);
quinto_y   = matrix(:,33);

%%Aquí hay que utilizar el umbral de la barra para sacar todas las posturas que no estan en la matriz.

umbral_bajo = umbral_barra(1,1) - 100; %Nos desplazamos -100px donde probablemente podría estar la mano
umbral_alto = umbral_barra(1,1) ; %Nos desplazamos -50px donde probablemente podría estar la mano
indices_in  = muneca_x > umbral_bajo & muneca_x < umbral_alto; % Condición para obtener los valores dentro de los umbrales

% Concatenar los vectores para generar una matriz %
esqueleto_x = [boca_x hombro_x codo_x muneca_x centro_x segundo_x tercero_x cuarto_x quinto_x]; %Boca, hombro, codo, muneca
esqueleto_y = [boca_y hombro_y codo_y muneca_y centro_y segundo_y tercero_y cuarto_y quinto_y];

% Filtrar las filas que corresponden a los índices que cumplen con los umbrales
esqueleto_x_filtrado = esqueleto_x(indices_in, :);
esqueleto_y_filtrado = esqueleto_y(indices_in, :);

% Sacar el promedio del esqueleto filtrado
mean_esqueleto_x = mean(esqueleto_x_filtrado);
mean_esqueleto_y = mean(esqueleto_y_filtrado);

end




