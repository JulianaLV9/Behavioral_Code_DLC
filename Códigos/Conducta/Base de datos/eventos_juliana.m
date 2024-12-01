% Codigo para sacar los eventos de la conducta a través de la señal de ...
% los leds

clc, clearvars
close all
[~, path_name, data_archivo_videos, ~, ~] = LoadFiles;
nombres = ["ensayo","go","barra","correcto","intento"];
umbral_saturacion = 0.8;

[~,~,eventos_conducta] = seniales(nombres,umbral_saturacion,path_name,data_archivo_videos);

