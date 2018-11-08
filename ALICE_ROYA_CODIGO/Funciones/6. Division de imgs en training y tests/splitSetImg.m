function [tablaDSTraining, tablaDSTest] = splitSetImg( listado, proporcionTraining, pathPrincipal, pathResultados, nombreArchivoSetCompleto)
% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
tablaDSTSetCompleto = listado;
tamanoTabla=size(tablaDSTSetCompleto);

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
fprintf('Elegir %i filas al azar para Test sin reemplazo \n',TotalFilasTest);


%% Ciclo para creacion de los conjuntos de entrenamiento y de test
for(contadorRandom=1:1:TotalFilasTest)

    tamanoTabla=size(tablaDSTSetCompleto);
    TotalFilas=tamanoTabla(1); %tamano filas automatico
    
    filaIndexEleccion=int16(rand()*TotalFilas)+1;
%    fprintf('%i) %i fila seleccionada \n',contadorRandom,filaIndexEleccion);
    
    %Elegir fila al azar
    %posicionarse en la fila y borrar del conjunto general
    filaElegida=tablaDSTSetCompleto(filaIndexEleccion,:);
    if(contadorRandom==1)
        %crea la primera fila
        tablaDSTest=filaElegida;        
    else
        %Agrega filas
        tablaDSTest=[tablaDSTest; filaElegida];                
    end %(contadorRandom==1)
    tablaDSTSetCompleto(filaIndexEleccion,:)=[]; %borrar la fila seleccionada del conjunto principal
end %end for

%Guardar los restantes en training
tablaDSTraining=tablaDSTSetCompleto;

end %fin dividirConjunto

