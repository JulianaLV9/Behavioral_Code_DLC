function [angulos_polares, distancias_polares] = coord_polares(umbral_barra, plan_500, plan_1000, plan_1500, ejec_500, ejec_1000, ejec_1500)

% Coordenada de la barra
posicion_barraX = umbral_barra(1,1);
posicion_barraY = umbral_barra(1,2);

% Cálculos para planeación y ejecución
[angulos_polares.Plan_500, distancias_polares.Plan_500] = grafico_polar(plan_500, posicion_barraX, posicion_barraY, 'Ángulos 500 ms de preparación');
[angulos_polares.Plan_1000, distancias_polares.Plan_1000] = grafico_polar(plan_1000, posicion_barraX, posicion_barraY, 'Ángulos 1000 ms de preparación');
[angulos_polares.Plan_1500, distancias_polares.Plan_1500] = grafico_polar(plan_1500, posicion_barraX, posicion_barraY, 'Ángulos 1500 ms de preparación');
[angulos_polares.Ejec_500, distancias_polares.Ejec_500] = grafico_polar(ejec_500, posicion_barraX, posicion_barraY, 'Ángulos en la ejecución 500 ms de preparación');
[angulos_polares.Ejec_1000, distancias_polares.Ejec_1000] = grafico_polar(ejec_1000, posicion_barraX, posicion_barraY, 'Ángulos en la ejecución 1000 ms de preparación');
[angulos_polares.Ejec_1500, distancias_polares.Ejec_1500] = grafico_polar(ejec_1500, posicion_barraX, posicion_barraY, 'Ángulos en la ejecución 1500 ms de preparación');

end



