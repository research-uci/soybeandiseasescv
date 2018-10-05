
%% %-----------  Inicialización  --------------------------------------
clear; 
close all; 
clc;

%% %-----------  Definiendo rutas generales  ---------------------------
pathPrincipal = '/home/alice/Alice-Tesis/imgs/'; 
pathRenombradas = strcat(pathPrincipal, 'imgs_renombradas/');

%% %-----------  Creando ruta para imagenes segmentadas ----------------
pathSegmentadas = 'imgs_segmentadas/';
f_seg = strcat(pathPrincipal,pathSegmentadas); 

mkdir(f_seg); 

%% %-----------  Llamada de imágenes y procesos ------------------------
renombradasJPG = dir('/home/alice/Alice-Tesis/imgs/imgs_renombradas/*.jpg'); ... dir de la carpeta que contiene imagenes
n_renJPG = length(renombradasJPG); ... cantidad de imágenes en carpeta

for i = 1 : n_renJPG
    name = renombradasJPG(i).name;
    filename = strcat(pathRenombradas,name);
    im = imread(filename);
    
    %% Aplicacion de filtro de la mediana [3x3]
    med = imfilter(im,fspecial('average')); 
    imHSV = rgb2hsv(med);
    
    %% separar en canal Saturacion [S]
    S=imHSV(:,:,2);
    
    %% Aplicación de método global Otsu a nivel 0.4941%
    sotsu = graythresh(S);
    
    %% Binarizado con graythresh
    SW = imbinarize(S,sotsu);
    
    %% Multiplicación para la eliminación del fondo
    ima = im;
    
    ima(:,:,1) = immultiply(im(:,:,1),SW);
    ima(:,:,2) = immultiply(im(:,:,2),SW);
    ima(:,:,3) = immultiply(im(:,:,3),SW);
    
    % muestra el resultado de la imagen
    imshow(ima);
    
    % elimina el .jpg
    newStr = erase(name,".jpg");
    
    % agrega el S00n
    newName = strrep(newStr,'R','S');
    
    % parametros: (imagen que muestra a guardar, [direccion de carpeta en
    % donde guarda, nombre de la imagen original, formato a guardar])
      imwrite(ima,[f_seg,newName,'.png']);

end 
    
