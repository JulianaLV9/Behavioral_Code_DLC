data   = readtable('angulos_distancias.xlsx','Sheet','Distancias_preparacion');

%Colores 
N = [ 0.4314    0.9804    0.9529];
I = [ 0.9294    0.4471    0.7451];
A = [ 0.6588    0.9294    0.4667];

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Graficos por fase
%Planeacion
%Hombro
figure;
b = boxchart(fase,data.Hombro,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia hombro preparación (fase)','FontSize',18) 

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Graficos por fase

%Codo 
figure;
b = boxchart(condicion,data.Codo,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia codo preparación (fase)','FontSize',18) 

%Muneca 
figure;
b = boxchart(condicion,data.Muneca,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia muneca preparación (fase)','FontSize',18) 


%% Ejecucion

data   = readtable('angulos_distancias.xlsx','Sheet','Distancias_ejecucion');

%Colores 
N = [ 0.4314    0.9804    0.9529];
I = [ 0.9294    0.4471    0.7451];
A = [ 0.6588    0.9294    0.4667];

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Ejecucion
%Hombro
figure;
b = boxchart(condicion,data.Hombro,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia hombro ejecución (fase)','FontSize',18) 

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Graficos por fase

%Codo 
figure;
b = boxchart(condicion,data.Codo,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia codo ejecución (tiempo)','FontSize',18) 

%Muneca 
figure;
b = boxchart(condicion,data.Muneca,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia muneca ejecución (fase)','FontSize',18) 

%% NOVATOS
data   = readtable('angulos_distancias.xlsx','Sheet','Dist_nov_prep');

%Colores 
N = [ 0.4314    0.9804    0.9529];
I = [ 0.9294    0.4471    0.7451];
A = [ 0.6588    0.9294    0.4667];

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Graficos por fase
%Planeacion
%Hombro
figure;
b = boxchart(condicion,data.Hombro,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia hombro preparación (nov)','FontSize',18) 

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Graficos por fase

%Codo 
figure;
b = boxchart(condicion,data.Codo,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia codo preparación (nov)','FontSize',18) 

%Muneca 
figure;
b = boxchart(condicion,data.Muneca,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia muneca preparación (nov)','FontSize',18) 


%% Ejecucion

data   = readtable('angulos_distancias.xlsx','Sheet','Dist_Nov_ejec');

%Colores 
N = [ 0.4314    0.9804    0.9529];
I = [ 0.9294    0.4471    0.7451];
A = [ 0.6588    0.9294    0.4667];

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Ejecucion
%Hombro
figure;
b = boxchart(condicion,data.Hombro,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia hombro ejecución (nov)','FontSize',18) 

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Graficos por fase

%Codo 
figure;
b = boxchart(condicion,data.Codo,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia codo ejecución (nov)','FontSize',18) 

%Muneca 
figure;
b = boxchart(condicion,data.Muneca,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia muneca ejecución (nov)','FontSize',18) 

%% INTEREMEDIOS
data   = readtable('angulos_distancias.xlsx','Sheet','Dist_Int_prep');

%Colores 
N = [ 0.4314    0.9804    0.9529];
I = [ 0.9294    0.4471    0.7451];
A = [ 0.6588    0.9294    0.4667];

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Graficos por fase
%Planeacion
%Hombro
figure;
b = boxchart(condicion,data.Hombro,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia hombro preparación (int)','FontSize',18) 

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Graficos por fase

%Codo 
figure;
b = boxchart(condicion,data.Codo,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia codo preparación (int)','FontSize',18) 

%Muneca 
figure;
b = boxchart(condicion,data.Muneca,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia muneca preparación (int)','FontSize',18) 


%% Ejecucion

data   = readtable('angulos_distancias.xlsx','Sheet','Dist_Int_ejec');

%Colores 
N = [ 0.4314    0.9804    0.9529];
I = [ 0.9294    0.4471    0.7451];
A = [ 0.6588    0.9294    0.4667];

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Ejecucion
%Hombro
figure;
b = boxchart(condicion,data.Hombro,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia hombro ejecución (int)','FontSize',18) 

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Graficos por fase

%Codo 
figure;
b = boxchart(condicion,data.Codo,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia codo ejecución (int)','FontSize',18) 

%Muneca 
figure;
b = boxchart(condicion,data.Muneca,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia muneca ejecución (int)','FontSize',18) 

%% AVANZADOS
data   = readtable('angulos_distancias.xlsx','Sheet','Dist_Ava_prep');

%Colores 
N = [ 0.4314    0.9804    0.9529];
I = [ 0.9294    0.4471    0.7451];
A = [ 0.6588    0.9294    0.4667];

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Graficos por fase
%Planeacion
%Hombro
figure;
b = boxchart(condicion,data.Hombro,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia hombro preparación (av)','FontSize',18) 

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Graficos por fase

%Codo 
figure;
b = boxchart(condicion,data.Codo,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia codo preparación (av)','FontSize',18) 

%Muneca 
figure;
b = boxchart(condicion,data.Muneca,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia muneca preparación (av)','FontSize',18) 


%% Ejecucion

data   = readtable('angulos_distancias.xlsx','Sheet','Dist_Ava_ejec');

%Colores 
N = [ 0.4314    0.9804    0.9529];
I = [ 0.9294    0.4471    0.7451];
A = [ 0.6588    0.9294    0.4667];

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Ejecucion
%Hombro
figure;
b = boxchart(condicion,data.Hombro,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia hombro ejecución (av)','FontSize',18) 

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});
condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Graficos por fase

%Codo 
figure;
b = boxchart(condicion,data.Codo,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia codo ejecución (av)','FontSize',18) 

%Muneca 
figure;
b = boxchart(condicion,data.Muneca,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; % Novatos
b(2).BoxEdgeColor = I; % Intermedios
b(3).BoxEdgeColor = A; % Avanzados
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylabel('Distancia (ua)','FontSize',14)
title('Distancia muneca ejecución (av)','FontSize',18) 