function proyecciones(videos)
% Input: Ingresan solo las referencias de los videos. Dentro de la funcion
% se cargan los videos seleccionados al azar. 01.ago.2024

fraccion_videos = 1/8; % por defecto un decimo de todos los videos 
fraccion_frames = 1/8; % por defecto un decimo de todos los frames

%% seleccionar videos al azar
tic
disp(['Calculando proyecciones, proporcion de remuestreo: ' num2str(fraccion_videos) '/' num2str(fraccion_frames)])

num_videos_totales = length(videos)-1;
frames_unvideo=videos{1}.NumFrames;
h = videos{1}.Height;
w = videos{1}.Width;
num_videos_selec = round(num_videos_totales*fraccion_videos);
num_frames_azar = frames_unvideo*fraccion_frames;

idx_selec_videos = randperm(num_videos_totales,num_videos_selec); % Videos muestreados al azar
selec_videos = videos(idx_selec_videos);

videos_concatenados = zeros(h,w,num_frames_azar*num_videos_selec);
inicio = 1;
fin = num_frames_azar;
for i = 1:length(selec_videos)
    disp(['remuestreando video: ' num2str(i) '/' num2str(num_videos_selec)]);
% Lectura de video y transformacion a matrices
    vid = selec_videos{i};
    frames_aleatorios = randperm(frames_unvideo,num_frames_azar); % Frames muestreados al azar
    im_rgb = read(vid,[1,inf]);
    vid2mat = zeros(vid.Height,vid.Width,num_frames_azar);
    for j = 1:num_frames_azar
        im_scaled = double(rgb2gray(im_rgb(:,:,:,frames_aleatorios(j))));
        im_scaled = im_scaled./max(im_scaled(:));
        vid2mat(:,:,j) = im_scaled;
    end
    videos_concatenados(:,:,inicio:fin) = vid2mat;
    inicio = fin+1;
    fin = fin+num_frames_azar;
 
end

% 
figure
% subplot(1,3,1)
imagesc(max(videos_concatenados,[],3))
colormap("parula")
title('Proyeccion con desviacion estandar')
axis("square")
shg

% subplot(1,3,2)
% imagesc(iqr(videos_concatenados,3))
% title('Rango intercuartilico')
% axis("square")
% 
% subplot(1,3,3)
% imagesc(mean(videos_concatenados,3))
% title('media')
% axis("square")
% 
t = toc;

disp(['Proyecciones, hecho ' num2str(t) 's'])
end
