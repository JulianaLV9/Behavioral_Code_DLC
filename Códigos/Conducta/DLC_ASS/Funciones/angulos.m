function [tabla_angulos] = angulos(matrix_postural)

% Coordenadas de los puntos
matrix_postural = table2array(matrix_postural);
boca_x          = matrix_postural(:,1);
boca_y          = matrix_postural(:,2);
hombro_x        = matrix_postural(:,3);
hombro_y        = matrix_postural(:,4);
codo_x          = matrix_postural(:,5);
codo_y          = matrix_postural(:,6);
muneca_x        = matrix_postural(:,7);
muneca_y        = matrix_postural(:,8);

%Sacar angulos apendiculares
angulo_hombro = NaN(size(matrix_postural, 1), 1);
angulos_codo   = NaN(size(matrix_postural, 1), 1);
angulos_muneca = NaN(size(matrix_postural, 1), 1);

for ii = 1:size(matrix_postural, 1)
    % Calcular longitudes de los lados del triángulo
    L1 = sqrt((hombro_x(ii) - codo_x(ii))^2 + (hombro_y(ii) - codo_y(ii))^2);  % Hombro a Codo
    L2 = sqrt((codo_x(ii) - muneca_x(ii))^2 + (codo_y(ii) - muneca_y(ii))^2);  % Codo a Muñeca
    L3 = sqrt((hombro_x(ii) - muneca_x(ii))^2 + (hombro_y(ii) - muneca_y(ii))^2);  % Hombro a Muñeca

    % Usar la ley de cosenos para calcular ángulos
    angulo_hombro(ii) = acos((L1^2 + L3^2 - L2^2) / (2 * L1 * L3)) * (180/pi);  % Ángulo en Hombro
    angulos_codo(ii)   = acos((L1^2 + L2^2 - L3^2) / (2 * L1 * L2)) * (180/pi);  % Ángulo en Codo
    angulos_muneca(ii) = acos((L2^2 + L3^2 - L1^2) / (2 * L2 * L3)) * (180/pi);  % Ángulo en Muñeca
end

%Sacar angulos axiales
angulo_axis      = NaN(size(matrix_postural, 1), 1);
angulo_boca      = NaN(size(matrix_postural, 1), 1);
angulo_horizonte = NaN(size(matrix_postural, 1), 1);

for ii = 1:size(matrix_postural, 1)
    % Definir el punto horizonte
    horizonte_x = boca_x(ii);  % x de la boca
    horizonte_y = hombro_y(ii); % y del hombro

    % Calcular longitudes de los lados del triángulo
    L1 = sqrt((boca_x(ii) - hombro_x(ii))^2 + (boca_y(ii) - hombro_y(ii))^2);  % Boca a Hombro
    L2 = sqrt((hombro_x(ii) - horizonte_x)^2 + (hombro_y(ii) - horizonte_y)^2);  % Hombro a Punto horizonte
    L3 = sqrt((boca_x(ii) - horizonte_x)^2 + (boca_y(ii) - horizonte_y)^2);  % Boca a Punto horizonte

    % Usar la ley de cosenos para calcular ángulos
    angulo_boca(ii) = acos((L1^2 + L3^2 - L2^2) / (2 * L1 * L3)) * (180/pi);  % Ángulo en Boca
    angulo_axis(ii) = acos((L1^2 + L2^2 - L3^2) / (2 * L1 * L2)) * (180/pi);  % Ángulo en Hombro
    angulo_horizonte(ii) = acos((L2^2 + L3^2 - L1^2) / (2 * L2 * L3)) * (180/pi);  % Ángulo en el Punto horizonte

end

tabla_angulos = table(angulo_hombro,angulos_codo,angulos_muneca,angulo_axis);

end 





