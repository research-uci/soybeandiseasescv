clc;
clear;
close all; 

home          = strcat(pwd,'/');
direccion     = strcat(home,'Escritorio/pruebaTrainingTest/');
paraTest     = strcat(direccion,'paraTest/');
mkdir        (paraTest);
imageSource  = strcat(home,'Escritorio/SOURCE/');
% los que sobran para test
imagejpg2    = dir(fullfile(imageSource,'*.jpg'));
numfiles2    = length(imagejpg2);

for kk=1 : numfiles2
    name=imagejpg2(kk).name; % toma nombre de source
    filename = strcat(imageSource,name);
    movefile(filename,paraTest);   
end

run('pruebaTrainingTest3.m');
