clc, clearvars, close all

%Seleccionar los archivos donde se encuentran los parametros cinematicos
[file_name, path_name] = uigetfile('.mat', 'Select coordinates file', 'MultiSelect', 'on');

% Inicializar matrices para almacenar datos
angulos_plan_500 = [];
angulos_plan_1000 = [];
angulos_plan_1500 = [];
angulos_ejec_500 = [];
angulos_ejec_1000 = [];
angulos_ejec_1500 = [];

for ii = 1:length(file_name)
    
    % Cargar datos del archivo
    datos = load(file_name{1,ii});
    
    % Concatenar filas debajo de las existentes
    angulos_plan_500 = [angulos_plan_500; datos.angulos_polares.Plan_500];
    angulos_plan_1000 = [angulos_plan_1000; datos.angulos_polares.Plan_1000];
    angulos_plan_1500 = [angulos_plan_1500; datos.angulos_polares.Plan_1500];
    angulos_ejec_500 = [angulos_ejec_500; datos.angulos_polares.Ejec_500];
    angulos_ejec_1000 = [angulos_ejec_1000; datos.angulos_polares.Ejec_1000];
    angulos_ejec_1500 = [angulos_ejec_1500; datos.angulos_polares.Ejec_1500];
end

% Visualizar el tamaño de las matrices resultantes
disp(size(angulos_plan_500));
disp(size(angulos_plan_1000));
disp(size(angulos_plan_1500));
disp(size(angulos_ejec_500));
disp(size(angulos_ejec_1000));
disp(size(angulos_ejec_1500));
