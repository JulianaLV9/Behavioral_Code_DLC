% Juntar los parametros cinematicos segun el tiempo de preparacion

clc, clearvars, close all

%Seleccionar los archivos donde se encuentran los parametros cinematicos
[file_name, path_name] = uigetfile('.mat', 'Select coordinates file', 'MultiSelect', 'on');

% Juntar datos
inicio = 1;
for ii = 1:length(file_name)
    datos = load(file_name{1,ii});

    % Check if the field exists
    if ~isfield(datos, 'tabla_cinematica_1500')
        disp(['tabla_cinematica_1500 not found in file: ', file_name{1,ii}]);
        continue;
    end

    tabla = datos.tabla_cinematica_1500;

    % Check if it's a table
    if ~istable(tabla)
        disp(['Variable is not a table in file: ', file_name{1,ii}]);
        continue;
    end

    % Check if the table is empty
    if isempty(tabla)
        disp(['Table is empty in file: ', file_name{1,ii}]);
        continue;
    end

    % Convert table to array
    cinematica = table2array(tabla);

    % Filas
    num_filas = size(tabla, 1);
    fin = inicio + (num_filas - 1);

    % Sacar datos
    informacion_cinematica(inicio:fin, 1) = cinematica(:, 1); % tiempo de reaccion
    informacion_cinematica(inicio:fin, 2) = cinematica(:, 2); % duracion
    informacion_cinematica(inicio:fin, 3) = cinematica(:, 3); % velocidad
    informacion_cinematica(inicio:fin, 4) = cinematica(:, 5); % duracion_al
    informacion_cinematica(inicio:fin, 5) = cinematica(:, 6); % velocidad_al
    informacion_cinematica(inicio:fin, 6) = cinematica(:, 8); % duracion_ret
    informacion_cinematica(inicio:fin, 7) = cinematica(:, 9); % velocidad_ret

    inicio = fin + 1;
end


