function [esqueleto_general_x, esqueleto_general_y, correcto_out] = outliers(esqueleto_completo_x, esqueleto_completo_y, correcto, umbral_actividad)

hombroX = esqueleto_completo_x(:,2);
hombroY = esqueleto_completo_y(:,2);
codoX   = esqueleto_completo_x(:,3);
codoY   = esqueleto_completo_y(:,3);
munecaX = esqueleto_completo_x(:,4);
munecaY = esqueleto_completo_y(:,4);
centroX = esqueleto_completo_x(:,5);
centroY = esqueleto_completo_y(:,5);

%Filtrar todas las extremidades que esten fuera de este limite
umbral_inferior = umbral_actividad(1,2) + 80; % Este es el limite inferior del bebedero + 200 px por si el codo queda debajo y recordar que esta invertido ell eje 
indices_in_x = esqueleto_completo_x < (umbral_actividad(1,1) - 150) & esqueleto_completo_x > (umbral_actividad(1,3)); %Le di al umbral de actividad un poc mas de pixeles pensando en que la extremidad puede estar por alla
indices_in_y = esqueleto_completo_y > umbral_inferior;

indice_x = any(indices_in_x, 2);
indice_y = any(indices_in_y, 2);

nan_in_x = any(isnan(esqueleto_completo_x), 2);
nan_in_y = any(isnan(esqueleto_completo_y), 2);


eliminacion = (indice_x | indice_y) | nan_in_x | nan_in_y;

esqueleto_general_x = esqueleto_completo_x(~eliminacion, :);
esqueleto_general_y = esqueleto_completo_y(~eliminacion, :);
correcto_out = correcto(~eliminacion, :);

end
