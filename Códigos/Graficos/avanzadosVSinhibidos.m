%Datos de la rata
 data     = readtable('/Users/julianalozavaqueiro/Documents/Reaching_task/ASS/Datos_conjuntos_AyB_entrenamiento_filtrado.xlsx',Sheet='AvanzadosvsInh');
 data    = table2array(data);

 %Corticorrubrales B1
 control_aciertos    = data(1,:);
 ejecucion_aciertos  = data(2,:);
 planeacion_aciertos = data(3,:);
 control_errores     = data(4,:);
 ejecucion_errores   = data(5,:);
 planeacion_errores  = data(6,:);
 control_omision     = data(7,:);
 ejecucion_omision   = data(8,:);
 planeacion_omision  = data(9,:);


figure(1),clf
plot(control_aciertos, 'Color', [0.6353 0.0784 0.1843], 'LineWidth', 2.5, 'Marker', 'o','MarkerSize',10, 'MarkerFaceColor', [0.6353 0.0784 0.1843])
hold on
plot(ejecucion_aciertos, 'Color', [0.4667 0.6745 0.1882], 'LineWidth', 2.5, 'Marker', 'square','MarkerSize',10,'MarkerFaceColor', [0.4667 0.6745 0.1882])
plot(planeacion_aciertos, 'Color', [0.9020 0.5882 0.2353], 'LineWidth', 2.5, 'Marker', 'diamond','MarkerSize',10, 'MarkerFaceColor', [0.9020 0.5882 0.2353])
title('Aciertos','FontSize',20)
set(gca, 'TickDir', 'in', 'LineWidth', 1.5, 'FontSize', 14)
ylabel('Errores (%)','FontSize',14,'FontWeight','bold')
xlabel('Fase entrenamiento','FontSize',14,'FontWeight','bold')
ylim([0 100])
xlim([0 7])
legend('Control','Execution','Preparation')
xticks([0 1 2 3 4 5 6 7 ]) 
xticklabels({'','T16','T17','T18','I1','I2','I3',''}) 

figure(2),clf
plot(control_omision, 'Color', [0.6353 0.0784 0.1843], 'LineWidth', 2.5, 'Marker', 'o','MarkerSize',10, 'MarkerFaceColor', [0.6353 0.0784 0.1843])
hold on
plot(ejecucion_omision, 'Color', [0.4667 0.6745 0.1882], 'LineWidth', 2.5, 'Marker', 'square','MarkerSize',10,'MarkerFaceColor', [0.4667 0.6745 0.1882])
plot(planeacion_omision, 'Color', [0.9020 0.5882 0.2353], 'LineWidth', 2.5, 'Marker', 'diamond','MarkerSize',10, 'MarkerFaceColor', [0.9020 0.5882 0.2353])
title('Omision','FontSize',20)
set(gca, 'TickDir', 'in', 'LineWidth', 1.5, 'FontSize', 14)
ylabel('Omision (%)','FontSize',14,'FontWeight','bold')
xlabel('Fase entrenamiento','FontSize',14,'FontWeight','bold')
ylim([0 100])
xlim([0 7])
legend('Control','Execution','Preparation')
xticks([0 1 2 3 4 5 6 7 ]) 
xticklabels({'','T16','T17','T18','I1','I2','I3',''}) 

figure(3),clf
plot(control_errores, 'Color', [0.6353 0.0784 0.1843], 'LineWidth', 2.5, 'Marker', 'o','MarkerSize',10, 'MarkerFaceColor', [0.6353 0.0784 0.1843])
hold on
plot(ejecucion_errores, 'Color', [0.4667 0.6745 0.1882], 'LineWidth', 2.5, 'Marker', 'square','MarkerSize',10,'MarkerFaceColor', [0.4667 0.6745 0.1882])
plot(planeacion_errores, 'Color', [0.9020 0.5882 0.2353], 'LineWidth', 2.5, 'Marker', 'diamond','MarkerSize',10, 'MarkerFaceColor', [0.9020 0.5882 0.2353])
title('Omisiones','FontSize',20)
set(gca, 'TickDir', 'in', 'LineWidth', 1.5, 'FontSize', 14)
ylabel('Omisiones (%)','FontSize',14,'FontWeight','bold')
xlabel('Fase entrenamiento','FontSize',14,'FontWeight','bold')
ylim([0 100])
xlim([0 7])
legend('Control','Execution','Preparation')
xticks([0 1 2 3 4 5 6 7 ]) 
xticklabels({'','T16','T17','T18','I1','I2','I3',''}) 

 %Corticoespinaless B6
 control_aciertos    = data(10,:);
 ejecucion_aciertos  = data(11,:);
 planeacion_aciertos = data(12,:);
 control_errores     = data(13,:);
 ejecucion_errores   = data(14,:);
 planeacion_errores  = data(15,:);
 control_omision     = data(16,:);
 ejecucion_omision   = data(17,:);
 planeacion_omision  = data(18,:);

 %Corticoespinaless B6
 control_aciertos_ce    = data(10,:);
 ejecucion_aciertos_ce  = data(11,:);
 planeacion_aciertos_ce = data(12,:);
 control_errores_ce     = data(13,:);
 ejecucion_errores_ce   = data(14,:);
 planeacion_errores_ce  = data(15,:);
 control_omision_ce     = data(16,:);
 ejecucion_omision_ce   = data(17,:);
 planeacion_omision_ce  = data(18,:);

