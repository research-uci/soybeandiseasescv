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
pathLeavesEvaluation=strcat(pathMain,'LeavesEvaluation/');
pathTmpToLearn=strcat(pathLeavesEvaluation,'tmpToLearn/');
pathOutput=strcat(pathLeavesEvaluation,'output/');
pathTrainingDB=strcat(pathLeavesEvaluation,'trainingDB/');

mkdir(pathOutput);
mkdir(pathTrainingDB);
mkdir(pathMain);
mkdir(pathLeavesEvaluation);
mkdir(pathTmpToLearn);

% --- leaves segmentation ----------------------------
pathBR=strcat(pathTmpToLearn,'br/');
pathRemoved=strcat(pathTmpToLearn,'removed/');
pathROI=strcat(pathTmpToLearn,'roi/');
pathSLEAVES=strcat(pathTmpToLearn,'sLeaves/');

mkdir(pathBR);
mkdir(pathRemoved);
mkdir(pathROI);
mkdir(pathSLEAVES);
% ------------------------------------

% --- defect segmentation
pathRemoved=strcat(pathTmpToLearn,'removed/'); %imagen generada previamente con fondo removido
pathSilohuetteSpots=strcat(pathTmpToLearn,'sSpots/'); %imagen intermedia con frutas y defectos
pathOnlySpots=strcat(pathTmpToLearn,'spots/'); %solamente los defectos aislados
pathcolorSpots=strcat(pathTmpToLearn,'cSpots/');
pathLeavesContours=strcat(pathTmpToLearn,'leavesContours/'); %contornos de frutas
pathDetected=strcat(pathTmpToLearn,'detected/');
pathDetectedBin=strcat(pathTmpToLearn,'detectedBin/');


mkdir(pathRemoved);
mkdir(pathSilohuetteSpots);
mkdir(pathOnlySpots);
mkdir(pathcolorSpots);
mkdir(pathLeavesContours);
mkdir(pathDetected);
mkdir(pathDetectedBin);
% ------------------------------------

