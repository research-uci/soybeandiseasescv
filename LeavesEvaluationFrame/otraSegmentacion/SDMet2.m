function [ ] = SDMet2(nombreImagenSegmentar, nombreImagenSalida)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
IOrig=imread(nombreImagenSegmentar);
IGris=rgb2gray(IOrig);

%% filtrado para suavizar la imagen
%h1=fspecial('average',[3,3]); %el filtro de la media influye, anteriormente [5,5]
%media1=imfilter(IGris,h1);

media1=IGris;

%% obtener gradientes, los gradientes indican donde cambian los colores
[Gmag, ~] = imgradient(media1,'Prewitt');
I = mat2gray(Gmag);

%nivel=0.10; %umbral colocado en base a la experiencia
nivel=graythresh(I);
IB2=im2bw(I,nivel);

% apertura para eliminar los detalles pequeños
%SE = strel('disk', 1);
%IB3 = imopen(IB2,SE);

%% Almacenar en archivos las imagenes de clusteres
imwrite(IB2,nombreImagenSalida,'jpg');
%imwrite(IB3,nombreImagenSalida,'jpg');
end

