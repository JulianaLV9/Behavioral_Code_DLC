function [base_datos] = extender(senial_bin,Tabla1) 
%% Agregar la informacion "Eventos_conducta"
load('Eventos conducta_04-May-2023.mat')
senial_row = eventos_conducta.senial_row;
senial_bin = eventos_conducta.seniales_binarias;

% fila donde se encuentra el estimulo
luz = 1;
tono = 2;
puerta = 3;
ani = 4;


estimulo_luz = senial_bin(luz,:);
estimulo_tono = senial_bin(tono,:);
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

puerta_apertura = senial_row(puerta,:)>0.99;
idx_puerta_apertura = (find(diff(puerta_apertura)==-1)+1)';
Tabla1.idx_puerta_apertura = idx_puerta_apertura;

% deteccion de animal

animal = senial_bin(ani,:);
plot(animal)
idx_animal = (find(diff(animal)==-1)+1)';
Tabla1.idx_animal = idx_animal;

Tabla1.Latencias = Tabla1.idx_animal-idx_puerta_apertura;











