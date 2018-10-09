function [ ] = objectDetectionCut( imagenNombreFR, imagenNombreROI, nombreImagenRemovida)
% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% SALIDAS= nombreImagenSiluetaN, nombreImagenRemovida

% Recibe una imagen segmentada en blanco y negro, esta se utiliza como
% mascara para detectar los objetos. El procedimiendo consiste en detectar
% las regiones de pixeles y recortar los objetos para separarlos en
% imagenes más pequenas.


%% Lectura de la imagen con fondo removido
IFR=imread(imagenNombreFR);
ImROI=imread(imagenNombreROI);


%% Binarización de la silueta fondo removido
umbral=graythresh(IFR);
IFRB1=im2bw(IFR,umbral); %Imagen tratada

%% Etiquetar elementos conectados

[ListadoObjetos Ne]=bwlabel(IFRB1);

%% Calcular propiedades de los objetos de la imagen
propiedades= regionprops(ListadoObjetos);

%% Buscar áreas de pixeles correspondientes a objetos
seleccion=find([propiedades.Area]);

%% obtenr coordenadas de areas
contadorObjetos=0; %encontrados
numeroCuadro='';
for n=1:size(seleccion,2)
    contadorObjetos=contadorObjetos+1;
    coordenadasAPintar=round(propiedades(seleccion(n)).BoundingBox);
    %% recorta las imagenes
    IFondoR = imcrop(ImROI,coordenadasAPintar);
    %% deteccion del numero de cuadro
    salidaRemovida=strcat(nombreImagenRemovida, numeroCuadro, int2str(contadorObjetos),'.jpg');
    imwrite(IFondoR,salidaRemovida,'jpg');    
end % fin de ciclo

end

