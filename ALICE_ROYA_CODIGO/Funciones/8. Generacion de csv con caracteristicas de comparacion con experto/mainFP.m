%% Ajuste de parámetros iniciales
clc; clear all; close all;

 %% Definicion de estructura de directorios 
HOME=strcat(pwd,'/');
pathPrincipal=strcat(HOME,'Escritorio/compararPixeles/'); %
mkdir(pathPrincipal);
pathEntradaMarca=strcat(HOME,'Escritorio/Resultado_de_Magenta/imgscrop/'); %% obtiene la lista de imágenes a comparar

pathAplicacionCOMPARAR=strcat(pathPrincipal,'CompareSDMet1/'); %directorio donde se van a comparar los resultados
mkdir(pathAplicacionCOMPARAR);
% pathAplicacionONLINE=strcat(pathPrincipal,'SDMet1/'); %directorio donde se colocan imagenes a evaluar
% mkdir(pathAplicacionONLINE);
pathAplicacionMARCAS=strcat(HOME,'Escritorio/Magenta/imgs_magenta_bin/'); %directorio donde se colocan maraciones del experto en binario
nombreImagenP='nombreImagenP'; %imagen original
pathCalyxBinario=strcat(HOME,'Escritorio/mLABBIN/'); %almacenado de calyx en binario POR MARCAS (binario marcas software)
pathExpertoBin=strcat(HOME,'Escritorio/Magenta/imgs_magenta/'); % resultados defectos EXPERTO (binario) %imgs_magenta_bin
%% software
pathDefectosBin=strcat(HOME,'Escritorio/roya2018/imgsrust/mLAB/'); % siluetas defectos por SOFTWARE ONLINE (a color?)


pathFPFNBin=strcat(pathAplicacionCOMPARAR,'FPFNBin/'); % comparacion
pathTPTNBin=strcat(pathAplicacionCOMPARAR,'TPTNBin/'); % comparacion
pathFNBin=strcat(pathAplicacionCOMPARAR,'FNBin/'); % comparacion
pathFPBin=strcat(pathAplicacionCOMPARAR,'FPBin/'); % comparacion
pathTPBin=strcat(pathAplicacionCOMPARAR,'TPBin/'); % comparacion
pathTNBin=strcat(pathAplicacionCOMPARAR,'TNBin/'); % comparacion
pathTPFPFNBin=strcat(pathAplicacionCOMPARAR,'TPFPFNBin/'); % comparacion

mkdir (pathFPFNBin);
mkdir (pathTPTNBin);
mkdir (pathFNBin);
mkdir (pathFPBin);
mkdir (pathTPBin);
mkdir (pathTNBin);
mkdir (pathTPFPFNBin);


%% Definición a cero de las variables promedio
    acumuladoPrecision=0.0;
    acumuladoExactitud=0.0;
    acumuladoSensibilidad=0.0;
    acumuladoEspecificidad=0.0;

    promedioPrecision=0.0;
    promedioExactitud=0.0;
    promedioSensibilidad=0.0;
    promedioEspecificidad=0.0;


listado=dir(strcat(pathEntradaMarca,'*.png'));
%% lectura en forma de bach del directorio de la cámara

coHeader = {'Imagen' 'Precision' 'Exactitud' 'Sensibilidad' 'Especificidad'};
co_mmaHeader = [coHeader;repmat({','},1,numel(coHeader))]; %insert commaas
co_mmaHeader = co_mmaHeader(:)';
text_Header = cell2mat(co_mmaHeader); %cHeader in text with commas
archivo = 'detcciones.csv';
fid = fopen(archivo,'w');
fprintf(fid,'%s\n',text_Header);

for n=1:size(listado)
    %nombreImagenP='10_3_1.jpg_E1.jpg'
    nombreImagenP=listado(n).name; % imagen principal
    % se asume que siempre existen 4 imagenes

    %for ROI=1:1
