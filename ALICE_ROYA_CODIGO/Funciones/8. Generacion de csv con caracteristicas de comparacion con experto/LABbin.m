clc; clear all; close all;
HOME=strcat(pwd,'/');
direcmLAB = strcat(HOME,'Escritorio/roya2018/imgsrust/mLAB/'); %
LABbbin = strcat(HOME,'Escritorio/mLABBIN/');
mkdir(LABbbin);
png = dir(fullfile(direcmLAB,'*.png'));
counter   = length(png);
for ii = 1 : counter
    name = png(ii).name;
    filename = strcat(direcmLAB,name);
    im = imread(filename);
    
    %% se pasa imagen a escala de grises
    grayImage = rgb2gray(im);
    
    %% se binariza
    binImage = imbinarize(grayImage);
    imwrite(binImage,[LABbbin,name,'.png']);
    
end
