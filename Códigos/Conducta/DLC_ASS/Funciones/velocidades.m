function [velocidades_totales] = velocidades(velocidad_500,velocidad_1000,velocidad_1500)

%Encontrar el valor maximo de filas de las tres matrices
num_filas_500  = size(velocidad_500(any(~isnan(velocidad_500), 2)), 1);
num_filas_1000 = size(velocidad_1000(any(~isnan(velocidad_1000), 2)), 1);
num_filas_1500 = size(velocidad_1500(any(~isnan(velocidad_1500), 2)), 1);

%Encontrar el valor maximo de columnas de las tres matrices
num_col_500  = size(velocidad_500, 2);
num_col_1000 = size(velocidad_1000, 2);
num_col_1500 = size(velocidad_1500, 2);
num_col      = num_col_500 + num_col_1000 + num_col_1500;

% Maximo numero de filas
max_filas = max([num_filas_500, num_filas_1000, num_filas_1500]);

% MAximo numero de columnas
% max_columnas = max([num_col_500, num_col_1000, num_col_1500]);

velocidad_500  = velocidad_500(1:max_filas,1:num_col_500);
velocidad_1000 = velocidad_1000(1:max_filas,1:num_col_1000);
velocidad_1500 = velocidad_1500(1:max_filas,1:num_col_1500);

velocidades_totales = table(velocidad_500,velocidad_1000,velocidad_1500);

end