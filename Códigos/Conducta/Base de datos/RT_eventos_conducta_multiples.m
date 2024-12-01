% Codigo para sacar los eventos de la conducta a través de la señal de ...
% los leds 

% ¡¡¡NOTA: los errores de cuando sueltan barra no se registraran sesiones
% anteriores a la 5

clc, clearvars
close all

%Seleccionar los videos a analizar por rata 
numSesiones = 2; %Indicar el número de sesiones a analizar

for ii = 1:numSesiones

[~, path_name, data_archivos, ~, ~] = LoadFiles; %Seleccion de todos los videos
archivo_videos(ii,:) = cell2table(data_archivos);

end 

for kk = 1:size(archivo_videos,1)

data_archivo_videos = archivo_videos(kk,:);
data_archivo_videos = table2cell(data_archivo_videos);
nombres = ["ensayo","go","barra","correcto","intento"];

umbral_saturacion = 0.7;
next_video = 1;

[~,~,eventos_conducta,posiciones] = seniales_posiciones(nombres,umbral_saturacion,path_name,data_archivo_videos,next_video);

% Sacar los eventos 

    archivo     = data_archivos{1,1};
    nombre      = extractBetween(archivo, 'B6\','_RTO');
    dia         = extractBetween(archivo, 'RTO_','\');
    rata_sesion = [nombre{1} '_' dia{1}];        

%Tasa de muestreo de los videos
tasaMuestreo  = 1000/16.67;%frames/segundos del video
frameXseg     = 1000/tasaMuestreo; %ms/tasaMuestreo
framesTotales = (1:length(eventos_conducta.seniales_binarias));%ms
tiempoFrames  = (frameXseg * framesTotales) / 1000; %segundos 

% Eventos a segundos 
eventosAseg   = table2array(eventos_conducta.se_bin) .* tiempoFrames';

%Sacar el vector de cada uno de los leds 
ensayos       = eventos_conducta.seniales_binarias(1,:);
senal_go      = eventos_conducta.seniales_binarias(2,:);
barra         = eventos_conducta.seniales_binarias(3,:);
correcto      = eventos_conducta.seniales_binarias(4,:); %Importante considerar que esta información no es certera de cuando llegaron a la barra
intento       = eventos_conducta.seniales_binarias(5,:);

%Inicio de los eventos 
inicioEnsayos      = islocalmax(ensayos,'FlatSelection','first',MinSeparation=10); 
inicioSenalGo      = islocalmax(senal_go,'FlatSelection','first',MinSeparation=10);
liberacionBarra    = islocalmax(barra,'FlatSelection','first',MinSeparation=10);  %5 es equivalente aprox a 85 ms de separacion
contactoGota       = islocalmax(correcto,'FlatSelection','first',MinSeparation=10);
totalIntentos      = islocalmax(intento,'FlatSelection','first',MinSeparation=10); %Es para saber el #de intentos y descontarlo a los ensayos correctos

%Verificar que efectivamente esta amrcando el inicio de los eventos ¡¡¡ESTO
%SE PUEDE RETIRAR DESPUÉS!!!
frames = 1000;
figure(4), clf
subplot(511)
plot(framesTotales(1:frames),ensayos(1:frames),framesTotales(inicioEnsayos(1:frames)),ensayos(inicioEnsayos(1:frames)),'r*');
subplot(512)
plot(framesTotales(1:frames),senal_go(1:frames),framesTotales(inicioSenalGo(1:frames)),senal_go(inicioSenalGo(1:frames)),'r*');
subplot(513)
plot(framesTotales(1:frames),barra(1:frames),framesTotales(liberacionBarra(1:frames)),barra(liberacionBarra(1:frames)),'r*');
subplot(514)
plot(framesTotales(1:frames),correcto(1:frames),framesTotales(contactoGota(1:frames)),correcto(contactoGota(1:frames)),'r*');
subplot(515)
plot(framesTotales(1:frames),intento(1:frames),framesTotales(totalIntentos(1:frames)),intento(totalIntentos(1:frames)),'r*');


%Duracion de ensayos (Va de inicio del ensayo a inicio del ensayo 2)
iniciosEnsayos       = find(inicioEnsayos == 1); %devuelve los frames de los inicios de los ensayos
durEnsayosFrames   = diff(iniciosEnsayos); %frames
durEnsayos         = (durEnsayosFrames * frameXseg) / 1000;
promDurEnsayos     = mean(durEnsayos);

%Ventanas ensayos
totalEnsayos  = length(iniciosEnsayos);
inicioVentana = iniciosEnsayos;
finVentana    = [iniciosEnsayos(2:end)];

if length(finVentana) < length(inicioVentana)
    ventanasEnsayos = [inicioVentana(1:end-1);finVentana(1:end)];
elseif  length(finVentana) == length(inicioVentana)
    ventanasEnsayos = [inicioVentana(1:end);finVentana(1:end)];
end 

%Ensayos Correctos e Intentos
frameCorrecto     = find(contactoGota == 1);
frameIntento      = find(totalIntentos == 1);
ensayosEjecutados = length(frameCorrecto);
ensayosExito      = length(frameCorrecto) - length(frameIntento);
ensayosIntento    = length(frameIntento);

%Ensayos Incorrectos y Omisiones
frameGo         = find(inicioSenalGo == 1);
frameBarra      = find(liberacionBarra == 1);

contador = 1;
ensayoProductivo = zeros(1,length(ventanasEnsayos));
ensayoGo         = zeros(1,length(ventanasEnsayos));
ensayoBebedero   = zeros(1,length(ventanasEnsayos));
ensayoIntento    = zeros(1,length(ventanasEnsayos));

for ii = 1:length(ventanasEnsayos)

    %Sacar indices
    ventanaActual    = ventanasEnsayos(1,ii):ventanasEnsayos(2,ii);
    indicesBarra     = find(ismember(frameBarra, ventanaActual));
    indicesGo        = find(ismember(frameGo, ventanaActual));
    indicesCorrectos = find(ismember(frameCorrecto, ventanaActual));
    indicesIntentos  = find(ismember(frameIntento, ventanaActual));

    if ~isempty(indicesBarra)
        ensayoProductivo(contador) = frameBarra(indicesBarra(1)); %Ensayos en los cuales la rata se acerco a la barra
    end

    if ~isempty(indicesGo)
        ensayoGo(contador)         = frameGo(indicesGo(1));
    end

    if ~isempty(indicesCorrectos)
        ensayoBebedero(contador)   = frameCorrecto(indicesCorrectos(1));
    end

    if ~isempty(indicesIntentos)
        ensayoIntento(contador)    = frameIntento(indicesIntentos(1));
    end

    contador = contador + 1;

end

% Verificar ensayo por ensayo si son omisiones o errores de acuerdo a los
% vectores ensayoProductivo y ensayoGo
indicesOmisiones  = []; 
indicesConcluidos = [];
indicesCorrecto   = [];
indicesErrores    = []; 
indicesIntentos   = [];
indicesAciertos   = [];


for jj = 1:length(ensayoProductivo)

    if ensayoProductivo(jj) ~= 0 && ensayoGo(jj) ~= 0 && ensayoBebedero(jj) ~= 0 %Toda la tarea hecha
        indicesConcluidos(end+1) = jj;

    elseif ensayoProductivo(jj) ~= 0 && ensayoGo(jj) ~= 0 && ensayoBebedero(jj) == 0 %No contacto el bebedero
        indicesErrores(end+1) = jj;

    elseif ensayoProductivo(jj) ~= 0 && ensayoGo(jj) == 0 %Contacto menos tiempo la barra
        indicesErrores(end+1) = jj;

    elseif ensayoProductivo(jj) == 0 && ensayoGo(jj) ~= 0   %No solto barra
        indicesErrores(end+1) = jj;

    elseif ensayoProductivo(jj) == 0 && ensayoGo(jj) == 0
        indicesOmisiones(end+1) = jj;

    end

end

% ensayoProductivo(jj) ~= 0 && ensayoGo(jj) ~= 0 && ensayoBebedero(jj) ~= 0 && ensayoIntento(jj) ~= 0
%      indicesIntento(end+1) = jj;

inicioVentanas = ventanasEnsayos(1,:);
finVentanas    = ventanasEnsayos(2,:);

inicioVenOmisiones = inicioVentanas(indicesOmisiones);
finVenOmisiones    = finVentanas(indicesOmisiones);
omisiones          = [inicioVenOmisiones;finVenOmisiones];
ensayosOmisiones   = length(omisiones);

inicioVenConcluidos = inicioVentanas(indicesConcluidos);
finVenConcluidos    = finVentanas(indicesConcluidos);
concluidos          = [inicioVenConcluidos;finVenConcluidos];
ensayosConcluidos   = length(concluidos);

inicioVenErrores = inicioVentanas(indicesErrores);
finVenErrores    = finVentanas(indicesErrores);
errores          = [inicioVenErrores;finVenErrores];
ensayosErrores   = length(errores);

%Total porcentaje ensayos 
%EnsayosTotales = Aciertos, Errores, Intentos, Omisiones

numEnsayos     = length(ventanasEnsayos);
porAciertos    = (ensayosExito*100)/numEnsayos;
porOmisiones   = (ensayosOmisiones*100)/numEnsayos;
porErrores     = (ensayosErrores*100)/numEnsayos;
porIntentos    = (length(frameIntento)*100)/numEnsayos;
porProductivos = (ensayosEjecutados*100)/numEnsayos;

%Asignar que tipo de ensayo fue

tipoEnsayo = length(ventanasEnsayos);
tipoEnsayo(indicesConcluidos) = 1;
tipoEnsayo(indicesErrores) = 2;
tipoEnsayo(indicesOmisiones) = 3;
%tipoEnsayo(indicesIntento) = 4; %Mas adelante se podría con seguridad agregar este, sin embargo, puede ser variable y dar falsos positivos debido a que no siempre estan dentro de la ventana correspondiente



%Tiempos de reacción de los ensayos correctos
contador = 1;
for mm = 1:length(ensayoProductivo) 

    if ensayoProductivo(mm) >1 && ensayoGo(mm) >1

        beep                 = ensayoGo(mm);
        liberacionBarra      = ensayoProductivo(mm);
        tiemposReaccionFrame(contador)  = liberacionBarra - beep; %frames
        contador = contador + 1;

    end

end

tiemposReaccion = (tiemposReaccionFrame * frameXseg) / 1000;
promTR          = mean(tiemposReaccion);

figure(5), clf
subplot(2,1,1)
histogram(tiemposReaccion,60,"FaceColor",[0.4667    0.6745    0.1882])
%xlim([0 1])
title("Tiempos de Reacción","FontSize",16)
xlabel("tiempo (ms)","FontSize",14)
ylabel("Número de ensayos","FontSize",14)
set(gcf,'color','white')
set(gca,'TickDir','out','LineWidth',1.5)

%Tiempo Reaching
contador = 1;
for ll = 1:length(ensayoProductivo) 

    if ensayoProductivo(ll) > 1 && ensayoBebedero(ll) > 1

        inicioMovimiento      = ensayoProductivo(ll);
        contactoBebedero      = ensayoBebedero(ll);
        tiemposAlcanceFrame(contador)  = contactoBebedero - inicioMovimiento; %frames
        contador = contador + 1;

    end

end

tiemposAlcance     = (tiemposAlcanceFrame * frameXseg) / 1000;
tiempoAlcanceDelay = tiemposAlcance + 0.150; %Agregué esto porque es la duración de la bomba 
promTA             = mean(tiemposAlcance);
promTAD            = mean(tiempoAlcanceDelay);

figure(5),
subplot(2,1,2)
histogram(tiempoAlcanceDelay,60,"FaceColor",[0.6353    0.0784    0.1843])
xlim([0 1])
title("Tiempos de Alcance","FontSize",16)
xlabel("tiempo (s)","FontSize",14)
ylabel("Número de ensayos","FontSize",14)
set(gcf,'color','white')
set(gca,'TickDir','out','LineWidth',1.5)

%Guardar los datos en una matriz
numeEnsayos = 1:length(ventanasEnsayos);

%Guardar la informacion en ms
datos = NaN(length(ventanasEnsayos),5);
datos(1:length(numeEnsayos),1) = numeEnsayos';
datos(1:length(tipoEnsayo),2) = tipoEnsayo';
datos(1:length(durEnsayos),3) = durEnsayos';
datos(1:length(tiemposReaccion),4) = tiemposReaccion';
datos(1:length(tiemposAlcance),5) = tiemposAlcance';

writematrix(datos,[rata_sesion '_datos.csv'])

%Guardar informacion en frames
datos_frames = NaN(length(ventanasEnsayos),5);
datos_frames(1:length(numeEnsayos),1) = numeEnsayos';
datos_frames(1:length(tipoEnsayo),2) = tipoEnsayo';
datos_frames(1:length(durEnsayos),3) = durEnsayosFrames';
datos_frames(1:length(tiemposReaccion),4) = tiemposReaccionFrame';
datos_frames(1:length(tiemposAlcance),5) = tiemposAlcanceFrame';

writematrix(datos_frames,[rata_sesion '_datosFrames.csv'])

%Guardar información de la prductividad conductual
conducta = NaN(1,4);
conducta(1,1) = ensayosConcluidos; %Nuemero de ensayos que se ejecutaorn segun las reglas
conducta(1,2) = ensayosErrores; %Numero de ensayos erróneos
conducta(1,3) = ensayosOmisiones; %Numero de ensayos omitidos
conducta(1,4) = ensayosExito; %Numero de ensayos correctos
conducta(1,5) = ensayosIntento; %Numero de intentos

writematrix(datos_frames,[rata_sesion '_conducta.csv'])

conducta = NaN(1,4);
conducta_por(1,1) = porProductivos; %Nuemero de ensayos que se ejecutaorn segun las reglas
conducta_por(1,2) = porErrores; %Numero de ensayos erróneos
conducta_por(1,3) = porOmisiones; %Numero de ensayos omitidos
conducta_por(1,4) = porAciertos; %Numero de ensayos correctos
conducta_por(1,5) = porIntentos; %Numero de intentos

writematrix(datos_frames,[rata_sesion '_conducta_por.csv'])

end

 





