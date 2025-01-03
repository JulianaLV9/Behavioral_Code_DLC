% Codigo para sacar los eventos de la conducta a través de la señal de ...
% los leds

clc, clearvars
close all
format longG

[~, path_name, data_archivo_videos, ~, ~] = LoadFiles; %Seleccion de todos los videos
nombres = ["ensayo","go","barra","correcto","intento","posicion_bebedero","posicion_barra"];


umbral_saturacion = 0.9;

[~,~,eventos_conducta,posiciones] = seniales(nombres,umbral_saturacion,path_name,data_archivo_videos);    

%%
rata_sesion = input('Nombre de la rata y sesion: ','s');
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

%Inicio de los eventos para cada uno de los componentes
inicioEnsayos      = islocalmax(ensayos,'FlatSelection','first',MinSeparation=10); 
inicioSenalGo      = islocalmax(senal_go,'FlatSelection','first',MinSeparation=10);
liberacionBarra    = islocalmax(barra,'FlatSelection','first',MinSeparation=10);  %5 es equivalente aprox a 85 ms de separacion
contactoGota       = islocalmax(correcto,'FlatSelection','first',MinSeparation=10);
totalIntentos      = islocalmax(intento,'FlatSelection','first',MinSeparation=10); %Es para saber el #de intentos y descontarlo a los ensayos correctos

%Verificar que efectivamente esta marcando el inicio de los eventos ¡¡¡ESTO
%SE PUEDE RETIRAR DESPUÉS!!!
frames = 12000;
figure, clf
subplot(511), title('Inicio ensayos')
hold on
plot(framesTotales(1:frames),ensayos(1:frames),framesTotales(inicioEnsayos(1:frames)),ensayos(inicioEnsayos(1:frames)),'r*');
subplot(512),title('Senal go')
hold on
plot(framesTotales(1:frames),senal_go(1:frames),framesTotales(inicioSenalGo(1:frames)),senal_go(inicioSenalGo(1:frames)),'r*');
subplot(513), title('Liberacion barra')
hold on
plot(framesTotales(1:frames),barra(1:frames),framesTotales(liberacionBarra(1:frames)),barra(liberacionBarra(1:frames)),'r*');
subplot(514), title('Contacto bebedero')
hold on
plot(framesTotales(1:frames),correcto(1:frames),framesTotales(contactoGota(1:frames)),correcto(contactoGota(1:frames)),'r*');
subplot(515), title('Intento')
hold on
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

