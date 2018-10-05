function [ ] = ProcessImgSoftHSV(pathEntrada, pathAplicacion, nombreImagenP, areaObjetosRemoverBR)
% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%Por cada fotografia, se separa el fondo, segmentando imagenes
% * FONDO REMOVIDO. 
% * SILUETAS CORRESPONDIENTE AL FONDO REMOVIDO
% características geométricas.

% -----------------------------------------------------------------------

%% Datos de configuración archivos
imagenInicial=strcat(pathEntrada,nombreImagenP);


%% DIRECTORIOS DE GUARDADO
pathAplicacionBR=strcat(pathAplicacion,'br/'); %background removal
pathAplicacionROI=strcat(pathAplicacion,'roi/'); %region of interest

pathAplicacion2=strcat(pathAplicacion,'sLeaves/'); %siluetas de frutas
pathAplicacion3=strcat(pathAplicacion,'removed/'); %imagenes fondo removido

% --- NOMBRE DE IMAGENES INTERMEDIAS ---
% con fondo removido
nombreImagenBR=strcat(pathAplicacionBR,nombreImagenP,'_','BR.jpg'); %para indicar silueta del fondo removido
nombreImagenROI=strcat(pathAplicacionROI,nombreImagenP,'_','RO.jpg'); %para indicar el fondo removido y ROI


%prefijo para imagenes de fondo removido y siluetas de fondos removidos en
%deteccion de objetos
nombreImagenSiluetaN=strcat(pathAplicacion2,nombreImagenP,'_','sN');
nombreImagenRemovida=strcat(pathAplicacion3,nombreImagenP,'_','rm');



%% -- BEGIN IMAGE PROCESSING ----------------------------------
%% ----- INICIO Definicion de topes

fprintf('BR -> Segmentación de fondo HSV--> \n'); %salida una imagen con 4 siluetas
BRemovalHSV(imagenInicial, nombreImagenBR, areaObjetosRemoverBR);

%% Removiendo fondo
fprintf('BR -> Removiendo fondo, separacion ROI--> \n'); %salida una imagen con 4 objetos
backgroundRemoval4(imagenInicial, nombreImagenBR, nombreImagenROI);

%% Recortes de ROI
fprintf('BR -> Detección de objetos. Recortando ROI y siluetas ROI --> \n'); %salida 4 imagenes de un objeto cada una
%asigna numeros de objetos segun la pertenencia al cuadro
objectDetection3( nombreImagenBR, nombreImagenROI, nombreImagenSiluetaN, nombreImagenRemovida); 

%archivoVectorDef=strcat(pathAplicacion,'MedidasSiluetas.csv')
%nombreImagenSiluetaN=strcat(nombreImagenSiluetaN,'1.jpg')
%measureROICandidates(pathAplicacion, 1, nombreImagenSiluetaN, archivoVectorDef, nombreImagenP);

%% -- END IMAGE PROCESSING ----------------------------------

end %end ProcesamientoImagen

