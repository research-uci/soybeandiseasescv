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
pathMain=strcat(HOME,'SoyResults2/');
pathTrainingMet=strcat(pathMain,'TrainingMet1/')

%---------------------
mkdir(pathMain);
mkdir(pathTrainingMet);

%---------------------
% SegMarkExp
pathSegMarkExp=strcat(pathTrainingMet,'SegMarkExp/')
pathTmpToLearn=strcat(pathSegMarkExp,'tmpToLearn/')
pathROISpotC=strcat(pathTmpToLearn,'ROISpotC/');
pathROISpotBin=strcat(pathTmpToLearn,'ROISpotBin/');
pathMROI=strcat(pathTmpToLearn,'MROI/');
pathMRM=strcat(pathTmpToLearn,'MRM/');
pathMSpotColor=strcat(pathTmpToLearn,'MSpotColor/');
pathMSpotBin=strcat(pathTmpToLearn,'MSpotBin/');
pathISLeaves=strcat(pathTmpToLearn,'ISLeaves/');
pathIROI=strcat(pathTmpToLearn,'IROI/');
pathIRM=strcat(pathTmpToLearn,'IRM/');
pathIBR=strcat(pathTmpToLearn,'IBR/');
pathcSpot=strcat(pathTmpToLearn,'cSpot/');

mkdir(pathSegMarkExp);
mkdir(pathTmpToLearn);
mkdir(pathROISpotC);
mkdir(pathROISpotBin);
mkdir(pathMROI);
mkdir(pathMRM);
mkdir(pathMSpotColor);
mkdir(pathMSpotBin);
mkdir(pathISLeaves);
mkdir(pathIROI);
mkdir(pathIRM);
mkdir(pathIBR);
mkdir(pathcSpot);
%---------------------



%---------------------
% SetCreator
pathSetCreator=strcat(pathMain,'SetCreator/')
pathOutput=strcat(pathSetCreator,'output/')
%----------
mkdir(pathSetCreator);
mkdir(pathOutput);
%----------

%---------------------
% SegMarkExpExtraction
pathSegMarkExpExtraction=strcat(pathMain,'SegMarkExpExtraction/')
pathOutput=strcat(pathSegMarkExpExtraction,'output/')
% -------------
mkdir(pathSegMarkExpExtraction);
mkdir(pathOutput);
%----------

