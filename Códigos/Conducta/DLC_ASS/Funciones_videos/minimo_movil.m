function [senial_salida] = minimo_movil(senial_entrada,lventana)

% lventana = 10;
paso = 1;
s = 1;
f = lventana;

senial_salida = zeros(1,length(senial_entrada));
for i = 1:length(senial_entrada)-lventana
senial_salida(i) = min(senial_entrada(s:f));
s = s+paso;
f = f+paso;
end

figure
hold on
plot(senial_salida(1:length(senial_salida)-lventana),LineWidth=2,Marker="o")
plot(senial_entrada,'red',Marker="o")
hold off

end