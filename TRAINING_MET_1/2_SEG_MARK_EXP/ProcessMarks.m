function [ ] = ProcesesMarks(pathEntrada, pathEntradaMarca, pathAplicacion, nombreImagenP, areaObjetosRemoverBR, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax )
% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%Por cada fotografia, se separa el fondo, segmentando las cuatro imagenes
% Se elimina el fondo utilizando canales en el espacio LAB.
% SE GENERAN IMAGENES INTERMEDIAS:
% * SILUETAS CORRESPONDIENTE AL FONDO REMOVIDO
% características geométricas.
% SE generan imagenes con las marcas pintadas por el experto y se preparan
% recortes de la enfermedad.

% -----------------------------------------------------------------------

%% Datos de configuración archivos
imagenInicial=strcat(pathEntrada,nombreImagenP); % imagen original para obtener los valores de colores
imagenMarca=strcat(pathEntradaMarca,nombreImagenP); % imagen con marcas hechas por el experto

%% DIRECTORIOS DE GUARDADO
pathAplicacionBR=strcat(pathAplicacion,'IBR/'); %imagen inicial, background removal siluetas en 1 imagen
pathAplicacionROI=strcat(pathAplicacion,'IROI/'); %imagen inicial, regiones de interes a color con fondo removido de 1 imagen.
pathAplicacionROIMarca=strcat(pathAplicacion,'MROI/'); %imagen marcada, regiones de interes a color 1 imagen
pathAplicacion2=strcat(pathAplicacion,'ISLeaves/'); %siluetas de hojas
pathAplicacion3=strcat(pathAplicacion,'IRM/'); %imagenes fondo removido siluetas de hojas



%% CONFIGURACIONES DEFECTOS MASCARA Y COLOR
pathAplicacionCALROI=strcat(pathAplicacion,'ROISpotC/'); % 1 imagen con 4 marcas en magenta
pathAplicacionCALROIBin=strcat(pathAplicacion,'ROISpotBin/'); % 1 imagen con 4 marcas en binario

pathCalyxColor=strcat(pathAplicacion,'MSpotColor/'); %almacenado de calyx en color
pathCalyxBinario=strcat(pathAplicacion,'MSpotBin/'); %almacenado de calyx en binario


% --- NOMBRE DE IMAGENES INTERMEDIAS ---
% con fondo removido
nombreImagenBR=strcat(pathAplicacionBR,nombreImagenP,'_','BR.jpg'); %para indicar silueta del fondo removido
nombreImagenROI=strcat(pathAplicacionROI,nombreImagenP,'_','RO.jpg'); %para indicar el fondo removido y ROI
nombreImagenROIMarca=strcat(pathAplicacionROIMarca,nombreImagenP,'_','MRO.jpg'); %para indicar el fondo removido y ROI

nombreImagenF=strcat(pathAplicacionROI,nombreImagenP,'_','I.jpg'); %previa a la inversa

%prefijo para imagenes de fondo removido y siluetas de fondos removidos en
%deteccion de objetos
nombreImagenSiluetaN=strcat(pathAplicacion2,nombreImagenP,'_','sN');
nombreImagenRemovida=strcat(pathAplicacion3,nombreImagenP,'_','rm');

nombreImagenCALROI=strcat(pathAplicacionCALROI,nombreImagenP,'_','DR.jpg'); %para indicar CALIZ en magenta
nombreImagenCALROIBin=strcat(pathAplicacionCALROIBin,nombreImagenP,'_','DRB.jpg'); %para indicar CALIZ en magenta

nombreImagenCalColor=strcat(pathCalyxColor,nombreImagenP,'_','DC.jpg'); % imagen numerada de cada ROI de la enfermedad 
nombreImagenCalBin=strcat(pathCalyxBinario,nombreImagenP,'_','CALB'); % imagen numerada de cada ROI de la enfermedad 





%% -- BEGIN IMAGE PROCESSING ----------------------------------
%% ----- INICIO Definicion de topes
fprintf('BR -> Segmentación de fondo --> \n'); %salida una imagen con 1 siluetas
BRemovalLAB(imagenInicial, nombreImagenBR, nombreImagenF, areaObjetosRemoverBR, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax);


%% Removiendo fondo
fprintf('BR -> Removiendo fondo, separacion ROI--> \n'); %salida una imagen con 1 objetos
backgroundRemoval4(imagenInicial, nombreImagenBR, nombreImagenROI);
backgroundRemoval4(imagenMarca, nombreImagenBR, nombreImagenROIMarca);


%% Calyx segmentado
fprintf('DR -> SEGMENTANDO ENFERMEDAD MARCADA POR EXPERTO, separacion ROI--> \n'); %salida una imagen con 1 objeto
channel1Min = 216.000;
channel1Max = 255.000;
channel2Min = 0.000;
channel2Max = 132.000;
channel3Min = 201.000;
channel3Max = 255.000;
SegmentDefMarksRGB(imagenMarca, nombreImagenCALROI, nombreImagenCALROIBin, channel1Min, channel1Max, channel2Min, channel2Max, channel3Min, channel3Max);

%% Recortes de ROI
fprintf('BR -> Detección de HOJA. Recortando ROI y siluetas ROI --> \n'); %salida 1 imagen con hoja recortada
%asigna numeros de objetos segun la pertenencia al cuadro
objectDetection2( nombreImagenBR, nombreImagenROI, nombreImagenSiluetaN, nombreImagenRemovida); 


%recorta en base a la enfermedad
objectDetectionCut( nombreImagenBR, nombreImagenCALROI, nombreImagenCalColor);
objectDetectionCut( nombreImagenBR, nombreImagenCALROIBin, nombreImagenCalBin);
%% -- END IMAGE PROCESSING ----------------------------------

end %end ProcesamientoImagen

