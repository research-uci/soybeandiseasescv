%% Parametros Iniciales
clc; 
clear; 
close all;
%% Creacion de paths
global pathSeg;            ...                                             | path donde se guardan las imágenes con remoción de fondo (segmentación)
global pathBin;            ...                                             | path donde se guardan las imágenes binarias
global pathCrop;           ...                                             | path donde se guardan las imágenes recortadas
global pathManchas;           ...                                          | path donde se guardan las imágenes recortadas2 

HOME          = strcat(pwd,'/');
% strDir        = strcat(HOME,'magentaResult/');
% mkdir         (strDir);

%% Definición de paths de base de datos de imagenes escogidas originales
pathHaz =  strcat(HOME,'Escritorio/Resultado_de_Magenta/imgscrop/');
folder        = strcat(HOME,'Escritorio/Magenta/');
mkdir         (folder);

%% Funciones
% pathSeg       = segmentarHoja(folder,pathHaz);
% pathBin       = binarizar(folder,pathSeg);
% pathCrop      = cropImagen(folder,pathSeg,pathBin);
pathManchas   = manchas(folder,pathHaz);

