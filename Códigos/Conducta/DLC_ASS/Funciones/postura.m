function [angulos_500,angulos_1000,angulos_1500] = postura(plan_500,plan_1000,plan_1500,ejec_500,ejec_1000,ejec_1500)

angulos_plan_500        = angulos(plan_500);
angulos_ejec_500        = angulos(ejec_500);
angulos_plan_500.Origen = repmat({'Plan'}, height(angulos_plan_500), 1);
angulos_ejec_500.Origen = repmat({'Ejec'}, height(angulos_ejec_500), 1);
angulos_500             = [angulos_plan_500;angulos_ejec_500];

angulos_plan_1000        = angulos(plan_1000);
angulos_ejec_1000        = angulos(ejec_1000);
angulos_plan_1000.Origen = repmat({'Plan'}, height(angulos_plan_1000), 1);
angulos_ejec_1000.Origen = repmat({'Ejec'}, height(angulos_ejec_1000), 1);
angulos_1000             = [angulos_plan_1000;angulos_ejec_1000];
 
angulos_plan_1500        = angulos(plan_1500);
angulos_ejec_1500        = angulos(ejec_1500);
angulos_plan_1500.Origen = repmat({'Plan'}, height(angulos_plan_1500), 1);
angulos_ejec_1500.Origen = repmat({'Ejec'}, height(angulos_ejec_1500), 1);
angulos_1500             = [angulos_plan_1500;angulos_ejec_1500];

end 