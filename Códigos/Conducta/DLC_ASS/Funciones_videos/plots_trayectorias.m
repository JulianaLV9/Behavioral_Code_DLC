
%% Graficar trayectorias por separado
figure
ensayo_num = 1:length(indices_numeros);
traj = trayectorias_reescaladas;

y = length(indices_numeros);
v = 2:y/2;
c = v(mod(y,v)==0);

for e = 1:length(ensayo_num)
    subplot(c(1),c(end),e)
    plot(traj(indices_numeros(ensayo_num(e),1):indices_numeros(ensayo_num(e),2),1),traj(indices_numeros(ensayo_num(e),1):indices_numeros(ensayo_num(e),2),2),'-',LineWidth=1)
    title(char(string(e)),"FontSize",12)

    xlim = [0,500];
    ylim = [0,400];
 
end
%% Graficar algunas metricas de las trayectorias

m = 2;
n = 2;

figure
subplot(m,n,1)
plot(trayectorias_reconstruidas(:,1),trayectorias_reconstruidas(:,2),LineWidth=2)
axis('square')
title('Trayectorias reconstruidas')
subplot(m,n,2)
plot(trayectorias_reescaladas(:,1),trayectorias_reescaladas(:,2),LineWidth=2)
axis('square')
title('Trayectorias reescaladas')

subplot(m,n,3)
plot(distancia_acumulada,'-*',LineWidth = 2)
title('Distacia acumulada')
axis('square')

subplot(m,n,4)
li = mean(magnitud_f) - std(magnitud_f)*1.96;
ls = mean(magnitud_f) + std(magnitud_f)*1.96;
me = mean(magnitud_f);
hold on
plot(magnitud_f,'-*',LineWidth = 2)
plot([1,length(magnitud_f)],[li,li],'r')
plot([1,length(magnitud_f)],[ls,ls]','r')
plot([1,length(magnitud_f)],[me,me],'b')
title('posicion final (distancia vectorial)')
axis('square')

%%
figure

subplot(2,1,1)
hold on
y = magnitud_ttorigen(indices_pks);
plot(magnitud_ttorigen,LineWidth=2)
plot(indices_pks,y,'*','Color','r',MarkerSize=10)
title("Ubicacion de brazos secundarios")
xlabel('tiempo')
ylabel("distancia")

subplot(2,1,2)
hold on
y = ones(length(indices_pks));

plot(recorrido_positivo);
plot(recorrido_negativo);
plot(indices_pks,y,'*','Color','r',MarkerSize=10)
legend('recorrido positivo','recorrido negativo','idx recompenza')
title("Tipo de recorrido")
xlabel("tiempo")

hold off