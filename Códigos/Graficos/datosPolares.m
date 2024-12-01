%Juntar ditancias y angulos

clc, clearvars, close all

%Seleccionar los archivos donde se encuentran los parametros cinematicos
[file_name, path_name] = uigetfile('.mat', 'Select coordinates file', 'MultiSelect', 'on');

% Inicializar matrices para almacenar datos
distancias_plan_500 = [];
distancias_plan_1000 = [];
distancias_plan_1500 = [];
distancias_ejec_500 = [];
distancias_ejec_1000 = [];
distancias_ejec_1500 = [];

for ii = 1:length(file_name)
    
    % Cargar datos del archivo
    datos = load(file_name{1,ii});
    
    % Concatenar filas debajo de las existentes
    distancias_plan_500 = [distancias_plan_500; datos.distancias_polares.Plan_500];
    distancias_plan_1000 = [distancias_plan_1000; datos.distancias_polares.Plan_1000];
    distancias_plan_1500 = [distancias_plan_1500; datos.distancias_polares.Plan_1500];
    distancias_ejec_500 = [distancias_ejec_500; datos.distancias_polares.Ejec_500];
    distancias_ejec_1000 = [distancias_ejec_1000; datos.distancias_polares.Ejec_1000];
    distancias_ejec_1500 = [distancias_ejec_1500; datos.distancias_polares.Ejec_1500];
end

% Visualizar el tamaño de las matrices resultantes
disp(size(distancias_plan_500));
disp(size(distancias_plan_1000));
disp(size(distancias_plan_1500));
disp(size(distancias_ejec_500));
disp(size(distancias_ejec_1000));
disp(size(distancias_ejec_1500));
