clc; clear all; close all;
addpath 'C:\Program Files\MATLAB\R2017a\funciones\natsortfiles'; 

path='C:\Users\Mechi\Dropbox\TESIS\matlab\tesis2018\soy\';  %SOURCE DE IMAGENES
path2='C:\Users\Mechi\Pictures\soja\soy\'; %SOURCE DE IMAGENES MARCADAS
%%%im=imread('C:\Users\Mechi\Pictures\soja\soy\1_1_1.jpg'); ruta de hojas
%%%marcadas

HOME='D:\';
Resultado='SOURCE_PICTURES\';
pathresultado=strcat(HOME, Resultado);


if ~exist(pathresultado, 'dir')
        mkdir(pathresultado);
        fprintf('%s \n',pathresultado,'Creando directorio.');
else
        fprintf('%s \n',pathresultado,'ya ha sido creada.');
end

source='source\';
pathsource=strcat(pathresultado, source);

if ~exist(pathsource, 'dir')
        mkdir(pathsource);
        fprintf('%s \n',pathsource,'Creando directorio.');
else
        fprintf('%s \n',pathsource,'ya ha sido creada.');
end

marked='marked\';
pathmarked=strcat(pathresultado, marked);

if ~exist(pathmarked, 'dir')
        mkdir(pathmarked);
        fprintf('%s \n',pathmarked,'Creando directorio.');
else
        fprintf('%s \n',pathmarked,'ya ha sido creada.');
end

formato='.jpg';         %formato de imagen
formato2='*.jpg';

files=dir([path formato2]);                     %lectura de directorio
[~,ndx] = natsortfiles({files.name});           %asigancion de indices 
files = files(ndx);                             %ordenacion de indices en orden alfabético  %esto se repite tantas veces como el se toman archivos de carpetas, dentro del código aparecen varias veces.

files4=dir([path2 formato2]);
[~,ndx4] = natsortfiles({files4.name}); 
files4 = files4(ndx4);

for k = 1:length(files)                         %este for va desde 1 hasta cuantas imagenes se encuentran en la carpeta.
    files(k).name;                              %se recorre files dependiendo de la posicion
    files4(k).name;
    sourcergbname=files(k).name;                      %almacena nombre de la imagen
    magentaname=files4(k).name;
    imag=imread([path files(k).name]);          %lee imagen 
    imagmagenta=imread([path2 files4(k).name]); 
    switch k
%             case  {48, 49,76,81,88,91,93,96,97,100,104,105,106,107,108,109,111,112,113,114,115}
%                     imag=imrotate(imag,90); 
%                     
%             case {50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,77,78,79,80,82,83,84,85,86,87,89,90,92,94,95,98,99,101,102,103,110}
%                     imag=imrotate(imag,180);
%       
%             case {94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115}
%                     imagmagenta=imrotate(imagmagenta,-90);
                    
        case {48,49,76,81,88,91,93}
            imag=imrotate(imag,90);
        case {50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,77,78,79,80,82,83,84,85,86,87,89,90,92}
            imag=imrotate(imag,180);
        case {96,97,100,104,105,106,107,108,109,111,112,113,114,115}
            imag=imrotate(imag,90);
            imagmagenta=imrotate(imagmagenta,90);
        case {94,95,98,99,101,102,103,110}
            imag=imrotate(imag,180);
            imagmagenta=imrotate(imagmagenta,90);
             
            
    end
   imwrite((imag),[pathsource,sourcergbname]); 
   imwrite((imagmagenta),[pathmarked,magentaname]);    
   
end