figure, clf
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

    % %Guardar la informacion en ms
    datos = NaN(length(ventanasEnsayos),5);
    datos(1:length(numeEnsayos),1) = numeEnsayos';
    datos(1:length(tipoEnsayo),2) = tipoEnsayo';
    datos(1:length(durEnsayos),3) = durEnsayos';
    datos(1:length(tiemposReaccion),4) = tiemposReaccion';
    datos(1:length(tiemposAlcance),5) = tiemposAlcance';
    % 
    % writematrix(datos,['E:\Datos_videos\datos_general\' rata_sesion '_datos.csv'])
    % 
    % %Guardar informacion en frames
    datos_frames = NaN(length(ventanasEnsayos),5);
    datos_frames(1:length(numeEnsayos),1) = numeEnsayos';
    datos_frames(1:length(tipoEnsayo),2) = tipoEnsayo';
    datos_frames(1:length(durEnsayos),3) = durEnsayosFrames';
    datos_frames(1:length(tiemposReaccion),4) = tiemposReaccionFrame';
    datos_frames(1:length(tiemposAlcance),5) = tiemposAlcanceFrame';

    % writematrix(datos_frames,['E:\Datos_videos\datos_frames\' rata_sesion '_datosFrames.csv'])
    % 
    % %Guardar información de la prductividad conductual
    conducta = NaN(1,4);
    conducta(1,1) = ensayosConcluidos; %Nuemero de ensayos que se ejecutaorn segun las reglas
    conducta(1,2) = ensayosErrores; %Numero de ensayos erróneos
    conducta(1,3) = ensayosOmisiones; %Numero de ensayos omitidos
    conducta(1,4) = ensayosExito; %Numero de ensayos correctos
    conducta(1,5) = ensayosIntento; %Numero de intentos
    % 
    % writematrix(conducta,['E:\Datos_videos\conducta\' rata_sesion '_conducta.csv'])
    % 
    conducta_por = NaN(1,4);
    conducta_por(1,1) = porProductivos; %Nuemero de ensayos que se ejecutaorn segun las reglas
    conducta_por(1,2) = porErrores; %Numero de ensayos erróneos
    conducta_por(1,3) = porOmisiones; %Numero de ensayos omitidos
    conducta_por(1,4) = porAciertos; %Numero de ensayos correctos
    conducta_por(1,5) = porIntentos; %Numero de intentos
    % 
    % writematrix(conducta_por,['E:\Datos_videos\porcentaje_conducta\' rata_sesion '_conducta_por.csv'])

% Ordenar informacion de los eventos en frames 
Total_Ensayos  = (1:length(ventanasEnsayos))'; 
Tipo_Ensayo    = tipoEnsayo';
Inicio_Ensayos = ventanasEnsayos(1,:)';
Fin_Ensayos    = ventanasEnsayos(2,:)';
Dur_Ensayos    = Fin_Ensayos - Inicio_Ensayos;
Go_Cue         = find(inicioSenalGo == 1);
Barra          = frameBarra;
Recompensa     = find(contactoGota == 1);
Intentos       = find(totalIntentos ==1);

% Acomodar los eventos segun el numero de ensayos
[Go_Cue_essay,Bar_essay,Recompensa_essay,Intentos_essay] = alineacion_tablas(ventanasEnsayos,Inicio_Ensayos,Fin_Ensayos,Go_Cue,Barra,Recompensa,Intentos);

%Leer csv de la tarea conducutal directamente del ASS (proviene de arduino)
%%nombre_archivo = extractBetween(archivo,'Reaching_task/', '/'); %Depende de la carpeta en la que se encuentre se modifique 
%nombre_csv = extractBetween(archivo,'Desktop/', '/'); %Aquí revisar bien de donde estamos obteniendo los archivos csv
nombre_csv = rata_sesion;
conducta_info = readtable([nombre_csv '.csv']);
dur_planeacion = conducta_info(:,2);
Planeacion = table2array(dur_planeacion(1:length(Total_Ensayos),1));
tareaInfo = table(Total_Ensayos,Tipo_Ensayo,Inicio_Ensayos,Fin_Ensayos,Dur_Ensayos,Planeacion,Go_Cue_essay,Bar_essay,Recompensa_essay,Intentos_essay);

% %Verificacion de led correcto 
%[tareaInfo] = verificacion(conducta_info,tareaInfo);

%Condición de filtrado de datos
filtro_500  = tareaInfo.Planeacion==500;
filtro_1000 = tareaInfo.Planeacion==1000;
filtro_1500 = tareaInfo.Planeacion==1500;

%Aplicar el filtro
ensayo_500  = tareaInfo(filtro_500, :);
ensayo_1000 = tareaInfo(filtro_1000, :);
ensayo_1500 = tareaInfo(filtro_1500, :);

% Clasificar las trayectorias de acuerdo con el tipo de ensayo
correcto_500 = ensayo_500(ensayo_500.Tipo_Ensayo==1,:);
error_500    = ensayo_500(ensayo_500.Tipo_Ensayo==2,:);
omision_500  = ensayo_500(ensayo_500.Tipo_Ensayo==3,:);
intento_500  = ensayo_500(ensayo_500.Tipo_Ensayo==4,:);

correcto_1000 = ensayo_1000(ensayo_1000.Tipo_Ensayo==1,:);
error_1000    = ensayo_1000(ensayo_1000.Tipo_Ensayo==2,:);
omision_1000  = ensayo_1000(ensayo_1000.Tipo_Ensayo==3,:);
intento_1000  = ensayo_1000(ensayo_1000.Tipo_Ensayo==4,:);

correcto_1500 = ensayo_1500(ensayo_1500.Tipo_Ensayo==1,:);
error_1500    = ensayo_1500(ensayo_1500.Tipo_Ensayo==2,:);
omision_1500  = ensayo_1500(ensayo_1500.Tipo_Ensayo==3,:);
intento_1500  = ensayo_1500(ensayo_1500.Tipo_Ensayo==4,:);

% Concatenar todos los datos por frames con las trayectorias de DLC y realizar los recortes de las trayectorias
[dlc_matrix] = dlc_informacion; %Aquí se van a elegir todos los archivos csv de la sesion para concatenarse

set(0, 'DefaultFigureWindowStyle', 'docked'); %Anclar figuras
%Delimitar zona de trayectorias
[umbral_barra, umbral_bebedero,umbral_actividad] = zona_trayectoria(posiciones);

%Clasificacion de la informacion postural de los datos segun el tipo de ensayo
[plan_500,plan_1000,plan_1500,ejec_500,ejec_1000,ejec_1500,correcto_out_500,correcto_out_1000,correcto_out_1500] = clasificador_posturas(correcto_500,correcto_1000,correcto_1500,dlc_matrix,umbral_barra,umbral_bebedero,umbral_actividad);

%Sacar angulos polares 
[angulos_polares,distancias_polares] = coord_polares(umbral_barra,plan_500,plan_1000,plan_1500,ejec_500,ejec_1000,ejec_1500);

%Sacar angulos apendiculares y axiales
%[angulos_500,angulos_1000,angulos_1500] = postura(plan_500,plan_1000,plan_1500,ejec_500,ejec_1000,ejec_1500); 

[trayec_500,trayec_1000,trayec_1500,tabla_cinematica_500,tabla_cinematica_1000,tabla_cinematica_1500] = primera_trayectoria(correcto_out_500,correcto_out_1000,correcto_out_1500,dlc_matrix,umbral_barra,umbral_bebedero);

%% Guardar la matrices necesarias

%Directorio donde se van a guardar
dir = uigetdir; %Seleccionar el directorio donde se quiere guardar la informacion

%Informacion de la tarea
save([dir '/' nombre_csv '_tareaInfo.mat'],"tareaInfo")
% 
% %Datos posturales planeacion y ejecucion
save([dir '/' nombre_csv '_plan_500.mat'],"plan_500")
save([dir '/' nombre_csv '_plan_1000.mat'],"plan_1000")
save([dir '/' nombre_csv '_plan_1500.mat'],"plan_1500")
save([dir '/' nombre_csv '_ejec_500.mat'],"ejec_500")
save([dir '/' nombre_csv '_ejec_1000.mat'],"ejec_1000")
save([dir '/' nombre_csv '_ejec_1500.mat'],"ejec_1500")

%Datos angulos
save([dir '/' nombre_csv '_angulos_polares.mat'],"angulos_polares")
save([dir '/' nombre_csv '_distancias_polares.mat'],"distancias_polares")

% %Trayectorias
save([dir '/' nombre_csv '_trayec_500.mat'],"trayec_500")
save([dir '/' nombre_csv '_trayec_1000.mat'],"trayec_1000")
save([dir '/' nombre_csv '_trayec_1500.mat'],"trayec_1500")
% 
% %Informacion cinematica
save([dir '/' nombre_csv '_tabla_cinematica_500.mat'],"tabla_cinematica_500")
save([dir '/' nombre_csv '_tabla_cinematica_1000.mat'],"tabla_cinematica_1000")
save([dir '/' nombre_csv '_tabla_cinematica_1500.mat'],"tabla_cinematica_1500")

%Informacion velocidades
%save([dir nombre_csv '_velocidades_totales.csv'],"velocidades_totales")

%%
close all
clearvars


