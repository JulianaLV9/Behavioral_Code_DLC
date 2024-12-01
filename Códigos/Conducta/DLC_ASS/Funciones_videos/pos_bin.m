function posicion_binarizada = pos_bin(posicion_vectorial_tiempo_tiempo,numero_bines)

% Convierte la posicion linearizada continua a una posicion liniarizada categorica.

% Input: 
% magnitud_ttorigen: posicion de los animales linearizada.
% numero de bines: Segmentos en los que se dividira la trayectoria

% Output
% posicion_binarizada: convierte la posicion liniarizada continua a una posicion liniarizada categorica. 


posicion_binarizada = nan(size(posicion_vectorial_tiempo_tiempo));

h = histogram(posicion_vectorial_tiempo_tiempo,NumBins=numero_bines);

edges = h.BinEdges;

for i = 1:length(edges)-1
    f = edges(i);
    e = edges(i+1);
    posicion_binarizada(posicion_vectorial_tiempo_tiempo>=f & posicion_vectorial_tiempo_tiempo<e)=i;
end

close
end