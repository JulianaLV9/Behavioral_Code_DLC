function [Go_Cue_essay,Bar_essay,Recompensa_essay,Intentos_essay] = alineacion_tablas(ventanasEnsayos,Inicio_Ensayos,Fin_Ensayos,Go_Cue,Barra,Recompensa,Intentos)

% Senal Go
Go_Cue_essay = NaN(length(ventanasEnsayos),1);
for ii = 1:length(ventanasEnsayos)
    ventana = Inicio_Ensayos(ii):Fin_Ensayos(ii);

    for kk = 1:length(Go_Cue)
        if ismember(Go_Cue(kk),ventana)
            Go_Cue_essay(ii,1) = Go_Cue(kk);
            break
        elseif Go_Cue(kk) > Fin_Ensayos(ii)
            break   
        else 
            Go_Cue_essay(ii,1) = NaN;
        end 
    end 
end 

% Barra
Bar_essay = NaN(length(ventanasEnsayos),1);

%Filtro para descartar cualquier contacto de palanca previo al incio de la
%tarea
if Barra(1,1) < Inicio_Ensayos(1,1)
    Barra = Barra(2:end);
else 
    Barra = Barra(1:end);
end 

for ii = 1:length(ventanasEnsayos)
    ventana = Inicio_Ensayos(ii):Fin_Ensayos(ii);

    for kk = 1:length(Barra)
        if ismember(Barra(kk),ventana)
            Bar_essay(ii,1) = Barra(kk);
            break
        elseif Barra(kk) > Fin_Ensayos(ii) 
            break   
        else 
            Bar_essay(ii,1) = NaN;
        end 
    end 
end

% Recompensa
Recompensa_essay = NaN(length(ventanasEnsayos),1);

for ii = 1:length(ventanasEnsayos)
    ventana = Inicio_Ensayos(ii):Fin_Ensayos(ii);

    for kk = 1:length(Recompensa)
        if ismember(Recompensa(kk),ventana)
            Recompensa_essay(ii,1) = Recompensa(kk);
            break
        elseif Recompensa(kk) > Fin_Ensayos(ii) 
            break   
        else 
            Recompensa_essay(ii,1) = NaN;
        end 
    end 
end

% Intentos
Intentos_essay = NaN(length(ventanasEnsayos),1);

for ii = 1:length(ventanasEnsayos)
    ventana = Inicio_Ensayos(ii):Fin_Ensayos(ii);

    for kk = 1:length(Intentos)
        if ismember(Intentos(kk),ventana)
            Intentos_essay(ii,1) = Intentos(kk);
            break
        elseif Intentos(kk) > Fin_Ensayos(ii) 
            break   
        else 
            Intentos_essay(ii,1) = NaN;
        end 
    end 
end

end 