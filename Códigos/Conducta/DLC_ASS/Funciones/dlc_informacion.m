%Seleccion de los archivos csv de DLC de lo videos para poder seleccionar
%los frames donde ocurren los eventos de interés
function [dlc_matrix] = dlc_informacion
h = msgbox('Selecciona los archivos csv de DLC de donde se extrae la información de los videos')
uiwait(h);

%Seleccion de los archivos csv
[file_name, path_name] = uigetfile('.csv', 'Select coordinates file', 'MultiSelect', 'on');

%Concatenar todos los arrchivos previamente seleccionados 
dlc_matrix = NaN(length(file_name)*1000,34);
cont = 1;
for ii = 1:length(file_name)
    tabla = table2array(readtable(file_name{1,ii}));
    dlc_matrix(cont:cont+length(tabla)-1,:) = tabla;
    cont = cont + 1000;
end

end 