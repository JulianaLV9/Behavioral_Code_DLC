function [tabla_cinematica] = cinematica_rt(correcto_500,correcto_1000,correcto_1500,duracion_500,tiempo_reaccion_500,velocidad_ensayos_500,aceleracion_ensayos_500,duracion_1000,tiempo_reaccion_1000,velocidad_ensayos_1000,aceleracion_ensayos_1000,duracion_1500,tiempo_reaccion_1500,velocidad_ensayos_1500,aceleracion_ensayos_1500)

%Crear un arreglo para la tabla
total_500  = table2array(correcto_500);
total_500  = size(total_500,1);
total_1000 = table2array(correcto_1000);
total_1000 = size(total_1000,1);
total_1500 = table2array(correcto_1500);
total_1500 = size(total_1500,1);

num_filas = max([total_500,total_1000,total_1500]);

duracion_500             = [duracion_500; nan(num_filas - length(duracion_500), 1)];
tiempo_reaccion_500      = [tiempo_reaccion_500; nan(num_filas - length(tiempo_reaccion_500), 1)];
velocidad_ensayos_500    = [velocidad_ensayos_500; nan(num_filas - length(velocidad_ensayos_500), 1)];
aceleracion_ensayos_500  = [aceleracion_ensayos_500; nan(num_filas - length(aceleracion_ensayos_500), 1)];
duracion_1000            = [duracion_1000; nan(num_filas - length(duracion_1000), 1)];
tiempo_reaccion_1000     = [tiempo_reaccion_1000; nan(num_filas - length(tiempo_reaccion_1000), 1)];
velocidad_ensayos_1000   = [velocidad_ensayos_1000; nan(num_filas - length(velocidad_ensayos_1000), 1)];
aceleracion_ensayos_1000 = [aceleracion_ensayos_1000; nan(num_filas - length(aceleracion_ensayos_1000), 1)];
duracion_1500            = [duracion_1500; nan(num_filas - length(duracion_1500), 1)];
tiempo_reaccion_1500     = [tiempo_reaccion_1500; nan(num_filas - length(tiempo_reaccion_1500), 1)];
velocidad_ensayos_1500   = [velocidad_ensayos_1500; nan(num_filas - length(velocidad_ensayos_1500), 1)];
aceleracion_ensayos_1500 = [aceleracion_ensayos_1500; nan(num_filas - length(aceleracion_ensayos_1500), 1)];

tabla_cinematica = table(duracion_500,tiempo_reaccion_500,velocidad_ensayos_500,aceleracion_ensayos_500,duracion_1000,tiempo_reaccion_1000,velocidad_ensayos_1000,aceleracion_ensayos_1000,duracion_1500,tiempo_reaccion_1500,velocidad_ensayos_1500,aceleracion_ensayos_1500);

end 