% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% Se crean los directorios de necesarios para correr el software de
% segmentación


%% Ajuste de parámetros iniciales
clc; clear all; close all;

HOME=strcat(pwd,'/');
pathMain=strcat(HOME,'SoyResults3/');
pathCompare=strcat(pathMain,'compare/')

%---------------------
mkdir(pathMain);
mkdir(pathCompare);
%---------------------

pathMarkedByExpert=strcat(pathCompare,'MARKED_BY_EXPERT/')
pathMarked=strcat(pathCompare,'MARKED/')
pathSDMet=strcat(pathCompare,'SDMet1/')
pathSpots=strcat(pathSDMet,'spots/')

%---------------------
mkdir(pathMarkedByExpert);
mkdir(pathMarked);
mkdir(pathSDMet);
mkdir(pathSpots);
%---------------------


pathMSpotBin=strcat(pathMarkedByExpert,'MSpotBin/')
pathCompareMet=strcat(pathCompare,'CompareSDMet1/')
pathExpertBin=strcat(pathCompareMet,'ExpertoBin/');
pathFNBin=strcat(pathCompareMet,'FNBin/');
pathFPFNBin=strcat(pathCompareMet,'FPFNBin/');
pathTNBin=strcat(pathCompareMet,'TNBin/');
pathTPBin=strcat(pathCompareMet,'TPBin/');
pathTPFPFNBin=strcat(pathCompareMet,'TPFPFNBin/');
pathTPTNBin=strcat(pathCompareMet,'TPTNBin/');

%---------------------
mkdir(pathMSpotBin);
mkdir(pathCompareMet);
mkdir(pathExpertBin);
mkdir(pathFNBin);
mkdir(pathFPFNBin);
mkdir(pathTNBin);
mkdir(pathTPBin);
mkdir(pathTPFPFNBin);
mkdir(pathTPTNBin);
%---------------------

