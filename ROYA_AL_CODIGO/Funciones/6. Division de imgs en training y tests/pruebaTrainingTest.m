clc;
clear;
close all; 

home          = strcat(pwd,'/');
direccion     = strcat(home,'Escritorio/pruebaTrainingTest/');
mkdir         (direccion);

paraTraining     = strcat(direccion,'paraTraining');
mkdir        (paraTraining);

% paraTest     = strcat(direccion,'paraTest');
% mkdir        (paraTest);

imageExperto = strcat(home,'Escritorio/MARKED/');
imageSource  = strcat(home,'Escritorio/SOURCE/');
imagejpg     = dir(fullfile(imageExperto,'*.jpg'));
numfiles     = length(imagejpg);


%para training
for kk=1 : numfiles
    name=imagejpg(kk).name; % toma nombre de MARKED
    filename = strcat(imageSource,name);
    movefile(filename,paraTraining);   
end
run('pruebaTrainingTest2.m');
