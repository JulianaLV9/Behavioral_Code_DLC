function [videos,indices_inicio,indices_fin,total_frames] = conc_vid(data_archivo)


longitud_videos = zeros(1,length(data_archivo));
videos = cell(1,length(data_archivo));
flag = 1;
textprogressbar('Extrayendo informacion de videos: ');

for i = 1:length(data_archivo)
    
    porcentaje = (i*100)/length(data_archivo);
    
    %textprogressbar(porcentaje); %Citado el 07/05/2024
    
    Vid = VideoReader(data_archivo{i});

    if flag == 1
        width = Vid.Width;
        heigth = Vid.Height;
        flag = 0;
    end
    
videos{i} = Vid;
framerate = Vid.FrameRate;
frames_n = Vid.Duration*framerate;
longitud_videos(i) = frames_n;
end
textprogressbar('hecho');

total_frames = int32(sum(longitud_videos));
ind = cumsum(longitud_videos);
indices_fin = int32([0 ind]);
indices_inicio = int32(indices_fin+1);

