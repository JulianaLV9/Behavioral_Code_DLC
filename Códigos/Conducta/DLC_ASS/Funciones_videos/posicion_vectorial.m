function [magnitud_f,posicion_vectorial_tiempo_tiempo,brazo_visitado,posicion_recompenza,trayectorias_reescaladas,Tabla1]=posicion_vectorial(trayectorias_reconstruidas,indices_numeros,x_p_n,dist_origen_brazo,min_salida,figura)

%% Calcular Posicion Vectorial
% input: 
% 1 trayectorias_reconstruidas: Trayectorias de todos los ensayos reconstruidas
% 2 indices_numeros: Indices donde se encuentra el inicio y el final de un ensayo

% Parametros
% x_p_n: coordenada en "x" positiva/negativa que señala donde comienza uno de los brazos secundarios
% dist_origen_brazo: distancia minima desde el origen a uno de los brazos secundarios que se considera para indicar que el animal llego al sitio de recompensa
% min_salida: representa la distancia de la ultima coordenada, si es menor a un valor determinado se considera como la posiscion de salida

% output: 
% 1 magnitud_f: magnitud del vector de la pocision final respecto al origen 
% 2 magnitud_ttorigen: magnitud del vector tiempo a tiempo respecto al origen
% 3 brazo_visitado: 1 si visito el brazo negativo y 2 si visito el brazo positivo
% 4 posicion_recompenza: indice que señala cuando el raton alcanzo la recompenza
% 5 trayectorias_reescaladas: trayectorias reescaladas en el origen
% 6 Tabla: resumen con variabales de interes
%

if nargin<4
x_p_n = 50;
dist_origen_brazo = 325;
figura = 1;
min_salida = 15;
end
%

magnitud_f = zeros(length(indices_numeros),1);
posicion_vectorial_tiempo_tiempo = nan(length(trayectorias_reconstruidas),1);
trayectorias_reescaladas = nan(length(trayectorias_reconstruidas),2);

for i = 1:length(indices_numeros)

    trayectoria_n = trayectorias_reconstruidas(indices_numeros(i,1):indices_numeros(i,2),:);

    origen = trayectoria_n(1,:);
    pos_final = trayectoria_n(end,:);
    magnitud_f(i) = norm(pos_final-origen);

    magnitud_ttorigen_n = zeros(length(trayectoria_n),1);
    trayectorias_rescaladas_n = zeros(length(trayectoria_n),2);
    for j = 1:length(trayectoria_n)

        pos_tt = trayectoria_n(j,:);
        magnitud_ttorigen_n(j) = norm(origen-pos_tt); 
        trayectorias_rescaladas_n(j,:) = origen-pos_tt; % si se invieret la resta solo se rescala

    end
    magnitud_ttorigen_n(end) = magnitud_ttorigen_n(end-1)-1; % forza a que haya un maximo local

    posicion_vectorial_tiempo_tiempo(indices_numeros(i,1):indices_numeros(i,2)) = magnitud_ttorigen_n;
    trayectorias_reescaladas(indices_numeros(i,1):indices_numeros(i,2),:) = trayectorias_rescaladas_n;

end

recorrido_positivo = double(trayectorias_reescaladas(:,1)>x_p_n);
recorrido_negativo = double(trayectorias_reescaladas(:,1)<-x_p_n);

% Con la distancia tiempo a tiempo, calcular la distancia maxima (recompensa)
[pks,indices_pks] = findpeaks(posicion_vectorial_tiempo_tiempo,'MinPeakDistance',30,'MinPeakHeight',dist_origen_brazo);


% encontrar las posiciones donde el animal llego a la recompensa dentro de un mismo ensayo
posicion_recompenza = zeros(length(indices_numeros),100);
recorrido_positivo_t = nan(length(indices_numeros),100);
for i = 1:length(indices_numeros)
    indice_n = indices_pks(indices_numeros(i,1)<indices_pks & indices_pks<indices_numeros(i,2))';
    posicion_recompenza(i,1:length(indice_n)) = indice_n;
    rp = recorrido_positivo(indice_n);
    recorrido_positivo_t(i,1:length(rp)) = rp+1; % 1=negativo y 2=positivo
end

% Redimensionar la matriz
[~,c]= find(posicion_recompenza, 1, 'last' );
posicion_recompenza = posicion_recompenza(:,1:c);
recorrido_positivo_t = recorrido_positivo_t(:,1:c);

% Crear tabla para guardar los indices de las trayectorias
inicio_ensayo =  indices_numeros(:,1);
fin_ensayo = indices_numeros(:,2);
brazo_visitado = recorrido_positivo_t;
posicion_salida = magnitud_f<min_salida; % Distancia maxima para encontrar al raton en el origen

id_ensayo = (1:length(indices_numeros))';

Tabla1 = table(id_ensayo,inicio_ensayo,fin_ensayo,posicion_recompenza,brazo_visitado,posicion_salida);

% Graficar magnitud del vector tiempo a tiempo respecto al origen y distancia maxima, que es donde se encuentra la recompensa.
if figura==1
    figure

    subplot(2,1,1)
    hold on
    y = posicion_vectorial_tiempo_tiempo(indices_pks);
    plot(posicion_vectorial_tiempo_tiempo,LineWidth=2)
    plot(indices_pks,y,'*','Color','r',MarkerSize=10)
    title("Ubicacion de brazos secundarios")
    xlabel('tiempo')
    ylabel("distancia")

    subplot(2,1,2)
    hold on
    y = ones(length(indices_pks));
  
    plot(recorrido_positivo);
    plot(recorrido_negativo);
    plot(indices_pks,y,'*','Color','r',MarkerSize=10)
    legend('recorrido positivo','recorrido negativo','idx recompenza')
    title("Tipo de recorrido")
    xlabel("tiempo")

    hold off

end


end