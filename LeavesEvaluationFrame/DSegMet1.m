function [ output_args ] = DSegMet1(nombreImagenSegmentar, nombreImagenSalida)
%% segmentacion con filtros Sobel
IOrig=imread(nombreImagenSegmentar);

IGris=rgb2gray(IOrig);
h1=fspecial('average',[3,3]); %el filtro de la media influye, anteriormente [5,5]
media1=imfilter(IGris,h1);

BW3 = edge(media1,'Sobel');
SE = strel('disk', 2);
BW4 = imclose(BW3,SE);

%% Almacenar en archivos las imagenes de clusteres
imwrite(BW4,nombreImagenSalida,'jpg');

end

