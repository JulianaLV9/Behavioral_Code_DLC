%Box plots de cinematica

data_n = readtable('tabla_general_cinematica_LoteAyB.xlsx','Sheet','Novatos');
data_i = readtable('tabla_general_cinematica_LoteAyB.xlsx','Sheet','Intermedios');
data_a = readtable('tabla_general_cinematica_LoteAyB.xlsx','Sheet','Avanzados');
data   = readtable('tabla_general_cinematica_LoteAyB.xlsx','Sheet','Todo');

%Colores 
N = [ 0.4314    0.9804    0.9529];
I = [ 0.9294    0.4471    0.7451];
A = [ 0.6588    0.9294    0.4667];

fase = categorical(data.Fase, {'Novatos', 'Intermedios', 'Avanzados'});

%Graficos por fase

%Tiempo de reaccion
figure;
b = boxchart(fase,data.tiempo_reaccion,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylim([0 1])
ylabel('Tiempo de reacción (s)','FontSize',14)
title('Tiempo de reacción (Fases)','FontSize',18) 


%Duracion
figure;
b = boxchart(fase,data.duracion,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylabel('Duración (s)','FontSize',14)
title('Duración (Fases)','FontSize',18) 

%Velocidad
figure;
b = boxchart(fase,data.velocidad,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad (Fases)','FontSize',18) 

%Velocidad_alcance
figure;
b = boxchart(fase,data.velocidad_alcance,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad alcance (Fases)','FontSize',18) 

%Velocidad_retorno
figure;
b = boxchart(fase,data.velocidad_retorno,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad retorno (Fases)','FontSize',18) 

% Graficos por tiempo de prepracion
condicion = categorical(data_n.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi

%Novatos
%Tiempo de reaccion 
figure;
b = boxchart(condicion,data_n.tiempo_reaccion,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylim([0 1])
ylabel('Tiempo de reacción (s)','FontSize',14)
title('Tiempo de reacción (Nov)','FontSize',18) 

%Duracion
figure;
b = boxchart(condicion,data_n.duracion,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylabel('Duración (s)','FontSize',14)
title('Duración (Nov)','FontSize',18) 

%Velocidad
figure;
b = boxchart(condicion,data_n.velocidad,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad (Nov)','FontSize',18) 

%Velocidad alcance
figure;
b = boxchart(condicion,data_n.velocidad_alcance,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad alcance (Nov)','FontSize',18) 

%Velocidad retorno
figure;
b = boxchart(condicion,data_n.velocidad_retorno,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; 
b(2).BoxEdgeColor = I; 
b(3).BoxEdgeColor = A; 
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad retorno (Nov)','FontSize',18) 

%Intermedios
condicion = categorical(data_i.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi
%Tiempo de reaccion 
figure;
b = boxchart(condicion,data_i.tiempo_reaccion,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylim([0 1])
ylabel('Tiempo de reacción (s)','FontSize',14)
title('Tiempo de reacción (Int)','FontSize',18) 

%Duracion
figure;
b = boxchart(condicion,data_i.duracion,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylabel('Duración (s)','FontSize',14)
title('Duración (Int)','FontSize',18) 

%Velocidad
figure;
b = boxchart(condicion,data_i.velocidad,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad (Int)','FontSize',18) 

%Velocidad alcance
figure;
b = boxchart(condicion,data_i.velocidad_alcance,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad alcance (Int)','FontSize',18) 

%Velocidad retorno
figure;
b = boxchart(condicion,data_i.velocidad_retorno,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; 
b(2).BoxEdgeColor = I; 
b(3).BoxEdgeColor = A; 
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad retorno (Int)','FontSize',18) 

%Avanzados
condicion = categorical(data_a.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi
%Tiempo de reaccion 
figure;
b = boxchart(condicion,data_a.tiempo_reaccion,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylim([0 1])
ylabel('Tiempo de reacción (s)','FontSize',14)
title('Tiempo de reacción (Av)','FontSize',18) 

%Duracion
figure;
b = boxchart(condicion,data_a.duracion,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylabel('Duración (s)','FontSize',14)
title('Duración (Av)','FontSize',18) 

%Velocidad
figure;
b = boxchart(condicion,data_a.velocidad,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad (Av)','FontSize',18) 

%Velocidad alcance
figure;
b = boxchart(condicion,data_a.velocidad_alcance,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

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
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad alcance (Av)','FontSize',18) 

%Velocidad retorno
figure;
b = boxchart(condicion,data_a.velocidad_retorno,'GroupByColor',condicion,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',1); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; 
b(2).BoxEdgeColor = I; 
b(3).BoxEdgeColor = A; 
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad retorno (Av)','FontSize',18) 

% Datos juntos

condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi
fase = categorical(data.Fase,{'Novatos', 'Intermedios', 'Avanzados'}); %Como este es numérico hay que hacerlo asi

%Tiempo de reaccion 
figure;
b = boxchart(condicion,data.tiempo_reaccion,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

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
ylim([0 1])
legend
ylabel('Tiempo de reacción (s)','FontSize',14)
title('Tiempo de reacción','FontSize',18)
legend

condicion = categorical(data.Condicion, [500, 1000, 1500], {'500', '1000', '1500'}); %Como este es numérico hay que hacerlo asi
fase = categorical(data.Fase,{'Novatos', 'Intermedios', 'Avanzados'}); %Como este es numérico hay que hacerlo asi

%Duracion
figure;
b = boxchart(condicion,data.duracion,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

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
ylabel('Duración (s)','FontSize',14)
title('Duración','FontSize',18) 
legend

%Velocidad
figure;
b = boxchart(condicion,data.velocidad,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

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
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad','FontSize',18) 
legend

%Velocidad alcance
figure;
b = boxchart(condicion,data.velocidad_alcance,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

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
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad alcance','FontSize',18) 
legend

%Velocidad retorno
figure;
b = boxchart(condicion,data.velocidad_retorno,'GroupByColor',fase,'LineWidth',1.5,'MarkerStyle',".",'BoxWidth',0.5); %Grupos, data, groupbycolor

% Asignar colores manualmente a cada grupo
b(1).BoxFaceColor = N; % Novatos
b(2).BoxFaceColor = I; % Intermedios
b(3).BoxFaceColor = A; % Avanzados
b(1).BoxEdgeColor = N; 
b(2).BoxEdgeColor = I; 
b(3).BoxEdgeColor = A; 
b(1).MarkerColor = N; 
b(2).MarkerColor = I; 
b(3).MarkerColor = A; 

set(gca,'TickDir','in','LineWidth',2,'FontSize',14,'GridColor','k')
set(gcf,'color','white')
ylim([0 100])
ylabel('Velocidad (cm/s)','FontSize',14)
title('Velocidad retorno','FontSize',18) 
legend

%% Guardar figuras

guardarfiguras()

