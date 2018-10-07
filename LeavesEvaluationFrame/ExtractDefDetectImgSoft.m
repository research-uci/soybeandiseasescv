function [ ] = ExtractDefDetectImgSoft(pathEntrada, pathAplicacion, nombreImagenP, archivoVectorDef, tamanoManchas)
% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% Extrae caracteristicas en hojas, utiliza la técnica de máscara binaria
%
% tamanoManchas representa el tamano en pixeles, se utiliza para eliminar
% manchas pequenas y dejar un contorno de la fruta. El objetivo final es
% obtener solaente las manchas.
%
% Se generan imagenes intermedias que corresponden a:
% * imagen generada previamente con fondo removido
% * imagen intermedia con frutas y defectos
% * solamente los defectos aislados
%
% -----------------------------------------------------------------------

%% Datos de configuración archivos
imagenInicial=strcat(pathEntrada,nombreImagenP); %para escritura en archivo de resultados


pathAplicacion3=strcat(pathAplicacion,'removed/'); %imagen generada previamente con fondo removido
pathAplicacion4=strcat(pathAplicacion,'sSpots/'); %imagen intermedia con frutas y defectos
pathAplicacion5=strcat(pathAplicacion,'spots/'); %solamente los defectos aislados
pathAplicacion6=strcat(pathAplicacion,'cSpots/');
pathAplicacion7=strcat(pathAplicacion,'leavesContours/'); %contornos de frutas
pathAplicacionDeteccion=strcat(pathAplicacion,'detected/');
pathAplicacionDeteccionBin=strcat(pathAplicacion,'detectedBin/');

% nombres de archivos con objetos removidos
nombreImagenRemovida1=strcat(pathAplicacion3,nombreImagenP,'_','rm1.jpg');

    %% salida segmentacion
    nombreImagenSalida1=strcat(pathAplicacion4,nombreImagenP,'_','so1.jpg');

    %% salida defectos
    nombreImagenDefectos1=strcat(pathAplicacion5,nombreImagenP,'_','soM1.jpg');

    %% salida defectos en COLOR
    nombreImagenDefectosC1=strcat(pathAplicacion6,nombreImagenP,'_','soC1.jpg');
       
    %% salida contornos
    nombreImagenContorno1=strcat(pathAplicacion7,nombreImagenP,'_','CM1.jpg');
    

    nombreImagenSalidaDeteccion1=strcat(pathAplicacionDeteccion,nombreImagenP,'_','DET1.jpg');
    nombreImagenSalidaDeteccionBin1=strcat(pathAplicacionDeteccionBin,nombreImagenP,'_','DET1.jpg');
    
%% -- BEGIN DEFECTS FEATURES EXTRACTION ----------------------------------
%% Segmentacion de mascara para obtener defectos aislados de ROI
   fprintf('Segmentacion de mascara para obtener REGIONES CANDIDATAS A ENFERMEDAD ROI --> \n');
   DSegMet1(nombreImagenRemovida1, nombreImagenSalida1);
   
%   measureROICandidates(pathAplicacion, 1, nombreImagenSalida1, archivoVectorDef, nombreImagenP);
   %% EXTRACCION pREWITT DE LOS BORDES DE LA HOJA, VA CON segmentacion Prewitt
   extractRegionDSegMet1( nombreImagenSalida1, nombreImagenDefectos1, nombreImagenContorno1, tamanoManchas);
   
   
   measureROICandidates(pathAplicacion, 1, nombreImagenContorno1, archivoVectorDef, nombreImagenP);
%% Separación de defectos
    fprintf('Separación REGIONES CANDIDATAS A DEFECTOS en color --> \n');
    backgroundRemoval4(nombreImagenRemovida1, nombreImagenDefectos1, nombreImagenDefectosC1);

%% -- END DEFECTS FEATURES EXTRACTION ----------------------------------

%% CLSIFICAR DEFECTOS CANDIDATOS
% % defectos se llevan a un clasificador que cuenta por regiones los posibles
% defectos encontrados
fprintf('Detección de REGIONES CANDIDATAS A ENFERMEDAD en color --> \n');
detectROICandidates3( pathAplicacion, 1, nombreImagenRemovida1 ,nombreImagenDefectos1, nombreImagenDefectosC1, nombreImagenSalidaDeteccion1, nombreImagenSalidaDeteccionBin1,archivoVectorDef, nombreImagenP);

% -----------------------------------------------------------------------
end %end proceso completo

