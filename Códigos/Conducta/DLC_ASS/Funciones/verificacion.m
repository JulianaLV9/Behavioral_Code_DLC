% Recompensa - inicio_ensayo
%del ASS sacar los ms que tardo en llegar de la barra-bebedero (columna 8) y eso
%multiplicarlo por dur_frame

function [tareaInfo] = verificacion(conducta_info, tareaInfo)
format longG
% Informacion del led correcto en ASS y en la info binaria
tiempo_led_correct = table2array(conducta_info(:,8)); % información ASS que son TIEMPO en ms
indices_correcto   = tiempo_led_correct(tiempo_led_correct > 1); % información del ASS que son TIEMPO ms

% Recompensa
recompensa = table2array(tareaInfo(:,9)); % extraer columna de recompensa como array
indices_recompensa = recompensa(recompensa > 1); % filtrar los ensayos con recompensa

%Barra
barra = table2array(tareaInfo(:,8));

% Si no alcanzó ventana el último ensayo
if height(conducta_info) > height(tareaInfo)
    tareaInfo = tareaInfo(1:end-1,:); % ajustar para que coincidan las alturas
end

% Si hay más ensayos correctos en ASS que recompensas en binario
if length(indices_correcto) > length(indices_recompensa)
    frame_dur = 16.67; % duración del frame en ms
    frames_adicionales = ceil(tiempo_led_correct / frame_dur); % convertir el tiempo a frames

    % Verificar si hay suficientes recompensas y ajustar
    if length(tiempo_led_correct) <= length(frames_adicionales)
        recompensa_essay = barra + frames_adicionales(1:length(barra));
    else
        recompensa_essay = barra + frames_adicionales;
    end 

    elseif length(indices_correcto) == length(indices_recompensa)
        return;
    
end

% Ajustar la longitud de recompensa_essay para que coincida con el tamaño de tareaInfo
recompensa_essay = recompensa_essay(1:min(height(tareaInfo), length(recompensa_essay)));

% Asignar los nuevos valores a la columna 9 de la tabla 'tareaInfo'
tareaInfo{1:length(recompensa_essay), 9} = recompensa_essay;

end

