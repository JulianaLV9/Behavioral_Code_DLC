function [trayectorias_reconstruidas,indices_numeros,indices_nans]=eval_trayectorias(trayectorias,nans_max,dist_min)
%% Evaluar el estado de los trayectorias y separarlas en funcion de los nans.
% input:
% 1 trajectories: Son las coordenadas de las trayectorias del del animal durante tada la sesion, cada ensayo esta separado por nans 
% 2 nans_max: Numero de nans maximos permitidos en las trayectorias si se pierde el animal  
% 3 dist_min: distancia minima acumulada en el ensayo. En las trayectorias discontinuas, la distancia acumulada es menor que una completa, por tanto si son menor que dist_min se rellenan con NaNs

% output:
% 1 trayectorias_reconstruidas: Trayectorias sin discontinuidades
% 2 indices_num: Inicio y final de la trayectorias por ensayo (divididas por los nans)
% 3 indices_nans: Inicio y final de los nans (divididas por los numeros)

% Parametros
% nans_max = 200;
% dist_min = 200; 

tr = trayectorias;
flag = 1;

trayectoriasflip = flip(trayectorias(:,1));
trayectoriasflip(isnan(trayectoriasflip)) = 0;
trayectoriasflip_nans = find(trayectoriasflip,1)-2;

trayectorias(end-trayectoriasflip_nans:end,:) = [];

while flag==1
flag = 0;

    % Cuantificar la longitud de las trayectorias y de los nans para encontrar posibles discontinuidades
    
    % Para los nans
    nans = isnan(trayectorias(:,1));
    indices_nans = [];
    indices_nans(:,2) = find(diff(nans)==-1);
    indices_nans(2:end,1) = find(diff(nans)==1);
    indices_nans(1,1) = 0;
    indices_nans(:,1) = indices_nans(:,1)+1;
    contar_nans = indices_nans(:,2) - indices_nans(:,1);

    % Reemplazar los nans por la cordenada siguiente si se encuentran menos de "nans_max"  consecutivos
    id_remplazar_nan = find(contar_nans<nans_max);

    if id_remplazar_nan>0
        for j = 1:length(id_remplazar_nan)
            trayectorias(indices_nans(id_remplazar_nan(j),1):indices_nans(id_remplazar_nan(j),2),:) =...
            trayectorias(indices_nans(id_remplazar_nan(j),2)+1,:).*ones(contar_nans(id_remplazar_nan(j))+1,2);      
        end
        flag = 1;
    end

    % Para las coordenadas
    numeros = trayectorias(:,1)>0;
    indices_numeros = [];
    indices_numeros(:,1) = find(diff(numeros)==1);
    indices_numeros(1:length(indices_numeros)-1,2) = find(diff(numeros)==-1);
    indices_numeros(end,end) = length(numeros);
    indices_numeros(:,1) = indices_numeros(:,1)+1;

    % Calcular la distancia acumulada para encontrar los segmentos discontinuos
    distancia_acumulada = zeros(length(indices_numeros),1);

    for j = 1:length(distancia_acumulada)        
        trayectoria_n = trayectorias(indices_numeros(j,1):indices_numeros(j,2),:);
        distancia_acumulada(j)  = sum(sqrt(sum((diff(trayectoria_n).^2),2)));
    end
  
    % Remplazar las coordenadas por nans donde se detecto al animal por menos de 20 bines consecutivos
    id_remplazar_num = find(distancia_acumulada<dist_min); % 20 es un umbral que se considero pensando en que el animal pudo perderse 1s
    if id_remplazar_num>0
        for j = 1:length(id_remplazar_num)
            trayectorias(indices_numeros(id_remplazar_num(j),1):indices_numeros(id_remplazar_num(j),2),:) = nan;
        end
        flag = 1;
    end

end
trayectorias_reconstruidas = trayectorias;
end