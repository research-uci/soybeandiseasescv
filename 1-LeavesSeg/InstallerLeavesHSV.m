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
pathLeavesSeg=strcat(pathMain,'LeavesSeg/')
pathLeavesMet=strcat(pathLeavesSeg,'LeavesHSV/')
pathTmpToLearn=strcat(pathLeavesMet,'tmpToLearn/')
% --------------------------------------------
pathBR=strcat(pathTmpToLearn,'br/')
pathRemoved=strcat(pathTmpToLearn,'removed/')
pathROI=strcat(pathTmpToLearn,'roi/')
pathSLEAVES=strcat(pathTmpToLearn,'sLeaves/')

% ------------------------------------
mkdir(pathMain);
mkdir(pathLeavesSeg);
mkdir(pathLeavesMet);
mkdir(pathTmpToLearn);
mkdir(pathBR);
mkdir(pathRemoved);
mkdir(pathROI);
mkdir(pathSLEAVES);
% ------------------------------------
