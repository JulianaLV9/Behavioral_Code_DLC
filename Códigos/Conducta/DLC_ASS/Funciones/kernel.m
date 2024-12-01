function [muneca_x_out,muneca_y_out,cont_figure] = kernel(velocidad,muneca_x,muneca_y,cont_figure)

%Numero de ensayos
[n_filas, n_columnas] = size(muneca_x);

muneca_x_out = NaN(n_filas, n_columnas);
muneca_y_out = NaN(n_filas, n_columnas);

for hh = 1:size(muneca_x,2)
    munecaX                   = muneca_x(:,hh);
    munecaY                   = muneca_y(:,hh);
    fs                        = 20; %Este parametro se puede mover
    velocity_kernel_length    = round(0.2*fs); %Este parametro se puede mover
    velocity_smoothing_kernel = 1/velocity_kernel_length*ones(1,velocity_kernel_length);
    temp_velocity             = velocidad(:,hh);
    smoothed_velocity         = conv(temp_velocity,velocity_smoothing_kernel,'same')./conv(ones(length(temp_velocity),1),velocity_smoothing_kernel,'same');
    
    % %Ver figura velocidad suavizada
    % figure(cont_figure)
    % plot(smoothed_velocity)
    % cont_figure = cont_figure + 1;
    
    %Umbralizar la señal suavizada
    umbral          = 4;
    indices_fin     = smoothed_velocity < umbral;
    primer_fin      = find(indices_fin(10:end) == 1,1); %Despues buscar si hay varios intentos 
    trayectoria_x   = munecaX(1:primer_fin+10); %Le agrego los indices qu eme brinque
    trayectoria_y   = munecaY(1:primer_fin+10);
    
    %Recortar la primera trayectoria
    if size(trayectoria_x,1) < 10 %Evitar que no lo hizo a tiempo 
        continue;
    else 
    muneca_x_out(1:length(trayectoria_x),hh) = trayectoria_x;
    muneca_y_out(1:length(trayectoria_x),hh) = trayectoria_y;
    end 

end 
    
end