function [umbral_barra, umbral_bebedero, umbral_actividad] = zona_trayectoria(posiciones)

umbral_barra    = posiciones(7,:); %Cambiar rsto por 7 porque ne este me equivoque
umbral_bebedero = posiciones(6,:); %Cambiar rsto por 6 porque ne este me equivoque
umbral_actividad = [umbral_barra(1,1),umbral_barra(1,2),umbral_bebedero(1,1),umbral_bebedero(1,2)]; %barra(x),barra(y),bebedero(x),bebedero(y)

end