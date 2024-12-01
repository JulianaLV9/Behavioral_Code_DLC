% Codigo para sacar los eventos de la conducta a través de la señal de ...
% los leds

clc, clearvars
close all

[~, path_name, data_archivo_videos, ~, ~] = LoadFiles; %Seleccion de todos los videos
nombres = ["ensayo","go","barra","correcto","intento","opto"];

umbral_saturacion = 0.7;

[~,~,eventos_conducta,posiciones] = seniales(nombres,umbral_saturacion,path_name,data_archivo_videos);

protocolo = 'planeacion'; %Indicar si es planeacion o ejecucion

%% Sacar los eventos 

    archivo     = data_archivo_videos{1,1};
    nombre      = extractBetween(archivo, 'Optogenética\','\');
    rata_sesion = [nombre{1}];

%Tasa de muestreo de los videos
tasaMuestreo  = 1000/16.67;%frames/segundos del video
frameXseg     = 1000/tasaMuestreo; %ms/tasaMuestreo
framesTotales = (1:length(eventos_conducta.seniales_binarias));%ms
tiempoFrames  = (frameXseg * framesTotales) / 1000; %segundos 

% Eventos a segundos 
eventosAseg   = table2array(eventos_conducta.se_bin) .* tiempoFrames';

%Sacar el vector de cada uno de los leds 
ensayos       = eventos_conducta.seniales_binarias(1,600:26000);
senal_go      = eventos_conducta.seniales_binarias(2,600:26000);
barra         = eventos_conducta.seniales_binarias(3,600:26000);
correcto      = eventos_conducta.seniales_binarias(4,600:26000); %Importante considerar que esta información no es certera de cuando llegaron a la barra
intento       = eventos_conducta.seniales_binarias(5,600:26000);
opto          = eventos_conducta.seniales_binarias(6,600:26000);

%Inicio de los eventos 
inicioEnsayos      = islocalmax(ensayos,'FlatSelection','first',MinSeparation=10); 
inicioSenalGo      = islocalmax(senal_go,'FlatSelection','first',MinSeparation=10);
liberacionBarra    = islocalmax(barra,'FlatSelection','first',MinSeparation=10);  %5 es equivalente aprox a 85 ms de separacion
contactoGota       = islocalmax(correcto,'FlatSelection','first',MinSeparation=10);
totalIntentos      = islocalmax(intento,'FlatSelection','first',MinSeparation=10); %Es para saber el #de intentos y descontarlo a los ensayos correctos
senalOptoF         = islocalmax(opto,'FlatSelection','first',MinSeparation=1);
senalOptoL         = islocalmax(opto,'FlatSelection','last',MinSeparation=1);

%Verificar que efectivamente esta marcando el inicio de los eventos ¡¡¡ESTO
%SE PUEDE RETIRAR DESPUÉS!!!
frames = length(1:length(ensayos));
figure(4), clf
subplot(611)
plot(framesTotales(1:frames),ensayos(1:frames),framesTotales(inicioEnsayos(1:frames)),ensayos(inicioEnsayos(1:frames)),'r*');
subplot(612)
plot(framesTotales(1:frames),senal_go(1:frames),framesTotales(inicioSenalGo(1:frames)),senal_go(inicioSenalGo(1:frames)),'r*');
subplot(613)
plot(framesTotales(1:frames),barra(1:frames),framesTotales(liberacionBarra(1:frames)),barra(liberacionBarra(1:frames)),'r*');
subplot(614)
plot(framesTotales(1:frames),correcto(1:frames),framesTotales(contactoGota(1:frames)),correcto(contactoGota(1:frames)),'r*');
subplot(615)
plot(framesTotales(1:frames),intento(1:frames),framesTotales(totalIntentos(1:frames)),intento(totalIntentos(1:frames)),'r*');
subplot(616)
plot(framesTotales(1:frames),opto(1:frames),framesTotales(senalOptoF(1:frames)),opto(senalOptoF(1:frames)),'r*');

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

%Sacar la duracion de la estimulacion
inicioLed = find(senalOptoF); %Indices del inicio de la estimulacion
finalLed  = find(senalOptoL); %Indices del final de la estimulacion
duraLed   = finalLed - inicioLed; %Duracion de la estimulacion

%Ensayos Correctos e Intentos
frameCorrecto     = find(contactoGota == 1);
frameIntento      = find(totalIntentos == 1);
frameOpto         = find(senalOptoF == 1);
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
ensayoOpto       = zeros(1,length(ventanasEnsayos));

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
indicesOpto       = [];


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

%Sacar en que ensayo se realizo la inhibicion
indicesOpto = zeros(1,length(ventanasEnsayos));
contOpto = 1;
maxStim = length(frameOpto);

while contOpto <= maxStim-1
    for jj = 1:length(ventanasEnsayos)
        %Sacar indices
        ventanaActual    = ventanasEnsayos(1,jj):ventanasEnsayos(2,jj);
        frameActual      = frameOpto(1,contOpto);
        stimOpto         = find(ismember(frameActual, ventanaActual));

        if stimOpto == 0
            indicesOpto(1, jj) = 0;
        elseif stimOpto == 1
            indicesOpto(1, jj) = stimOpto;
            contOpto = contOpto + 1;
        end
    end
end
   
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
for kk = 1:length(ensayoProductivo) 

    if ensayoProductivo(kk) >1 && ensayoGo(kk) >1

        beep                 = ensayoGo(kk);
        liberacionBarra      = ensayoProductivo(kk);
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

writematrix(datos,['E:\Datos_videos\datos_general\' rata_sesion '_datos.csv'])

%Guardar informacion en frames
datos_frames = NaN(length(ventanasEnsayos),5);
datos_frames(1:length(numeEnsayos),1) = numeEnsayos';
datos_frames(1:length(tipoEnsayo),2) = tipoEnsayo';
datos_frames(1:length(durEnsayos),3) = durEnsayosFrames';
datos_frames(1:length(tiemposReaccion),4) = tiemposReaccionFrame';
datos_frames(1:length(tiemposAlcance),5) = tiemposAlcanceFrame';

writematrix(datos_frames,['E:\Datos_videos\datos_frames\' rata_sesion '_datosFrames.csv'])

%Guardar información de la prductividad conductual
conducta = NaN(1,4);
conducta(1,1) = ensayosConcluidos; %Nuemero de ensayos que se ejecutaorn segun las reglas
conducta(1,2) = ensayosErrores; %Numero de ensayos erróneos
conducta(1,3) = ensayosOmisiones; %Numero de ensayos omitidos
conducta(1,4) = ensayosExito; %Numero de ensayos correctos
conducta(1,5) = ensayosIntento; %Numero de intentos

writematrix(conducta,['E:\Datos_videos\conducta\' rata_sesion '_conducta.csv'])

conducta = NaN(1,4);
conducta_por(1,1) = porProductivos; %Nuemero de ensayos que se ejecutaorn segun las reglas
conducta_por(1,2) = porErrores; %Numero de ensayos erróneos
conducta_por(1,3) = porOmisiones; %Numero de ensayos omitidos
conducta_por(1,4) = porAciertos; %Numero de ensayos correctos
conducta_por(1,5) = porIntentos; %Numero de intentos

writematrix(conducta_por,['E:\Datos_videos\porcentaje_conducta\' rata_sesion '_conducta_por.csv'])

 








