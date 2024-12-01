function guardarfiguras()
% Obtener todos los handles de las figuras abiertas

figures = findall(0, 'Type', 'figure');

for i = 1:length(figures)
    % Establecer la figura actual
    figure(figures(i));
    
    % Obtener el título de la figura
    ax = get(figures(i), 'CurrentAxes');
    if isempty(ax) || isempty(get(ax, 'Title'))
        title_text = sprintf('Figure_%d', i); % Si no hay título, usar un nombre genérico
    else
        title_obj = get(ax, 'Title');
        title_text = title_obj.String;
        if iscell(title_text)
            title_text = strjoin(title_text, '_'); % Unir títulos en celdas con guiones bajos
        end
    end
    
    % Reemplazar caracteres no válidos para nombres de archivo
    valid_title = regexprep(title_text, '[^\w]', '_');
    
    % Guardar la figura como archivo PNG
    %exportgraphics(figures(i), [valid_title '.png'], 'Resolution', 300);
    % Puedes guardar en otros formatos, como .fig o .eps:
    saveas(figures(i), [valid_title '.svg']);
    
end

disp('Todas las figuras se han guardado con el título como nombre.');
end