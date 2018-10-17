function [] = SegmentDefMarksRGB(nombreImagenSegmentar, nombreImagenDEFROI, nombreImagenSalida, channel1Min, channel1Max, channel2Min, channel2Max, channel3Min, channel3Max)
% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%Extrae las mascaras pintadas por el experto haciendo uso de la tecnica de
%segmentacion por valores en el espacio RGB.
%------------------------------------------------------

RGB=imread(nombreImagenSegmentar);

% Convert RGB image to chosen color space
I = RGB;

% Create mask based on chosen histogram thresholds
BW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

nivel=graythresh(maskedRGBImage(:,:,3)); %umbral colocado en base a la experiencia
IB2=im2bw(maskedRGBImage(:,:,3),nivel);

%% Elimina los elementos cuya area es igual al parametro, deja los elementos grandes
IB3=bwareaopen(IB2,10);


%% Almacenar en archivos las imagenes de clusteres
imwrite(maskedRGBImage,nombreImagenDEFROI,'jpg');
imwrite(IB3,nombreImagenSalida,'jpg');
end
