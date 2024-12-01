%Graficos conductuales

%Path donde se encuentran los datos
addpath(genpath('/Volumes/ReachingJLV/BaseDeDatos_LotesPiloto'))

%Archivos
[file_name, path_name] = uigetfile('*', 'Select coordinates file', 'MultiSelect', 'on'); %Seleccionar los datos conductuales que se quieren graficar
kk = 1;

%Matrices
correct_group = NaN(length(file_name),15); %Cambiar el número de sesiones
mistake_group = NaN(length(file_name),15);
omision_group = NaN(length(file_name),15);

%Graficos individuales
for ii = 1:length(file_name)

%Datos de la rata
 rat      = file_name{1,ii};
 name     = extractBefore(rat,'_productividad'); %Cambiar de acuerdo a como se llame el documento

 %Extraer los datos
 data    = readtable(rat);
 data    = table2array(data);
 correct = data(4,:);
 mistake = data(5,:);
 omision = data(6,:);
 
 %Porcentaje aciertos
 figure(kk), clf
 plot(correct,"Color",[0.4667    0.6745    0.1882],"LineWidth",1.5, "Marker","o","MarkerFaceColor",[0.4667    0.6745    0.1882])
 xlim([1 length(correct)])
 ylim([0 100])
 title(["Aciertos" name],"FontSize",16,"FontWeight","bold")
 xlabel("Sesiones","FontSize",14)
 ylabel("Porcentaje (%)","FontSize",14,"FontWeight","bold")
 set(gcf,'color','white')
 set(gca,'TickDir','out','LineWidth',1.5)

 %Porcentaje errores
 figure(kk + 1), clf
 plot(mistake,"Color",[0.8510    0.3255    0.0980],"LineWidth",1.5, "Marker","o","MarkerFaceColor",[0.8510    0.3255    0.0980])
 xlim([1 length(correct)])
 ylim([0 100])
 title(["Errores" name],"FontSize",16,"FontWeight","bold")
 xlabel("Sesiones","FontSize",14)
 ylabel("Porcentaje (%)","FontSize",14,"FontWeight","bold")
 set(gcf,'color','white')
 set(gca,'TickDir','out','LineWidth',1.5)

 %Porcentaje omisiones
 figure(kk +2), clf
 plot(omision,"Color",[0.9294    0.6941    0.1255],"LineWidth",1.5, "Marker","o","MarkerFaceColor",[0.9294    0.6941    0.1255])
 xlim([1 length(correct)])
 ylim([0 100])
 title(["Omisiones" name],"FontSize",16,"FontWeight","bold")
 xlabel("Sesiones","FontSize",14)
 ylabel("Porcentaje (%)","FontSize",14,"FontWeight","bold")
 set(gcf,'color','white')
 set(gca,'TickDir','out','LineWidth',1.5)

 %Figura conjunta
 figure(kk +3), clf
 plot(correct,"Color",[0.4667    0.6745    0.1882],"LineWidth",1.5, "Marker","o","MarkerFaceColor",[0.4667    0.6745    0.1882])
 hold on
 plot(mistake,"Color",[0.8510    0.3255    0.0980],"LineWidth",1.5, "Marker","*","MarkerFaceColor",[0.8510    0.3255    0.0980]) 
 plot(omision,"Color",[0.9294    0.6941    0.1255],"LineWidth",1.5, "Marker","+","MarkerFaceColor",[0.9294    0.6941    0.1255])
 xlim([1 length(correct)])
 ylim([0 100])
 title(["Conducta" name],"FontSize",16,"FontWeight","bold")
 xlabel("Sesiones","FontSize",14)
 ylabel("Porcentaje (%)","FontSize",14,"FontWeight","bold")
 set(gcf,'color','white')
 set(gca,'TickDir','out','LineWidth',1.5)
 legend("Correctos","Errores","Omisiones")

 kk = kk + 4;

 %Guardar datos por grupo
 correct_group(ii,1:length(correct)) = correct;
 mistake_group(ii,1:length(mistake)) = mistake;
 omision_group(ii,1:length(omision)) = omision;

end 

%Promedios 
mean_correct = mean(correct_group,1);
mean_mistake = mean(mistake_group,1);
mean_omision = mean(omision_group,1);

