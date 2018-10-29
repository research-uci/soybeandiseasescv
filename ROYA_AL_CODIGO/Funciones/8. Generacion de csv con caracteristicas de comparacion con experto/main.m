%% Parametros Iniciales
clc; 
clear all; 
close all;
 %% Definicion de estructura de directorios 
HOME=strcat(pwd,'/');
pathPrincipal=strcat(HOME,'Escritorio/Resultados/'); %carpeta principal donde estaran resultados
pathMarked = strcat(HOME,'Escritorio/Resultado_de_Magenta/imgscrop/'); %donde estan las imagenes cortadas y pintadas
pathMarked2 = strcat(HOME,'Escritorio/Magenta/imgs_magenta/'); %donde estan las imagenes pintadas
pathC = strcat(HOME,'Resultados/CompareSDMet/');
pathM = strcat(HOME,'Resultados/Marked/');

pathFPFNBin=strcat(pathC,'FPFNBin/'); % comparacion
pathTPTNBin=strcat(pathC,'TPTNBin/'); % comparacion
pathFNBin=strcat(pathC,'FNBin/'); % comparacion
pathFPBin=strcat(pathC,'FPBin/'); % comparacion
pathTPBin=strcat(pathC,'TPBin/'); % comparacion
pathTNBin=strcat(pathC,'TNBin/'); % comparacion
pathTPFPFNBin=strcat(pathC,'TPFPFNBin/'); % comparacion
pathExpertoBin=strcat(pathC,'ExpertoBin/');%*********************

pathDefBinario=strcat(pathM,'MDefBin/'); %almacenado de defectos binario POR MARCAS**********************
% pathCalyxBinario=strcat(pathM,'MCalyxBin/'); %almacenado de calyx en binario POR MARCAS

pathDefectosBin = strcat(HOME,'Escritorio/Resultados/Defectos/');

mkdir (pathPrincipal);
mkdir (pathC);
mkdir (pathM);
mkdir (pathFPFNBin);
mkdir (pathTPTNBin);
mkdir (pathFNBin);
mkdir (pathFPBin);
mkdir (pathTPBin);
mkdir (pathTNBin);
mkdir (pathTPFPFNBin);
mkdir (pathExpertoBin);
mkdir (pathDefBinario);
% mkdir (pathCalyxBinario);
mkdir (pathDefectosBin);
%% Definición a cero de las variables promedio
    acumuladoPrecision=0.0;
    acumuladoExactitud=0.0;
    acumuladoSensibilidad=0.0;
    acumuladoEspecificidad=0.0;

    promedioPrecision=0.0;
    promedioExactitud=0.0;
    promedioSensibilidad=0.0;
    promedioEspecificidad=0.0;
    
    listado=dir(strcat(pathMarked,'*.png')); %HOJAS PINTADAS MAGENTA
    for n=1:size(listado) 
        nombreImagenP=listado(n).name;
        nombreImagenDefBin=strcat(pathDefectosBin,nombreImagenP);
        nombreMascaraExperto=strcat(pathMarked2,nombreImagenP);
        nombreMascaraTPTN=strcat(pathTPTNBin,nombreImagenP,'_','TPTN');
        nombreMascaraFPFN=strcat(pathFPFNBin,nombreImagenP,'_','FPFN');
        nombreMascaraFN=strcat(pathFNBin,nombreImagenP,'_','FN');
        nombreMascaraFP=strcat(pathFPBin,nombreImagenP,'_','FP');
        nombreMascaraTP=strcat(pathTPBin,nombreImagenP,'_','TP');
        nombreMascaraTN=strcat(pathTNBin,nombreImagenP,'_','TN');
        nombreMascaraTPFPFN=strcat(pathTPFPFNBin,nombreImagenP,'_','TO');
        
        %% nombreImagenSoftware == nombreImagenDefBin
        juntado(nombreMascaraExperto,nombreImagenDefBin,nombreImagenP);
        diferencia(nombreMascaraExperto,nombreImagenDefBin,nombreMascaraFPFN);
        coincidencia(nombreMascaraExperto, nombreMascaraFPFN, nombreMascaraFN);
        coincidencia(nombreImagenDefBin, nombreMascaraFPFN, nombreMascaraFP);
        coincidencia(nombreMascaraExperto, nombreImagenDefBin, nombreMascaraTP);
        juntado(nombreMascaraExperto,nombreImagenDefBin, nombreMascaraTPFPFN);
        inversa(nombreMascaraTPFPFN, nombreMascaraTN);
        
                %% CALCULAR TASA DE DIFERENCIAS Y COINCIDENCIAS
        %% Definicion de variables a cero
        TP=0;
        TN=0;    
        FP=0;
        FN=0;
        
        precision=0.0;
        exactitud=0.0;
        sensibilidad=0.0;
        especificidad=0.0;
        
        %% conteo de pixeles
        TP=contarPixeles(nombreMascaraTP);    
        FP=contarPixeles(nombreMascaraFP);
        FN=contarPixeles(nombreMascaraFN);
        TN=contarPixeles(nombreMascaraTN);
    
        %precision, exactitud, sensibilidad, especificidad
        if((TP+FP)==0)
            precision=0;
        else
            precision=TP/(TP+FP);            
        end

        
        if((TP+FP+TN+FN)==0)
            exactitud=0;
        else
            exactitud=(TP+TN)/(TP+FP+TN+FN);
        end        

        if((TP+FN)==0)
            sensibilidad=0;
        else
            sensibilidad=TP/(TP+FN);
        end        


        if((TN+FP)==0)
            especificidad=0;
        else
            especificidad=TN/(TN+FP);
        end        
            
        %% acumulados
        acumuladoPrecision=acumuladoPrecision+precision;
        acumuladoExactitud=acumuladoExactitud+exactitud;
        acumuladoSensibilidad=acumuladoSensibilidad+sensibilidad;
        acumuladoEspecificidad=acumuladoEspecificidad+especificidad;

        %% ------------------
        fprintf('imagen=%s, precision=%f, exactitud=%f,sensibilidad=%f especificidad=%f\n', nombreImagenP, precision, exactitud, sensibilidad, especificidad);
        
        
    end
    totalPruebas=n;
    %% CALCULO DE PROMEDIO
promedioPrecision=acumuladoPrecision/totalPruebas;
promedioExactitud=acumuladoExactitud/totalPruebas;    
promedioSensibilidad=acumuladoSensibilidad/totalPruebas;
promedioEspecificidad=acumuladoEspecificidad/totalPruebas;

fprintf('--------------------------------\n');
fprintf('RESULTADO PROMEDIO EN %i PRUEBAS\n', totalPruebas);
fprintf('--------------------------------\n');    
fprintf('APrecision=%f, AExactitud=%f, ASensibilidad=%f AEspecificidad=%f\n', acumuladoPrecision, acumuladoExactitud,acumuladoSensibilidad, acumuladoEspecificidad);
fprintf('precision=%f, exactitud=%f, sensibilidad=%f especificidad=%f\n', promedioPrecision, promedioExactitud, promedioSensibilidad, promedioEspecificidad);

