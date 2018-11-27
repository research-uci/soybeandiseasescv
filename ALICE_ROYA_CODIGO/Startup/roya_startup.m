
% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% alycolbar@gmail.com, juancarlosmiranda81@gmail.com
% ########################################################################
% Main Script roya_startup
% -------------------------------------------------------------------------
% Este script inicializa el matlab workspace, define paths y
% variables globales para roya2018
% Llama este script desde su ubicación local
% (home/user/roya2018/Startup.m)
% -------------------------------------------------------------------------

%% Inicialización
clear; 
close all; 
clc;
%% Definición de variables globales
global pathSeg;            ...                                             | path donde se guardan las imágenes con remoción de fondo (segmentación)
global pathBin;            ...                                             | path donde se guardan las imágenes binarias
global pathCrop;           ...                                             | path donde se guardan las imágenes recortadas
global pathRust;           ...                                             | path donde se guardan las imágenes de manchas en L*A*B  
%% Definición paths principales de roya-2018
home          = strcat(pwd,'/');
strDir        = strcat(home,'Escritorio/roya2018/');
mkdir         (strDir);    ...                                             | Aqui se guardaran todos los resultados
%% Definición de paths de base de datos haz
%pathHaz = strcat(home,'Escritorio/SOURCE/'); ...                          | path donde se encuentran las imágenes de haz (parte superior de la hoja)
pathHaz = strcat(home,'Escritorio/clasificading/imgsprueba/'); ...         | path de imagenes seleccionadas      
%% Funciones
pathSeg        = segmentarHoja(strDir,pathHaz);
pathBin        = binarizarHoja(strDir,pathSeg);
pathCrop       = cropImagen(strDir,pathSeg,pathBin);
pathRust       = getRust(strDir,pathCrop);

fprintf('\n Empiezan extraccion de manchas con Kmeans\n');
run('manchasKmeans.m');
fprintf('\n Empiezan separacion de manchas en clases y generacion de csv\n');
run('separarClases.m');
fprintf('\n Empiezan division en carpetas \n');
run('separarImagenes.m');
fprintf('\n Empiezan procesos de segmentacion en hojas marcadas en magenta \n');
run('main.m');
fprintf('\n Empiezan extracciones en hojas marcadas en magenta \n');
run('mainMagenta.m');
fprintf('\n Empiezan copia de imagenes para csv \n');
run('mainComparar.m');
fprintf('\n Creacion de csv de precision, especificidad, sensibilidad, exactitud  \n');
run('LABbin.m');
run('mainFP.m');
