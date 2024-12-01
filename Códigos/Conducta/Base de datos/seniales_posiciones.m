function [seniales_binaria_umbral,indices_fin,eventos_conducta,posiciones] =  seniales_posiciones(nombres,umbral_saturacion,path_name,data_archivo,next_video)

% umbral_saturacion Se buscan los valores iguales a 1, de umbral por defecto es de 0.98

%% Extraer informacion de los videos
tic
[videos,indices_inicio,indices_fin,total_frames] = conc_vid(data_archivo);


%% Procesar cada video
seniales_binaria_umbral = zeros(length(nombres),total_frames); % Se guardan todas las seniales de todos los ensayos binarizada
senial_row = zeros(length(nombres),total_frames);       % Se guardan todas las seniales de todos los ensayos sin binarizar

flag = 1;
for i = 1:length(videos)
    disp(['Procesando video: ' char(string(i)) '/' char(string(length(videos))) '...'])

    % Lectura de video y transformacion a matrices
    vid = videos{i};
    frames_n = round(vid.Duration*vid.FrameRate); %%%%%% ADVERTENCIA: Si los videos estan mal guardados (DIFERENTE FRAME RATE), esta linea no funciona

    im_rgb = read(vid,[1,inf]);
    vid2mat = zeros(vid.Height,vid.Width,frames_n);
    for j = 1:frames_n

        im_scaled = double(rgb2gray(im_rgb(:,:,:,j)));
        im_scaled = im_scaled./max(max(im_scaled));
        vid2mat(:,:,j) = im_scaled;

    end

    if flag == 1
        %% Imagen de referencia
        % Graficar imagenes de referencia
        figure(1)

        imrefer = vid2mat(:,:,1);
        colormap('gray')
        imagesc(imrefer)
        title('Max Projection')
        shg

        % Entrada de las coordenadas de las regiones de interes:
        posiciones_data = readtable('posiciones_RTO_LoteAyB.xlsx');
        posiciones = table2array(posiciones_data);
        num_rois = 5;

    end
    %% Cortar rectangulos del ensayo enesimo

    % Para cada roi, normalizar y calcular el promedio.
    promedio_de_cada_roi_frame = zeros(num_rois,frames_n);
    for j = 1:num_rois

        rectangulo = vid2mat(posiciones(j,2):posiciones(j,2)+posiciones(j,4),posiciones(j,1):posiciones(j,1)+posiciones(j,3),:);
%         maximos = max(max(rectangulo,[],2));
%         rectangulos_norm = rectangulo./maximos;
        rectangulos_norm = rectangulo./1; %Se divide entre el valor mas alto posible (1=blanco)
        promedio_de_cada_frame = mean(mean(rectangulos_norm,1),2);
        promedio_de_cada_frame = reshape(promedio_de_cada_frame,1,[]);
        promedio_de_cada_roi_frame(j,:) =  promedio_de_cada_frame;

    end

    % Binarizar cada ensayo y concatenarlo

    %     ensayo_binario = promedio_de_cada_roi_frame>umbral_saturacion; % Se buscan los valores cercanos al 1.
    %     seniales_binaria_umbral(:,indices_inicio(i):indices_fin(i+1)) = ensayo_binario;
    senial_row(:,indices_inicio(i):indices_fin(i+1)) = promedio_de_cada_roi_frame;

end
seniales_binaria_umbral = senial_row>umbral_saturacion;

inp = 1;
while inp == 1

    n = length(nombres);
    figure(2),clf
    for i = 1:n
        subplot(n,1,i)
        plot(seniales_binaria_umbral(i,:),'-*',LineWidth=2)
        ylabel(nombres(i),"FontWeight","bold")
    end
    figure(3), clf
    for i = 1:n
        subplot(n,1,i)
        plot(senial_row(i,:),LineWidth=2,Color='black')
        ylabel(nombres(i),"FontWeight","bold")
        title('Senial Cruda')
    end
    shg


% modificar el umbral
    inp = input("¿Modificar umbral? si entra 1, no entra 0:  ");
    if inp == 1
        um = input("Nuevo umbral:   ");
        seniales_binaria_umbral = senial_row>um;
        close all
    end
end

%% Guardar en Tabla
sz = [length(senial_row),length(nombres)];
vt = repmat("double",1,length(nombres));
se_bin = table('Size',sz,'VariableTypes',vt,'VariableNames',nombres);

for i = 1:length(nombres)
se_bin.(nombres(i)) = seniales_binaria_umbral(i,:)';
end

%% Guardar resultados
eventos_conducta.seniales_binarias = seniales_binaria_umbral;
eventos_conducta.senial_row = senial_row;
eventos_conducta.indices = indices_fin;
eventos_conducta.nombres = nombres;
eventos_conducta.se_bin = se_bin;

% WorkFolder = cd; 
% cd(path_name);
% Sesion = date;
% save(['Eventos conducta' '_' Sesion '.mat'],'eventos_conducta');
% 
% cd(WorkFolder);
%%
t_eventos_conducta = toc;
disp(['Eventos de conducta, hecho '  num2str(t_eventos_conducta) '(seg)'])


