function [base_filtrada] = filtrar_base(base_datos,tipo)
% lc = luz correcto
% tc = tono correcto 
% li = luz incorrecto
% ti = tono incorrecto

selecionar_tipo_ensayo = tipo;


if strcmp(selecionar_tipo_ensayo,'lc')
    bv = base_datos(base_datos.brazo_visitado(:,1)==2,:);
    base_filtrada = bv(bv.tipo_estimulo==1,:);
elseif strcmp(selecionar_tipo_ensayo,'tc')
    bv = base_datos(base_datos.brazo_visitado(:,1)==1,:);
    base_filtrada = bv(bv.tipo_estimulo==2,:);
elseif strcmp(selecionar_tipo_ensayo,'li')
    bv = base_datos(base_datos.brazo_visitado(:,1)==1,:);
    base_filtrada = bv(bv.tipo_estimulo==1,:);
elseif strcmp(selecionar_tipo_ensayo,'ti')
    bv = base_datos(base_datos.brazo_visitado(:,1)==2,:);
    base_filtrada = bv(bv.tipo_estimulo==2,:);
elseif strcmp(selecionar_tipo_ensayo,'uno')
    base_filtrada = base_datos(base_datos.brazo_visitado(:,1)==1,:);
elseif strcmp(selecionar_tipo_ensayo,'dos')
    base_filtrada = base_datos(base_datos.brazo_visitado(:,1)==2,:);
else 
    base_filtrada = base_datos;
end
