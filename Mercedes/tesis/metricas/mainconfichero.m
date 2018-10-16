%% Parametros Iniciales
clc; 
clear all; 
close all;
 %% Definicion de estructura de directorios 
HOME=('D:\');
pathPrincipal=strcat(HOME,'Resultados\'); %carpeta principal donde estaran resultados
pathMarked = strcat(HOME,'resultado\resultado11\3_M_BR\'); %donde estan las imagenes cortadas y pintadas
pathMarked2 = strcat(HOME,'resultado\resultado11\1_M_rgb_crop\'); %donde estan las imagenes pintadas
pathC = strcat(HOME,'Resultados\CompareSDMet\');
pathM = strcat(HOME,'Resultados\Marked\');

pathFPFNBin=strcat(pathC,'FPFNBin\'); % comparacion
pathTPTNBin=strcat(pathC,'TPTNBin\'); % comparacion
pathFNBin=strcat(pathC,'FNBin\'); % comparacion
pathFPBin=strcat(pathC,'FPBin\'); % comparacion
pathTPBin=strcat(pathC,'TPBin\'); % comparacion
pathTNBin=strcat(pathC,'TNBin\'); % comparacion
pathTPFPFNBin=strcat(pathC,'TPFPFNBin\'); % comparacion
pathExpertoBin=strcat(pathC,'ExpertoBin\');%*********************

pathDefBinario=strcat(pathM,'MDefBin\'); %almacenado de defectos binario POR MARCAS**********************
% pathCalyxBinario=strcat(pathM,'MCalyxBin/'); %almacenado de calyx en binario POR MARCAS

pathDefectosBin = strcat(HOME,'resultado\r_param\4_resultado_mancha_rgb\');
% pathDefectosBin = strcat(HOME,'Resultados\Defectos\');

% mkdir (pathPrincipal); mkdir (pathC); mkdir (pathM); mkdir (pathFPFNBin);
% mkdir (pathTPTNBin); mkdir (pathFNBin); mkdir (pathFPBin); mkdir
% (pathTPBin); mkdir (pathTNBin); mkdir (pathTPFPFNBin); mkdir
% (pathExpertoBin); mkdir (pathDefBinario);

if ~exist(pathPrincipal, 'dir')                                    
        mkdir(pathPrincipal);
    else
        fprintf(' Ya ha sido creada= %s \n',pathPrincipal); 
end

if ~exist(pathC, 'dir')                                   
        mkdir(pathC);
    else
        fprintf(' ya ha sido creada= %s \n',pathC);
        filePattern = fullfile(pathC, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathC);
        end
end

if ~exist(pathM, 'dir')                                   
        mkdir(pathM);
    else
        fprintf(' ya ha sido creada= %s \n',pathM);
        filePattern = fullfile(pathM, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathM);
        end
end

if ~exist(pathFPFNBin, 'dir')                                   
        mkdir(pathFPFNBin);
    else
        fprintf(' ya ha sido creada= %s \n',pathFPFNBin);
        filePattern = fullfile(pathFPFNBin, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathFPFNBin);
        end
end

if ~exist(pathTPTNBin, 'dir')                                   
        mkdir(pathTPTNBin);
    else
        fprintf(' ya ha sido creada= %s \n',pathTPTNBin);
        filePattern = fullfile(pathTPTNBin, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathTPTNBin);
        end
end

if ~exist(pathFNBin, 'dir')                                   
        mkdir(pathFNBin);
    else
        fprintf(' ya ha sido creada= %s \n',pathFNBin);
        filePattern = fullfile(pathFNBin, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathFNBin);
        end
end

if ~exist(pathFPBin, 'dir')                                   
        mkdir(pathFPBin);
    else
        fprintf(' ya ha sido creada= %s \n',pathFPBin);
        filePattern = fullfile(pathFPBin, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathFPBin);
        end
end

if ~exist(pathTPBin, 'dir')                                   
        mkdir(pathTPBin);
    else
        fprintf(' ya ha sido creada= %s \n',pathTPBin);
        filePattern = fullfile(pathTPBin, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathTPBin);
        end
end

if ~exist(pathTNBin, 'dir')                                   
        mkdir(pathTNBin);
    else
        fprintf(' ya ha sido creada= %s \n',pathTNBin);
        filePattern = fullfile(pathTNBin, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathTNBin);
        end
end

if ~exist(pathTPFPFNBin, 'dir')                                   
        mkdir(pathTPFPFNBin);
    else
        fprintf(' ya ha sido creada= %s \n',pathTPFPFNBin);
        filePattern = fullfile(pathTPFPFNBin, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathTPFPFNBin);
        end
end

if ~exist(pathExpertoBin, 'dir')                                   
        mkdir(pathExpertoBin);
    else
        fprintf(' ya ha sido creada= %s \n',pathExpertoBin);
        filePattern = fullfile(pathExpertoBin, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathExpertoBin);
        end
end

if ~exist(pathDefBinario, 'dir')                                   
        mkdir(pathDefBinario);
    else
        fprintf(' ya ha sido creada= %s \n',pathDefBinario);
        filePattern = fullfile(pathDefBinario, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathDefBinario);
        end
end

% mkdir (pathCalyxBinario);
% mkdir (pathDefectosBin);

encabezado = {'Imagen','Precision','Exactitud','Sensibilidad','Especificidad'};
% archivo = 'C:\Users\Mechi\Downloads\Telegram Desktop\DataNew\new\ficherometricas.xlsx';  
archivo = 'D:\resultado\r_param\ficherometricas.xlsx';  
matriz={};
sheet=1;
xlRange = 'A1'; %celda en donde empieza el excel
xlswrite(archivo,encabezado,sheet,xlRange); 

%% Definición a cero de las variables promedio
    acumuladoPrecision=0.0;
    acumuladoExactitud=0.0;
    acumuladoSensibilidad=0.0;
    acumuladoEspecificidad=0.0;

    promedioPrecision=0.0;
    promedioExactitud=0.0;
    promedioSensibilidad=0.0;
    promedioEspecificidad=0.0;
    
    listado=dir(strcat(pathMarked,'*.jpg')); %HOJAS PINTADAS MAGENTA
     
    for n=1:size(listado) 
        nombreImagenP=listado(n).name;
        nombreImagenDefBin=strcat(pathDefectosBin,nombreImagenP);
        nombreMascaraExperto=strcat(pathMarked2,nombreImagenP);
        nombreMascaraTPTN=strcat(pathTPTNBin,nombreImagenP,'_','TPTN','.jpg');
        nombreMascaraFPFN=strcat(pathFPFNBin,nombreImagenP,'_','FPFN','.jpg');
        nombreMascaraFN=strcat(pathFNBin,nombreImagenP,'_','FN','.jpg');
        nombreMascaraFP=strcat(pathFPBin,nombreImagenP,'_','FP','.jpg');
        nombreMascaraTP=strcat(pathTPBin,nombreImagenP,'_','TP','.jpg');
        nombreMascaraTN=strcat(pathTNBin,nombreImagenP,'_','TN','.jpg');
        nombreMascaraTPFPFN=strcat(pathTPFPFNBin,nombreImagenP,'_','TO','.jpg');
        
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
        
        %% planilla
        matriz{n,1}=  nombreImagenP;
        matriz{n,2}= precision;
        matriz{n,3}= exactitud;
        matriz{n,4}= sensibilidad;
        matriz{n,5}= especificidad;
    end
    totalPruebas=n;
    %% CALCULO DE PROMEDIO
    promedioPrecision=acumuladoPrecision/totalPruebas;
    promedioExactitud=acumuladoExactitud/totalPruebas;    
    promedioSensibilidad=acumuladoSensibilidad/totalPruebas;
    promedioEspecificidad=acumuladoEspecificidad/totalPruebas;

    
xlRange = 'A2';
xlswrite(archivo,matriz,sheet,xlRange);
vector={};
vector{1}=promedioPrecision;
vector{2}=promedioExactitud;
vector{3}=promedioSensibilidad;
vector{4}=promedioEspecificidad;

xlRange = 'G4';
cabecera={'P_Precision','P_Exactitud','P_Sensibilidad','P_Especificidad'};
xlswrite(archivo,cabecera,sheet,xlRange);

xlRange = 'G5';
xlswrite(archivo,vector,sheet,xlRange);

fprintf('--------------------------------\n');
fprintf('RESULTADO PROMEDIO EN %i PRUEBAS\n', totalPruebas);
fprintf('--------------------------------\n');    
fprintf('APrecision=%f, AExactitud=%f, ASensibilidad=%f AEspecificidad=%f\n', acumuladoPrecision, acumuladoExactitud,acumuladoSensibilidad, acumuladoEspecificidad);
fprintf('precision=%f, exactitud=%f, sensibilidad=%f especificidad=%f\n', promedioPrecision, promedioExactitud, promedioSensibilidad, promedioEspecificidad);

