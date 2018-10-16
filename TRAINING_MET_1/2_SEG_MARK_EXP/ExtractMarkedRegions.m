function [ ] = ExtractMarkedRegions(pathEntrada, pathAplicacion, nombreImagenP)
% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% Extrae las enfermedades pintadas en hojas, genera como salida un archivo con
% datos separados por comas y genera imagenes intermedias con los defectos
% en, la fruta y los defectos, el contorno de las frutas.
%
%
% -----------------------------------------------------------------------

%% Datos de configuración archivos
imagenInicial=strcat(pathEntrada,nombreImagenP); %para escritura en archivo de resultados
pathAplicacion3=strcat(pathAplicacion,'IRM/'); %imagen generada previamente con fondo removido
pathAplicacion6=strcat(pathAplicacion,'cDefectos/');


%% CONFIGURACIONES DEFECTOS MASCARA Y COLOR
pathCalyxColor=strcat(pathAplicacion,'cCalyx/'); %almacenado de enfermedad en color
pathCalyxBinario=strcat(pathAplicacion,'MCalyxBin/'); %almacenado de enfermedad marcada en binario

%pathDefColor=strcat(pathAplicacion,'cDefColor/'); %almacenado de defectos color
%pathDefBinario=strcat(pathAplicacion,'MDefBin/'); %almacenado de defectos binario


%pathTodosBin=strcat(pathAplicacion,'todosBin/'); %juntado


% nombres de archivos con objetos removidos
nombreImagenRemovida1=strcat(pathAplicacion3,nombreImagenP,'_','rm1.jpg');
%nombreImagenRemovida2=strcat(pathAplicacion3,nombreImagenP,'_','rm2.jpg');
%nombreImagenRemovida3=strcat(pathAplicacion3,nombreImagenP,'_','rm3.jpg');
%nombreImagenRemovida4=strcat(pathAplicacion3,nombreImagenP,'_','rm4.jpg');


%nombreImagenRemovidaMarca1=strcat(pathAplicacionRemMarca,nombreImagenP,'_','Mrm1.jpg');
%nombreImagenRemovidaMarca2=strcat(pathAplicacionRemMarca,nombreImagenP,'_','Mrm2.jpg');
%nombreImagenRemovidaMarca3=strcat(pathAplicacionRemMarca,nombreImagenP,'_','Mrm3.jpg');
%nombreImagenRemovidaMarca4=strcat(pathAplicacionRemMarca,nombreImagenP,'_','Mrm4.jpg');


    %% salida segmentacion
%    nombreImagenSalida1=strcat(pathAplicacion4,nombreImagenP,'_','so1.jpg');
%    nombreImagenSalida2=strcat(pathAplicacion4,nombreImagenP,'_','so2.jpg');
%    nombreImagenSalida3=strcat(pathAplicacion4,nombreImagenP,'_','so3.jpg');
%    nombreImagenSalida4=strcat(pathAplicacion4,nombreImagenP,'_','so4.jpg');

    %% salida defectos
%    nombreImagenDefectos1=strcat(pathAplicacion5,nombreImagenP,'_','soM1.jpg');
%    nombreImagenDefectos2=strcat(pathAplicacion5,nombreImagenP,'_','soM2.jpg');
%    nombreImagenDefectos3=strcat(pathAplicacion5,nombreImagenP,'_','soM3.jpg');
%    nombreImagenDefectos4=strcat(pathAplicacion5,nombreImagenP,'_','soM4.jpg');

    %% salida defectos en COLOR
    nombreImagenDefectosC1=strcat(pathAplicacion6,nombreImagenP,'_','soC1.jpg');
%    nombreImagenDefectosC2=strcat(pathAplicacion6,nombreImagenP,'_','soC2.jpg');
%    nombreImagenDefectosC3=strcat(pathAplicacion6,nombreImagenP,'_','soC3.jpg');
%    nombreImagenDefectosC4=strcat(pathAplicacion6,nombreImagenP,'_','soC4.jpg');

    
    
    %% salida contornos
%    nombreImagenContorno1=strcat(pathAplicacion7,nombreImagenP,'_','CM1.jpg');
%    nombreImagenContorno2=strcat(pathAplicacion7,nombreImagenP,'_','CM2.jpg');
%    nombreImagenContorno3=strcat(pathAplicacion7,nombreImagenP,'_','CM3.jpg');
%    nombreImagenContorno4=strcat(pathAplicacion7,nombreImagenP,'_','CM4.jpg');
    

    %DEFINICION DE NOMBRES DE IMAGENES PARA CALYX SEGMENTADO EN COLOR Y EN
    %BINARIO
    nombreImagenCalyxColor1=strcat(pathCalyxColor,nombreImagenP,'_','CALC1.jpg'); % imagen en color calyx
%    nombreImagenCalyxColor2=strcat(pathCalyxColor,nombreImagenP,'_','CALC2.jpg');
%    nombreImagenCalyxColor3=strcat(pathCalyxColor,nombreImagenP,'_','CALC3.jpg');
%    nombreImagenCalyxColor4=strcat(pathCalyxColor,nombreImagenP,'_','CALC4.jpg');    

    nombreImagenCalyxBin1=strcat(pathCalyxBinario,nombreImagenP,'_','CALB1.jpg'); %mascara binaria calyx
%    nombreImagenCalyxBin2=strcat(pathCalyxBinario,nombreImagenP,'_','CALB2.jpg');
%    nombreImagenCalyxBin3=strcat(pathCalyxBinario,nombreImagenP,'_','CALB3.jpg');
%    nombreImagenCalyxBin4=strcat(pathCalyxBinario,nombreImagenP,'_','CALB4.jpg');    

%    nombreImagenDefBin1=strcat(pathDefBinario,nombreImagenP,'_','DEFB1.jpg'); %mascara binaria calyx
%    nombreImagenDefBin2=strcat(pathDefBinario,nombreImagenP,'_','DEFB2.jpg');
%    nombreImagenDefBin3=strcat(pathDefBinario,nombreImagenP,'_','DEFB3.jpg');
%    nombreImagenDefBin4=strcat(pathDefBinario,nombreImagenP,'_','DEFB4.jpg');    
    
    
    
%% GRANULOMETRIAS
   
%% -- BEGIN DEFECTS FEATURES EXTRACTION ----------------------------------
%% Segmentacion de mascara para obtener defectos aislados de ROI
%% Separación de calyx pintado
fprintf('Separación de ENFERMEDADES pintadas en color MAGENTA--> \n');
backgroundRemoval4(nombreImagenRemovida1, nombreImagenCalyxBin1, nombreImagenCalyxColor1);   

%% -- END DEFECTS FEATURES EXTRACTION ----------------------------------
    
% -----------------------------------------------------------------------
end %end proceso completo

