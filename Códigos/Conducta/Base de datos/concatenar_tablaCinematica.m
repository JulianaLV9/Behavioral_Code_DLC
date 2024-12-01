%Sacar los valores de duracion, tiempo de reaccion y velocidad de
%difernetes protocolos de planeacion

%Cargar los archivos por sesiones 

[file_name, path_name] = uigetfile('*', 'Select coordinates file', 'MultiSelect', 'on'); 

% Matrices
dur_500  = []; 
rt_500   = [];
vel_500  = [];
dur_1000 = []; 
rt_1000  = [];
vel_1000 = [];
dur_1500 = []; 
rt_1500  = [];
vel_1500 = [];

for ii = 1:length(file_name)

    archivo     = file_name{1,ii};
    data        = table2array(readtable(archivo));
   
    % Concatenación de las columnas sin NaN
    dur_500  = vertcat(dur_500, data(~isnan(data(:,1)), 1));
    rt_500   = vertcat(rt_500, data(~isnan(data(:,2)), 2));
    vel_500  = vertcat(vel_500, data(~isnan(data(:,3)), 3));

    dur_1000 = vertcat(dur_1000, data(~isnan(data(:,5)), 5));
    rt_1000  = vertcat(rt_1000, data(~isnan(data(:,6)), 6));
    vel_1000 = vertcat(vel_1000, data(~isnan(data(:,7)), 7));

    dur_1500 = vertcat(dur_1500, data(~isnan(data(:,9)), 9));
    rt_1500  = vertcat(rt_1500, data(~isnan(data(:,10)), 10));
    vel_1500 = vertcat(vel_1500, data(~isnan(data(:,11)), 11));

end

nombre = input('Nombre del archivo: ', 's');
save(fullfile('/Users/julianalozavaqueiro/Documents/Datos_septiembre_2024/tabla_cinematica', [nombre '_duracion_500.mat']), "dur_500")
save(fullfile('/Users/julianalozavaqueiro/Documents/Datos_septiembre_2024/tabla_cinematica', [nombre '_rt_500.mat']), "rt_500")
save(fullfile('/Users/julianalozavaqueiro/Documents/Datos_septiembre_2024/tabla_cinematica', [nombre '_vel_500.mat']), "vel_500")


save(fullfile('/Users/julianalozavaqueiro/Documents/Datos_septiembre_2024/tabla_cinematica', [nombre '_duracion_1000.mat']), "dur_1000")
save(fullfile('/Users/julianalozavaqueiro/Documents/Datos_septiembre_2024/tabla_cinematica', [nombre '_rt_1000.mat']), "rt_1000")
save(fullfile('/Users/julianalozavaqueiro/Documents/Datos_septiembre_2024/tabla_cinematica', [nombre '_vel_1000.mat']), "vel_1000")

save(fullfile('/Users/julianalozavaqueiro/Documents/Datos_septiembre_2024/tabla_cinematica', [nombre '_duracion_1500.mat']), "dur_1500")
save(fullfile('/Users/julianalozavaqueiro/Documents/Datos_septiembre_2024/tabla_cinematica', [nombre '_rt_1500.mat']), "rt_1500")
save(fullfile('/Users/julianalozavaqueiro/Documents/Datos_septiembre_2024/tabla_cinematica', [nombre '_vel_1500.mat']), "vel_1500")
