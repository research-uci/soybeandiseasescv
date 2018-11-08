%% Parametros Iniciales
clc; 
clear; 
close all;
HOME          = strcat(pwd,'/');
%%-------------------------------------------------------------
paraComparar     = strcat(HOME,'Escritorio/paraComparar/');
mkdir        (paraComparar);

imageExperto = strcat(HOME,'Escritorio/Magenta/imgs_magenta/');
imageSource  = strcat(HOME,'Escritorio/roya2018/imgscrop/');
imagejpg     = dir(fullfile(imageExperto,'*.png'));
numfiles     = length(imagejpg);

for kk=1 : numfiles
    name=imagejpg(kk).name; % toma nombre de MARKED
    filename = strcat(imageSource,name);
    copyfile(filename,paraComparar);   
end