figure(4),clf
plot(control_aciertos_ce, 'Color', [0    0.4471    0.7412], 'LineWidth', 2.5, 'Marker', 'o','MarkerSize',10, 'MarkerFaceColor', [0    0.4471    0.7412])
hold on
plot(ejecucion_aciertos_ce, 'Color', [0.4667 0.6745 0.1882], 'LineWidth', 2.5, 'Marker', 'square','MarkerSize',10,'MarkerFaceColor', [0.4667 0.6745 0.1882])
plot(planeacion_aciertos_ce, 'Color', [0.9020 0.5882 0.2353], 'LineWidth', 2.5, 'Marker', 'diamond','MarkerSize',10, 'MarkerFaceColor', [0.9020 0.5882 0.2353])
title('Aciertos','FontSize',20)
set(gca, 'TickDir', 'in', 'LineWidth', 1.5, 'FontSize', 14)
ylabel('Errores (%)','FontSize',14,'FontWeight','bold')
xlabel('Fase entrenamiento','FontSize',14,'FontWeight','bold')
ylim([0 100])
xlim([0 7])
legend('Control','Execution','Preparation')
xticks([0 1 2 3 4 5 6 7 ]) 
xticklabels({'','T16','T17','T18','I1','I2','I3',''}) 

figure(5),clf
plot(control_omision_ce, 'Color', [0    0.4471    0.7412], 'LineWidth', 2.5, 'Marker', 'o','MarkerSize',10, 'MarkerFaceColor', [0    0.4471    0.7412])
hold on
plot(ejecucion_omision_ce, 'Color', [0.4667 0.6745 0.1882], 'LineWidth', 2.5, 'Marker', 'square','MarkerSize',10,'MarkerFaceColor', [0.4667 0.6745 0.1882])
plot(planeacion_omision_ce, 'Color', [0.9020 0.5882 0.2353], 'LineWidth', 2.5, 'Marker', 'diamond','MarkerSize',10, 'MarkerFaceColor', [0.9020 0.5882 0.2353])
title('Omision','FontSize',20)
set(gca, 'TickDir', 'in', 'LineWidth', 1.5, 'FontSize', 14)
ylabel('Omision (%)','FontSize',14,'FontWeight','bold')
xlabel('Fase entrenamiento','FontSize',14,'FontWeight','bold')
ylim([0 100])
xlim([0 7])
legend('Control','Execution','Preparation')
xticks([0 1 2 3 4 5 6 7 ]) 
xticklabels({'','T16','T17','T18','I1','I2','I3',''}) 

figure(6),clf
plot(control_errores_ce, 'Color', [0    0.4471    0.7412], 'LineWidth', 2.5, 'Marker', 'o','MarkerSize',10, 'MarkerFaceColor', [0    0.4471    0.7412])
hold on
plot(ejecucion_errores_ce, 'Color', [0.4667 0.6745 0.1882], 'LineWidth', 2.5, 'Marker', 'square','MarkerSize',10,'MarkerFaceColor', [0.4667 0.6745 0.1882])
plot(planeacion_errores_ce, 'Color', [0.9020 0.5882 0.2353], 'LineWidth', 2.5, 'Marker', 'diamond','MarkerSize',10, 'MarkerFaceColor', [0.9020 0.5882 0.2353])
title('Omisiones','FontSize',20)
set(gca, 'TickDir', 'in', 'LineWidth', 1.5, 'FontSize', 14)
ylabel('Omisiones (%)','FontSize',14,'FontWeight','bold')
xlabel('Fase entrenamiento','FontSize',14,'FontWeight','bold')
ylim([0 100])
xlim([0 7])
legend('Control','Execution','Preparation')
xticks([0 1 2 3 4 5 6 7 ]) 
xticklabels({'','T16','T17','T18','I1','I2','I3',''}) 

