% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% IMPLEMENTA MEJORAS EN LA EXTRACCION DE LS DEFECTOS, DADO QE TOMA LAS
% IMAGENES ORIGINALES EN RGB Y SEGMENTA LOS VALORES MARCADOS POR EL EXPERTO
%
% Genera imagenes de regiones previamente marcadas por un experto en forma
% MANUAL con un editor de imágenes.
% Es un proceso previo a la extraccion automatizada de características.
% Se asume que un experto marcó las frutas a mano con colores.
% Como salida se producen imágenes. Utiliza en paralelo imagenes
% originales e imágenes marcadas.
% Genera el paso previo a la creacion del archivo de ENTRENAMIENTO PARA EL
% CLASIFICADOR DE DEFECTOS.

%% Ajuste de parámetros iniciales
clc; clear all; close all;
 
 %% Definicion de estructura de directorios 
HOME=strcat(pwd,'/');
pathPrincipal=strcat(HOME,'SoyResults/byDisease/PSMet2/SegMarkExp/');
pathEntradaImagenesMarcas=strcat(HOME,'SoyResults/inputMarked/'); %entrada con imagenes marcadas por experto
pathEntradaImagenes=strcat(HOME,'SoyResults/inputToLearn/');
pathEntradaMarca=strcat(HOME,'SoyResults/inputTraining/'); %deben almacenarse imágenes marcadas para entrenamiento.
pathConfiguracion=strcat(pathPrincipal,'conf/'); %se guardan configuraciones
pathAplicacion=strcat(pathPrincipal,'tmpToLearn/'); %se utiliza para situar las imagenes de calibracion
pathAplicacionSiluetas=strcat(pathAplicacion,'sFrutas/');
pathResultados=strcat(pathPrincipal,'output/');%se guardan los resultados

nombreImagenP='nombreImagenP';


%% CONFIGURACIONES DE PROCESAMIENTO DE IMAGENES
areaObjetosRemoverBR=5000; % para siluetas y detección de objetos. Tamaño para realizar granulometria
% configuracion de umbrales
canalLMin = 3.432; canalLMax = 77.734; canalAMin = -4.215; canalAMax = 7.603; canalBMin = -6.477; canalBMax = 7.127; %parametros de umbralizacion de fondo


%% Remover archivos antiguos, borrar archivos antiguos
fprintf('LIMPIANDO IMAGENES ANTIGUAS \n');
removeFiles(strcat(pathAplicacion,'ROICalyxC/','*.jpg'));
removeFiles(strcat(pathAplicacion,'ROICalyxBin/','*.jpg'));
removeFiles(strcat(pathAplicacion,'MROI/','*.jpg'));
removeFiles(strcat(pathAplicacion,'MRM/','*.jpg'));
removeFiles(strcat(pathAplicacion,'MCalyxColor/','*.jpg'));
removeFiles(strcat(pathAplicacion,'MCalyxBin/','*.jpg'));
removeFiles(strcat(pathAplicacion,'ISLeaves/','*.jpg'));
removeFiles(strcat(pathAplicacion,'IROI/','*.jpg'));
removeFiles(strcat(pathAplicacion,'IRM/','*.jpg'));
removeFiles(strcat(pathAplicacion,'IBR/','*.jpg'));
removeFiles(strcat(pathAplicacion,'cDefectos/','*.jpg'));
removeFiles(strcat(pathAplicacion,'cCalyx/','*.jpg'));

%% --------------------------------------------------------------------
listado=dir(strcat(pathEntradaMarca,'*.jpg')); %recorre el listado de las imagenes marcadas
%% lectura en forma de bach del directorio de la cámara
for n=1:size(listado)
    fprintf('SEPARANDO REGIONES MARCADAS MANUALMENTE POR EL EXPERTO-> %s \n',listado(n).name);    
    nombreImagenP=listado(n).name;    
    %Se utiliza para separar las marcas hechas por expertos, los cuales
    %segmentaron con color magenta la enfermedad a buscar.
    ProcessMarks(pathEntradaImagenes, pathEntradaMarca, pathAplicacion, nombreImagenP, areaObjetosRemoverBR, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax )    
    %GENERA imagenes marcadas
    ExtractMarkedRegions(pathEntradaImagenes, pathAplicacion, nombreImagenP)
    if n==1
        break;
    end;
end %

fprintf('SE HAN SEPARADO LAS REGIONES MARCADAS POR EL EXPERTO \n');
fprintf('Debe correr el proceso para extraer las características \n');