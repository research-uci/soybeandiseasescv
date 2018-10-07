% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% Se generan datos obtenidos luego de aplicar un método de segmentación y
% un clasificador de defectos previamente entrenado. Al final se obtiene un
% listado con las clasificaciones de lo detectado.

%% Ajuste de parámetros iniciales
clc; clear all; close all;
 
%% Definicion de estructura de directorios 
HOME=strcat(pwd,'/');
pathPrincipal=strcat(HOME,'SoyResults/byDisease/LeavesSeg/LeavesHSV/'); %
pathEntradaImagenesTest=strcat(HOME,'SoyResults/Cercospora-inputTest/');
pathConfiguracion=strcat(pathPrincipal,'conf/');
pathAplicacion=strcat(pathPrincipal,'tmpToLearn/'); %
pathAplicacionSiluetas=strcat(pathAplicacion,'sLeaves/');
pathResultados=strcat(pathPrincipal,'output/');%se guardan los resultados

nombreImagenP='nombreImagenP';

%% CONFIGURACIONES DE PROCESAMIENTO DE IMAGENES
areaObjetosRemoverBR=5000; % para siluetas y detección de objetos. Tamaño para realizar granulometria

%% CONFIGURACIONES PARA DETECCION DE DEFECTOS
tamanoManchas=1000; %se utiliza para extracción de contornos. Los contornos se encuentran arriba de 1000 pixeles
archivoVectorDef=strcat(pathResultados,'aCandidatos.csv'); %archivo de salida candidatos a defectos

% ----- FIN Definicion de topes
%% Remover archivos antiguos, borrar archivos antiguos
fprintf('LIMPIANDO IMAGENES ANTIGUAS \n');
removeFiles(archivoVectorDef);
removeFiles(strcat(pathAplicacion,'sLeaves/','*.jpg'));
% removeFiles(strcat(pathAplicacion,'sDefectos/','*.jpg'));
removeFiles(strcat(pathAplicacion,'roi/','*.jpg'));
removeFiles(strcat(pathAplicacion,'removed/','*.jpg'));
% removeFiles(strcat(pathAplicacion,'deteccion/','*.jpg'));
% removeFiles(strcat(pathAplicacion,'defectos/','*.jpg'));
% removeFiles(strcat(pathAplicacion,'contornos/','*.jpg'));
% removeFiles(strcat(pathAplicacion,'cDefectos/','*.jpg'));
removeFiles(strcat(pathAplicacion,'br/','*.jpg'));


%% --------------------------------------------------------------------
%carga del listado de nombres
listado=dir(strcat(pathEntradaImagenesTest,'*.jpg'));

%% lectura en forma de bach del directorio de la cámara
for n=1:size(listado)
    fprintf('Extrayendo características para entrenamiento-> %s \n',listado(n).name);    
    nombreImagenP=listado(n).name;
    ProcessImgSoftHSV(pathEntradaImagenesTest, pathAplicacion, nombreImagenP, areaObjetosRemoverBR);
    %if n==1
    %    break;
    %end %if n==11
end %

%total=size(listado);

fprintf('\n -------------------------------- \n');
fprintf('Se procesaron un total de %i archivos \n',n);
fprintf('\n -------------------------------- \n');