%     ROI=1;
    % creadas con el proceso de separacion de roi 
        %nombreImagenDefBin=strcat(pathDefBinario,nombreImagenP,'_','DEFB', int2str(ROI),'.jpg'); %mascara binaria defectos
        nombreImagenCalyxBin=strcat(pathCalyxBinario,nombreImagenP); %mascara binaria calyx        
        % juntos, son los resultados que dio el EXPERTO defectos y calyx
        nombreMascaraExperto=strcat(pathExpertoBin,nombreImagenP);

        %% defectos online SOFTWARE
        nombreImagenSoftware=strcat(pathDefectosBin,nombreImagenP);
        nombreMascaraTPTN=strcat(pathTPTNBin,nombreImagenP,'_','TPTN');
        nombreMascaraFPFN=strcat(pathFPFNBin,nombreImagenP,'_');
        nombreMascaraFN=strcat(pathFNBin,nombreImagenP,'_','FN');
        nombreMascaraFP=strcat(pathFPBin,nombreImagenP,'_','FP');
        nombreMascaraTP=strcat(pathTPBin,nombreImagenP,'_','TP');        
        nombreMascaraTN=strcat(pathTNBin,nombreImagenP,'_','TN');        
        nombreMascaraTPFPFN=strcat(pathTPFPFNBin,nombreImagenP,'_','TO');        
        
        
        %% JUNTAR MARCAS
%        fprintf('JUNTANDO REGIONES de clases del EXPERTO-> %s R=%i\n',listado(n).name,ROI);    
        %juntado(nombreImagenCalyxBin,nombreImagenDefBin, nombreMascaraExperto);
%         renombrado(nombreImagenCalyxBin, nombreMascaraExperto);
        %% DIFERENCIAS FALSE POSITIVE Y FALSE NEGATIVE
%        fprintf('FN Y FP -> DIFERENCIAS EXPERTO VS SOFTWARE-> %s R=%i \n',listado(n).name, ROI);        
        diferencia(nombreMascaraExperto, nombreImagenSoftware, nombreMascaraFPFN);
        %% obtener FN
%        fprintf('BUSCANDO FN -> EXPERTO VS FPFN %s R=%i \n',listado(n).name, ROI);
        coincidencia(nombreMascaraExperto, nombreMascaraFPFN, nombreMascaraFN);
        %% obtener FP
%        fprintf('BUSCANDO FP -> SOFTWARE VS FPFN %s R=%i \n',listado(n).name, ROI);        
        coincidencia(nombreImagenSoftware, nombreMascaraFPFN, nombreMascaraFP);
        %% obtener TPTN
%        fprintf('BUSCANDO TP -> EXPERTO VS SOFTWARE %s R=%i \n',listado(n).name, ROI);
        coincidencia(nombreMascaraExperto, nombreImagenSoftware, nombreMascaraTP);
    
%        fprintf('TN NOT EXPERTO + SOFTWARE -> %s R=%i \n',listado(n).name, ROI);  
        juntado(nombreMascaraExperto,nombreImagenSoftware, nombreMascaraTPFPFN);
        %% hace la inversa para contar en pixeles los TN
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
        F = {nombreImagenP,precision,exactitud,sensibilidad,especificidad};
        fprintf(fid,'%s \t %f \t %f \t %f \t %f\n',F{1},F{2},F{3},F{4},F{5});
    %end %fin de procesar 4 imagenes
       
    %% CALCULAR PROMEDIO
    %% GUARDAR EN ARCHIVO
%     disp(n);
%     if n==10
%         break;
%     end
end %
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
fprintf(fid,'\t \t \t\t\t\n');
fprintf(fid,'acumuladoPrecision\t acumuladoExactitud\t acumuladoSensibilidad\t acumuladoEspecificidad\t\n');
A = {acumuladoPrecision,acumuladoExactitud,acumuladoSensibilidad,acumuladoEspecificidad};
fprintf(fid,'%f \t %f \t %f \t %f \t\n',A{1},A{2},A{3},A{4});
fprintf(fid,'\t \t \t\t\t\n');
P = {promedioPrecision,promedioExactitud,promedioSensibilidad,promedioEspecificidad};
fprintf(fid,'promedioPrecision\t promedioExactitud\t promedioSensibilidad\t promedioEspecificidad\t\n');
fprintf(fid,'%f \t %f \t %f \t %f \t\n',P{1},P{2},P{3},P{4});
fclose(fid);
movefile('/home/alice/detcciones.csv',pathPrincipal) 
