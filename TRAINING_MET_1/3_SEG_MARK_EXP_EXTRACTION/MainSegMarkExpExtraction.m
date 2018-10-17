% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%{
% Genera archivos con características de las enfermedades marcadas, las cuales son utilizadas
para obtener datos de: color, textura y geometria de defectos y calyx.
REQUIRE DE UN PROCESO PREVIO, que genera imagenes de manchas colores y sus siluetas.

Cada imagen en un directorio base, cuenta con sub imágenes de regiones e
imágenes de siluetas. Ejemplo:
001.jpg es la imagen principal, existen imágenes de las regiones
para lo defectos y a su vez exiten imágenes específicas para sus siluetas
de defectos.
La función asume que hubo un procesamiento previo, en el cual se generaron
imágenes desde las marcas en colores dibujadas por e experto.
%}

%% Ajuste de parámetros iniciales
clc; clear all; close all;
 
 %% Definicion de estructura de directorios 
HOME=strcat(pwd,'/');
pathPrincipal=strcat(HOME,'SoyResults2/TrainingMet1/SegMarkExp/'); %Toma como entradas las imágenes generadas con el proceso anterior
pathPrincipal2=strcat(HOME,'SoyResults2/TrainingMet1/SegMarkExpExtraction/'); %

pathEntradaImagenesTraining=strcat(HOME,'SoyResults2/inputTraining/');
pathAplicacion=strcat(pathPrincipal,'tmpToLearn/'); %directorio de alojamiento de imagenes
 
 
%% Definicion de variables para resguardo de defectos y calyx
pathcalyxColor=strcat(pathAplicacion,'cSpot/'); %calyx en color
pathcalyxBin=strcat(pathAplicacion,'MSpotBin/'); %siluetas de calyx en binario
 
nombreImagenP='nombreImagenP';

% color de defectos para las regiones R1..R4
  postfijocDefectos1='_soC1.jpg';

  % COLOR DE CALYX
  postfijocalyxColor1='_CALC1.jpg';
  
  % BINARIO DE CALYX
  postfijocalyxBin1='_CALB1.jpg';
 
pathResultados=strcat(pathPrincipal2,'output/');%directorio para resultados
archivoBDENFERMEDADES=strcat(pathResultados,'BDENFERMEDADES.csv'); %salida completa

 %% Nombres de archivos de configuracion
 % trabajan con métodos para equivalencia con las 4 vistas

%% Remover archivos antiguos, borrar archivos antiguos
removeFiles(archivoBDENFERMEDADES);

%% --------------------------------------------------------------------
%carga del listado de nombres
listado=dir(strcat(pathEntradaImagenesTraining,'*.jpg'));


%% lectura en forma de bach del directorio de la cámara
for n=1:size(listado)
    fprintf('Extrayendo características para entrenamiento-> %s \n',listado(n).name);    
    nombreImagenP=listado(n).name;
    
    nombreImagenOriginal=nombreImagenP;
    %% Procesamiento de calyx en color y binario
    % Se asume que existen imágenes con o sin defectos por cada region
    % R1..R4.
   nombreImagencalyxColor1=strcat(pathcalyxColor,nombreImagenOriginal,postfijocalyxColor1);
   nombreImagencalyxBin1=strcat(pathcalyxBin,nombreImagenOriginal,postfijocalyxBin1);
   
   %% llamado para la extraccion de calyx
   etiqueta='ENFERMEDAD';
   defectDetectionExp( 1, nombreImagencalyxBin1, nombreImagencalyxColor1, archivoBDENFERMEDADES, nombreImagenOriginal, etiqueta);
      
   %% llamado para la extraccion de enfermedades      
   if n==10
        break;
   end;
end %

total=size(listado);

fprintf('\n -------------------------------- \n');
fprintf('Se procesaron un total de %i archivos \n',total(1));
fprintf('En el archivo %s se guardaron los DEFECTOS\n', archivoBDENFERMEDADES);
fprintf('\n -------------------------------- \n');
