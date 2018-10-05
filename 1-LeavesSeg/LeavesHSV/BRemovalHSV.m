function [] = BRemovalHSV(imagenInicialRGB, imagenNombreFR, tamanoObjeto)
% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% ------------------------
    im = imread(imagenInicialRGB);
    %% Aplicacion de filtro de la mediana [3x3]
    med = imfilter(im,fspecial('average')); 
    imHSV = rgb2hsv(med);
    %% separar en canal Saturacion [S]
    S=imHSV(:,:,2);   
    %% Aplicación de método global Otsu a nivel 0.4941%
    sotsu = graythresh(S);
    %% Binarizado con graythresh
    SW=im2bw(S,sotsu);
%% Elimina los elementos cuya area es igual al parametro, deja los elementos grandes
    IB3=bwareaopen(SW,tamanoObjeto);

%% rellenado de agujeros para obtener siluetas    
    IB4= imfill(IB3,'holes');
%%----------------------------------
%% guardar imagen final con los contorno de la fruta
imwrite(IB4,imagenNombreFR,'jpg');
end
