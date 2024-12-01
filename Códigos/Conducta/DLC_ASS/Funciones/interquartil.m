function [velocidad_out,aceleracion_out,indices_muneca_x_out,indices_muneca_y_out] = interquartil(velocidad,aceleracion,muneca_x,muneca_y)

%Numero de ensayos
[n_filas, n_columnas] = size(velocidad);

indices_velocidad     = NaN(n_filas, n_columnas);
indices_muneca_x_out  = NaN(n_filas, n_columnas);
indices_muneca_y_out  = NaN(n_filas, n_columnas);
velocidad_out         = NaN(n_filas, n_columnas);
aceleracion_out       = NaN(n_filas, n_columnas);

for ii = 1:n_columnas

    columna = velocidad(:,ii);
    columna = columna(~isnan(columna));

    Q1  = prctile(columna,25);
    Q3  = prctile(columna,75);
    IQR = Q3 - Q1;

    %Definir límites
    limite_inf = Q1 - 1.5 * IQR;
    limite_sup = Q3 + 1.5 * IQR;

    indices_validos = columna >= limite_inf & columna <= limite_sup; %Aquí saco aquellos valores que esten arriba de Q3 y menores a Q1

    indices_velocidad(indices_validos, ii) = columna(indices_validos);
    
    for jj = 1:length(columna) % Comenzar en la fila 2 ya que no hay n-1 para la fila 1
        if indices_validos(jj) == 1 % Si es un valor válido en velocidad
            indices_muneca_x_out(jj, ii)   = muneca_x(jj + 1, ii);
            indices_muneca_y_out(jj, ii)   = muneca_y(jj + 1, ii);
            velocidad_out(jj,ii)       = velocidad(jj, ii);

        end
    end

    for jj = 2:length(columna)
        if indices_validos(jj) == 1
        aceleracion_out(jj,ii) = aceleracion(jj - 1, ii);
        end 
    end

end


% %Aqui agregue este nuevo filtro esperando a que se limpien más esos puntos
% for ll = 1:n_columnas
% 
%     columna_x = indices_muneca_x(:,ll);
%     columna_x = columna_x(~isnan(columna_x));
%     columna_y = indices_muneca_y(:,ll);
%     columna_y = columna_y(~isnan(columna_y));
% 
%     %Voy a sacar outliers de acuerdo con la posicon en x
%     Q1_x  = prctile(columna_x,25);
%     Q3_x  = prctile(columna_x,75);
% 
%     %Definir límites
%     indices_columna_q1 = columna_x>Q1_x;
%     columna_x          = columna_x(indices_columna_q1);
%     columna_y          = columna_y(indices_columna_q1);
%     indices_columna_q3 = columna_x<Q3_x;
%     columna_x          = columna_x(indices_columna_q3);
%     columna_y          = columna_y(indices_columna_q3);
% 
% 
%     indices_muneca_x_out(1:length(columna_x),ll) = columna_x;
%     indices_muneca_y_out(1:length(columna_y),ll) = columna_y;
% 
% 
% end 

end