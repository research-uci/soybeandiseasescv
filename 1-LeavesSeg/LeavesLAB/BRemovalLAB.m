function [] = BRemovalLAB(imagenInicialRGB, imagenNombreFR, nombreImagenF, tamanoObjeto, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax)
% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################

% Crea una máscara a partir de una imagen RGB utilizando umbralizacion y el
% espacio LAB con un máximo y un mínimo en cada canal.
% como resultado se genera una imagen intermedia, con siluetas de las
% frutas, la misma es utilizada por otros procesos. 
% Codigo generado con colorThresholder app on 02-Sep-2017

% abrir imagen original
IRGB=imread(imagenInicialRGB);

% Convertir imagen RGB al espacio CIELAB
IRGB = im2double(IRGB);
cform = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('D65'));
I = applycform(IRGB,cform);

% Crear mascara según los umbrales del historgrama
BW = (I(:,:,1) >= canalLMin ) & (I(:,:,1) <= canalLMax) & ...
    (I(:,:,2) >= canalAMin ) & (I(:,:,2) <= canalAMax) & ...
    (I(:,:,3) >= canalBMin ) & (I(:,:,3) <= canalBMax);

%Se vuelve a invertir para dejar con unos la silueta
mascaraInversa=1-BW;

% Aplicacion de operacion erosion
IB1=mascaraInversa;
%% Llenado de agujeros

%% --------------------------------------

%% Elimina los elementos cuya area es igual al parametro, deja los elementos grandes
IB2=bwareaopen(IB1,tamanoObjeto);
%%----------------------------------

%% rellenado de agujeros para obtener siluetas    
IB3= imfill(IB2,'holes');

%% guardar imagen final con los contorno de la fruta
imwrite(IB3,imagenNombreFR,'jpg');

end
