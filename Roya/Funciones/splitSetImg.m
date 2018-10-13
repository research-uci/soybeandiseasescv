function [tablaTraining, tablaTest] = splitSetImg(listadoImg, proporcionTraining, folder, pathResultados)
tablaSetCompleto = listadoImg;
tamanoTabla=size(tablaSetCompleto);

%% Declaracion de variables
TotalFilas=tamanoTabla(1); %tamano filas automatico
proporcionTest=0;   
TotalFilasTraining=0;
TotalFilasTest=0;

%Al menos 1porciento debe quedar para test
if(proporcionTraining<=99)
    proporcionTest=100-proporcionTraining; 
    TotalFilasTraining=floor((TotalFilas*proporcionTraining)/100);
    TotalFilasTest=floor((TotalFilas*proporcionTest)/100);
    
else
    fprintf('No se aplica la PROPORCION, debe existir al menos 1% para el archivo Test \n');
end % fin validacion

%% Dividir conjunto
contadorRandom=0;
fprintf('Elegidas %i filas al azar para Test \n',TotalFilasTest);

%% Ciclo para creacion de los conjuntos de entrenamiento y de test
for(contadorRandom=1:1:TotalFilasTest)
    rng('shuffle');
    tamanoTabla=size(tablaSetCompleto);
    TotalFilas=tamanoTabla(1); %tamano filas automatico
    
    filaIndexEleccion=int16(rand()*TotalFilas)+1;
%    fprintf('%i) %i fila seleccionada \n',contadorRandom,filaIndexEleccion);
    
%Elegir fila al azar
%posicionarse en la fila y borrar del conjunto general
filaElegida=tablaSetCompleto(filaIndexEleccion,:);
if(contadorRandom==1)
    %crea la primera fila
    tablaTest=filaElegida;
else
    %Agrega filas
    tablaTest=[tablaTest; filaElegida];
end %(contadorRandom==1)
tablaSetCompleto(filaIndexEleccion,:)=[]; %borrar la fila seleccionada del conjunto principal
end %end for

%Guardar los restantes en training
tablaTraining=tablaSetCompleto;

end

