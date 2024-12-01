function [matrizAngulos, distancias] = grafico_polar(data, posicion_barraX, posicion_barraY, titulo)
% Convertir tabla a matriz
datos = table2array(data);

% Coordenadas de las articulaciones
hombroX = datos(:,3);
hombroY = datos(:,4);
codoX   = datos(:,5);
codoY   = datos(:,6);
munecaX = datos(:,7);
munecaY = datos(:,8);

% Calcular ángulos
anguloHombro = mod(atan2(-(hombroY - posicion_barraY), hombroX - posicion_barraX) * (180/pi), 360);
anguloCodo   = mod(atan2(-(codoY - posicion_barraY), codoX - posicion_barraX) * (180/pi), 360);
anguloMuneca = mod(atan2(-(munecaY - posicion_barraY), munecaX - posicion_barraX) * (180/pi), 360);

matrizAngulos = [anguloHombro, anguloCodo, anguloMuneca];

% Calcular distancias desde la barra
distanciaHombro = sqrt((hombroX - posicion_barraX).^2 + (hombroY - posicion_barraY).^2);
distanciaCodo   = sqrt((codoX - posicion_barraX).^2 + (codoY - posicion_barraY).^2);
distanciaMuneca = sqrt((munecaX - posicion_barraX).^2 + (munecaY - posicion_barraY).^2);

distancias = [distanciaHombro, distanciaCodo, distanciaMuneca];

% Crear el gráfico polar
figure;
ax = polaraxes;
ax.ThetaZeroLocation = 'right';
ax.ThetaDir = 'counterclockwise';
hold on;

% Dibujar líneas y puntos
for i = 1:size(matrizAngulos, 1)
    polarplot(ax, [0, deg2rad(matrizAngulos(i, 1))], [0, distanciaHombro(i)], 'LineWidth', 2, 'Color', [0.635, 0.078, 0.184]);
    polarplot(ax, [0, deg2rad(matrizAngulos(i, 2))], [0, distanciaCodo(i)], 'LineWidth', 2, 'Color', [0.467, 0.675, 0.188]);
    polarplot(ax, [0, deg2rad(matrizAngulos(i, 3))], [0, distanciaMuneca(i)], 'LineWidth', 2, 'Color', [0, 0.447, 0.741]);
end

thetaticks(0:30:360);
title(titulo);
hold off;

end
