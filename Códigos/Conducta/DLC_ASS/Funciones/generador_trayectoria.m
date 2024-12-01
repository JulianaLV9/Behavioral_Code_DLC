function generador_trayectoria(indices_muneca_x, indices_muneca_y, promedio_muneca_x, promedio_muneca_y, posicion_bebedero, posicion_barra,  name)

% Posición de la barra y del bebedero
posicion_bebedero_x = posicion_bebedero(1,1);
posicion_bebedero_y = posicion_bebedero(1,2);
posicion_barra_x    = posicion_barra(1,1);
posicion_barra_y    = posicion_barra(1,2);

figure,
set(gca, 'YDir', 'reverse')
grid on
for kk = 1:size(indices_muneca_x, 2)

    vector_x = indices_muneca_x(:, kk);
    vector_y = indices_muneca_y(:, kk);
    
    % Extraer el fragmento sin NaN
    muneca_x = movmean(vector_x(~isnan(vector_x)), 2);
    muneca_y = movmean(vector_y(~isnan(vector_y)), 2);

    if length(muneca_x) < 2 || length(muneca_y) < 2
        continue; % Si no hay suficientes puntos para trazar, pasar al siguiente
    end
    
    for mm = 2:length(muneca_x) % Asegurarse de no exceder los límites
        hold on
        plot([muneca_x(mm - 1), muneca_x(mm)], [muneca_y(mm - 1), muneca_y(mm)], 'Color', [0.6510 0.6510 0.6510])
    end
end

% Definir colores para el gradiente
num_puntos = length(promedio_muneca_x);

% Iniciar siempre con el mismo color base (gris oscuro a verde)
transicion = round(num_puntos * 0.15);  % Ajusta el porcentaje de la transición
% Gris oscuro (RGB: [0.4, 0.4, 0.4]) a verde intenso (RGB: [0, 0.8, 0])
colores = [linspace(0.4, 0, transicion)', linspace(0.4, 0.8, transicion)', linspace(0.4, 0, transicion)'];

% Si hay más puntos que la transición, repetir el color final (verde intenso)
if length(colores) < num_puntos
    colores = [colores; repmat([0, 0.8, 0], num_puntos - transicion, 1)];
end

for ll = 2:length(promedio_muneca_x)

    U = promedio_muneca_x(ll) - promedio_muneca_x(ll - 1);
    V = promedio_muneca_y(ll) - promedio_muneca_y(ll - 1);
    hold on
    quiver(promedio_muneca_x(ll -1), promedio_muneca_y(ll - 1), U, V, '-', 'Color', colores(ll,:), ...
        'LineWidth', 1.5, 'MaxHeadSize', 1.5, 'AutoScale', 'off', 'AutoScaleFactor', 1.5)
    
    % Añadir puntos con marcadores específicos
    plot(posicion_barra_x, posicion_barra_y, 'o', 'MarkerFaceColor', [0.8196, 0.6431, 0.4902], ...
        'MarkerEdgeColor', [0.8196, 0.6431, 0.4902], 'MarkerSize', 20)
    plot(posicion_bebedero_x, posicion_bebedero_y, 'o', 'MarkerFaceColor', [0.2902, 0.3490, 0.5098], ...
        'MarkerEdgeColor', [0.2902, 0.3490, 0.5098], 'MarkerSize', 20)
end 

xlabel('Coord X', 'FontSize', 16, 'FontWeight', 'bold'); % Convertir esto a mm
ylabel('Coord Y', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 14, 'FontWeight', 'bold');
% set(gca, 'PlotBoxAspectRatio', [1 1 1]);
axis equal
xticks(650:25:850)
yticks(25:25:225)
xticklabels(0:25:350)
yticklabels(0:25:350)
xlim([650 850])
ylim([25 225])
ax = gca;
ax.XColor = 'none';
ax.YColor = 'none';
% ax.XTick = [];  % Oculta los ticks en el eje X
% ax.YTick = [];  % Oculta los ticks en el eje Y
title(name, 'FontSize', 18, 'FontWeight', 'bold');

end
