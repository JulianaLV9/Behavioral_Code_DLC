function [base_datos] = extender_bd(senial_binaria,Tabla1) 
%% Agregar la informacion "Eventos_conducta"
 

% fila donde se encuentra el estimulo
luz = 1;
tono = 2;
puerta = 3;
% animal = 4;

estimulo_luz = senial_binaria(luz,:);
estimulo_tono = senial_binaria(tono,:);
intervalo = estimulo_luz + estimulo_tono;
estimulo_tono(estimulo_tono==1)=2;
estimulos = estimulo_luz + estimulo_tono;
tipo_estimulos = diff(estimulos);
tipo_estimulos = tipo_estimulos(tipo_estimulos>0)';


Tabla1.tipo_estimulo = tipo_estimulos;

% intervalo del estimulo

intervalo_estimulos(:,1) = find(diff(intervalo)==1)+1;
intervalo_estimulos(:,2) = find(diff(intervalo)==-1);

Tabla1.intervalo_estimulos = intervalo_estimulos;

% Apertura de puerta

puerta_apertura = senial_binaria(puerta,:);
idx_puerta_apertura = (find(diff(puerta_apertura)==-1)+1)';
Tabla1.idx_puerta_apertura = idx_puerta_apertura;

% % deteccion de animal
% animal_completa = eventos_conducta.senial_row(animal,:);
% id_p = Tabla1(:,"idx_puerta_apertura");
% id_f = Tabla1(:,"fin_ensayo");
% id_f = id_f.Variables;
% id_p = id_p.Variables;
% idx_animal = zeros(1,length(id_p));
% for i =1:length(id_p)
%     animal_n = animal_completa(id_p(i):id_f(i));
%     animal_n = animal_n > 0.9;
%     idx_animal_n = find(diff(animal_n),1);
%     idx_animal(i) = idx_animal_n;
% end
% 
% Tabla1.idx_animal = idx_animal';

Tabla1.Latencias = Tabla1.inicio_ensayo-idx_puerta_apertura;
base_datos = Tabla1;



end










