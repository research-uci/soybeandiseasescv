function [ output_args ] = SDMet12(nombreImagenSegmentar, nombreImagenSalida)

%% segmentacion con filtros Sobel
IOrig=imread(nombreImagenSegmentar);

IGris=rgb2gray(IOrig);
h1=fspecial('average',[3,3]); %el filtro de la media influye, anteriormente [5,5]
media1=imfilter(IGris,h1);



BW3 = edge(media1,'Prewitt');
%SE = strel('diamond', 1);
%BW4 = imclose(BW3,SE);
%BW5 = imfill(BW4,'holes');

%SE = strel('diamond', 1);
%BW6 = imerode(BW5,SE);

%BW7=BW6;
%% Almacenar en archivos las imagenes de clusteres
%imwrite(BW7,nombreImagenSalida,'jpg');
imwrite(BW3,nombreImagenSalida,'jpg');

end

