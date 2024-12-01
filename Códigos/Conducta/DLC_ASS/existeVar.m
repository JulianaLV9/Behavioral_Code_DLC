function [variable_nueva] = existeVar(variable)

if exist('variable','var') == 1
    variable_nueva = variable;

else
    variable_nueva = NaN;
end

end