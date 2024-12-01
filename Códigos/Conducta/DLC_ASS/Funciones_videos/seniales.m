function [seniales_binaria_umbral,indices_fin,eventos_conducta,posiciones] =  seniales(nombres,umbral_saturacion,path_name,data_archivo)
%% Extraer informacion de los videos
tic
[videos,indices_inicio,indices_fin,total_frames] = conc_vid(data_archivo);
%% Proyeciones
proyecciones(videos) % Funcion: se calcula una proyeccion con videos y frames tomados al azar
% Entrada de las coordenadas de las regiones de interes:
num_rois = length(nombres);
posiciones = zeros(num_rois,4);
region_correcta = 0;
for j = 1:num_rois
    disp(['Selecciona el roi: ' char(nombres(j))])
    region_n = drawrectangle();
    while region_correcta == 0
        posicion_n = region_n.Position;
        if region_correcta == 0
            region_correcta = input('Ingresa 1 para finalizar el roi:  ' );
            posicion_n = region_n.Position;
        end
    end
    region_correcta = 0;
    posicion_n = round(posicion_n);
    posiciones(j,1:4) = posicion_n;
end
%% Procesar los rois de cada video
senial_row = zeros(length(nombres),total_frames);       % Se guardan todas las seniales de todos los ensayos sin binarizar
for i = 1:length(videos)
    disp(['Procesando regiones de interes del video: ' char(string(i)) '/' char(string(length(videos))) '...'])

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

    % Cortar rectangulos del ensayo enesimo
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

senial_row_norm = senial_row./max(senial_row,[],2);
senial_row      = senial_row_norm;

seniales_binaria_umbral = senial_row>umbral_saturacion;
%% Recalcular el umbral
inp = 1;
while inp == 1

    n = length(nombres);
    figure
    for i = 1:n
        subplot(n,1,i)
        plot(seniales_binaria_umbral(i,:),'-*',LineWidth=2)
        ylabel(nombres(i),"FontWeight","bold")
    end
    figure
    for i = 1:n
        subplot(n,1,i)
        plot(senial_row(i,:),LineWidth=2,Color='black')
        ylabel(nombres(i),"FontWeight","bold")
        title('Senial Cruda')
    end
    shg

    % modificar el humbral
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
 
WorkFolder = cd; 
cd(path_name);
Sesion = date;
save(['Eventos conducta' '_' Sesion '.mat'],'eventos_conducta');
save(['posiciones' '_' Sesion '.mat'],'posiciones');


cd(WorkFolder);
%%
t_eventos_conducta = toc;
disp(['Eventos de conducta, hecho '  num2str(t_eventos_conducta) '(seg)'])
