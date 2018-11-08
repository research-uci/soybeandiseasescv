%% Parametros Iniciales
clc; 
clear all; 
close all;
%% Definición de variables globales
global pathSeg;            ...                                             | path donde se guardan las imágenes con remoción de fondo (segmentación)
global pathBin;            ...                                             | path donde se guardan las imágenes binarias
global pathCrop;           ...                                             | path donde se guardan las imágenes recortadas
                                       
home          = strcat(pwd,'/');
strDir        = strcat(home,'roya2018/');
mkdir         (strDir);  
%% Definición de paths de base de datos de imagenes escogidas originales
pathHaz = strcat(home,'Escritorio/MARKED/');

%% donde se guardaran los resultados
folder        = strcat(home,'Escritorio/Resultado_de_Magenta/');
mkdir         (folder);

%% Funciones
pathSeg       = segmentarHoja(folder,pathHaz);
pathBin       = binarizar(folder,pathSeg);
pathCrop      = cropImagen(folder,pathSeg,pathBin);

