%% Main Script roya_startup
% -------------------------------------------------------------------------
% Este script inicializa el matlab workspace, define paths y
% variables globales para roya2018
% Llama este script desde su ubicación local
% (home/user/roya2018/Startup.m)
% -------------------------------------------------------------------------
% Alice Nathalia Colmán Barboza
% 1 de Octubre del 2018
% -------------------------------------------------------------------------
%% Inicialización
clear; 
close all; 
clc;
%% Definición de variables globales
global pathSeg;            ...                                             | path donde se guardan las imágenes con remoción de fondo (segmentación)
global pathBin;            ...                                             | path donde se guardan las imágenes binarias
global pathCrop;           ...                                             | path donde se guardan las imágenes recortadas
global pathRust;      
%% Definición paths principales de roya-2017
home          = strcat(pwd,'/');
strDir        = strcat(home,'Escritorio/roya2018/');
mkdir         (strDir);    ...                                             | Aqui se guardaran todos los resultados
%% Definición de paths de base de datos haz
pathHaz = strcat(home,'Escritorio/bd/'); ...         | path donde se encuentran las imágenes de haz (parte superior de la hoja)
%% Funciones
pathSeg        = segmentarHoja(strDir,pathHaz);
pathBin        = binarizarHoja(strDir,pathSeg);
pathCrop       = cropImagen(strDir,pathSeg,pathBin);
pathRust       = getRust(strDir,pathCrop);
run('mainEnt')
% run('main')
