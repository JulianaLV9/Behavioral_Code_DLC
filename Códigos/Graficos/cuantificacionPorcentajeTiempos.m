%Cuantificar numero de acierto segun el tipo de prepracion

clc, clearvars, close all

%Seleccionar los archivos donde se encuentran los parametros cinematicos
[file_name, path_name] = uigetfile('.mat', 'Select coordinates file', 'MultiSelect', 'on');

% Almacenar los resultados
resultados = []; 

for ii = 1:length(file_name)

    % Cargar la informacion
    datos = load(file_name{1,ii});
    datos = datos.tareaInfo;
    data  = table2array(datos);

    % Categorias
    planeaciones = [500, 1000, 1500];
    tipos_ensayo = ["Aciertos", "Errores", "Omisiones", "Intento"];
    
    % Iniciar los resultados
    resultados_archivo = [];
    
    for plan = planeaciones
        
        %Total de ensayos segun el tipo de preparacion
        idx_total = datos.Planeacion == plan;
        total_ensayos = sum(idx_total);

        % Analiza por tipo de ensayos (1: Aciertos, 2: Errores, 3: Omisiones, 4: Intento)
        for tipo = 1:4
            idx_tipo = datos.Tipo_Ensayo == tipo & datos.Planeacion == plan;
            ensayoss = data(idx_tipo, :);
            total_tipo = size(ensayoss, 1);
            porcentaje_tipo = (total_tipo * 100) / total_ensayos;

            % Recopilar por tipo de ensayos: Planeacion, Tipo, Total, Percentage
            resultados_archivo = [resultados_archivo; plan, tipo, total_tipo, porcentaje_tipo];
        end
    end

    % Guardar en este archivo
    resultados = [resultados; resultados_archivo];
end
