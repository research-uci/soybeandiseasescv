% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% IMPLEMENTA MEJORAS EN LA EXTRACCION DE LS DEFECTOS, DADO QE TOMA LAS
% IMAGENES ORIGINALES EN RGB Y SEGMENTA LOS VALORES MARCADOS POR EL EXPERTO
%
% Genera imagenes de regiones previamente marcadas por un experto en forma
% MANUAL con un editor de imágenes.
% Es un proceso previo a la extraccion automatizada de características.
% Se asume que un experto marcó las frutas a mano con colores.
% Como salida se producen imágenes. Utiliza en paralelo imagenes
% originales e imágenes marcadas.
% Genera el paso previo a la creacion del archivo de ENTRENAMIENTO PARA EL
% CLASIFICADOR DE DEFECTOS.

%% Ajuste de parámetros iniciales
clc; clear all; close all;
 
 %% Definicion de estructura de directorios 
HOME=strcat(pwd,'/');
pathPrincipal=strcat(HOME,'OrangeResults/byDefects/PSMet2/CompareROI/');
pathEntradaImagenesMarcas=strcat(HOME,'OrangeResults/inputMarked/');
pathEntradaImagenes=strcat(HOME,'OrangeResults/inputToLearn/');
pathEntradaMarca=strcat(HOME,'OrangeResults/inputMarked/'); %directorio de las muestras marcadas
pathConfiguracion=strcat(pathPrincipal,'conf/');
pathAplicacion=strcat(pathPrincipal,'tmpToLearn/MARKED/'); %se utiliza para situar las imagenes de calibracion
pathAplicacionSiluetas=strcat(pathAplicacion,'sFrutas/');
pathResultados=strcat(pathPrincipal,'output/');%se guardan los resultados

nombreImagenP='nombreImagenP';

 %% Nombres de archivos de configuracion
 % trabajan con métodos para equivalencia con las 4 vistas
archivoConfiguracion=strcat(pathConfiguracion,'20170916configuracion.xml'); %Para coordenadas iniciales en tratamiento de imagenes
archivoCalibracion=strcat(pathConfiguracion,'20170916calibracion.xml'); %para indicar al usuario en la parte final la calibracion
  
 %% Definicion de los cuadros, según numeración 
Fila1=readConfiguration('Fila1', archivoConfiguracion);
FilaAbajo=readConfiguration('FilaAbajo', archivoConfiguracion);

%Cuadro 1 abajo
Cuadro1_lineaGuiaInicialFila=readConfiguration('Cuadro1_lineaGuiaInicialFila', archivoConfiguracion);
Cuadro1_lineaGuiaInicialColumna=readConfiguration('Cuadro1_lineaGuiaInicialColumna', archivoConfiguracion);
Cuadro1_espacioFila=readConfiguration('Cuadro1_espacioFila', archivoConfiguracion);
Cuadro1_espacioColumna=readConfiguration('Cuadro1_espacioColumna', archivoConfiguracion);

%Cuadro 2 izquierda
Cuadro2_lineaGuiaInicialFila=readConfiguration('Cuadro2_lineaGuiaInicialFila', archivoConfiguracion);
Cuadro2_lineaGuiaInicialColumna=readConfiguration('Cuadro2_lineaGuiaInicialColumna', archivoConfiguracion);
Cuadro2_espacioFila=readConfiguration('Cuadro2_espacioFila', archivoConfiguracion);
Cuadro2_espacioColumna=readConfiguration('Cuadro2_espacioColumna', archivoConfiguracion);

%Cuadro 3 centro
Cuadro3_lineaGuiaInicialFila=readConfiguration('Cuadro3_lineaGuiaInicialFila', archivoConfiguracion);
Cuadro3_lineaGuiaInicialColumna=readConfiguration('Cuadro3_lineaGuiaInicialColumna', archivoConfiguracion);
Cuadro3_espacioFila=readConfiguration('Cuadro3_espacioFila', archivoConfiguracion);
Cuadro3_espacioColumna=readConfiguration('Cuadro3_espacioColumna', archivoConfiguracion);

%Cuadro 4 derecha
Cuadro4_lineaGuiaInicialFila=readConfiguration('Cuadro4_lineaGuiaInicialFila', archivoConfiguracion);
Cuadro4_lineaGuiaInicialColumna=readConfiguration('Cuadro4_lineaGuiaInicialColumna', archivoConfiguracion);
Cuadro4_espacioFila=readConfiguration('Cuadro4_espacioFila', archivoConfiguracion);
Cuadro4_espacioColumna=readConfiguration('Cuadro4_espacioColumna', archivoConfiguracion);

%%carga en memoria para que sea mas rapido
ArrayCuadros=[Cuadro1_lineaGuiaInicialColumna, Cuadro1_lineaGuiaInicialFila, Cuadro1_espacioColumna, Cuadro1_espacioFila;
Cuadro2_lineaGuiaInicialColumna, Cuadro2_lineaGuiaInicialFila, Cuadro2_espacioColumna, Cuadro2_espacioFila;
Cuadro3_lineaGuiaInicialColumna, Cuadro3_lineaGuiaInicialFila, Cuadro3_espacioColumna, Cuadro3_espacioFila;
Cuadro4_lineaGuiaInicialColumna, Cuadro4_lineaGuiaInicialFila, Cuadro4_espacioColumna, Cuadro4_espacioFila;
0,0,0,0
];

%% CONFIGURACIONES DE PROCESAMIENTO DE IMAGENES
areaObjetosRemoverBR=5000; % para siluetas y detección de objetos. Tamaño para realizar granulometria
% configuracion de umbrales
canalLMin = 0.0; canalLMax = 96.653; canalAMin = -23.548; canalAMax = 16.303; canalBMin = -28.235; canalBMax = -1.169; %parametros de umbralizacion de fondo
% ----- FIN Definicion de topes

%% Remover archivos antiguos, borrar archivos antiguos
fprintf('LIMPIANDO IMAGENES ANTIGUAS \n');
removeFiles(strcat(pathAplicacion,'sFrutas/','*.jpg'));
removeFiles(strcat(pathAplicacion,'ROIDefC/','*.jpg'));
removeFiles(strcat(pathAplicacion,'ROIDefBin/','*.jpg'));
removeFiles(strcat(pathAplicacion,'ROICalyxC/','*.jpg'));
removeFiles(strcat(pathAplicacion,'ROICalyxBin/','*.jpg'));
removeFiles(strcat(pathAplicacion,'MROI/','*.jpg'));
removeFiles(strcat(pathAplicacion,'MRM/','*.jpg'));
removeFiles(strcat(pathAplicacion,'MDefColor/','*.jpg'));
removeFiles(strcat(pathAplicacion,'MDefBin/','*.jpg'));
removeFiles(strcat(pathAplicacion,'MCalyxColor/','*.jpg'));
removeFiles(strcat(pathAplicacion,'MCalyxBin/','*.jpg'));
removeFiles(strcat(pathAplicacion,'ISFrutas/','*.jpg'));
removeFiles(strcat(pathAplicacion,'IROI/','*.jpg'));
removeFiles(strcat(pathAplicacion,'IRM/','*.jpg'));
removeFiles(strcat(pathAplicacion,'IBR/','*.jpg'));
removeFiles(strcat(pathAplicacion,'cDefectos/','*.jpg'));
removeFiles(strcat(pathAplicacion,'cCalyx/','*.jpg'));

%% --------------------------------------------------------------------
listado=dir(strcat(pathEntradaMarca,'*.jpg')); %recorre el listado de las imagenes marcadas
%% lectura en forma de bach del directorio de la cámara
for n=1:size(listado)
    fprintf('SEPARANDO REGIONES MARCADAS MANUALMENTE POR EL EXPERTO-> %s \n',listado(n).name);    
    nombreImagenP=listado(n).name;    
    %Se utiliza para separar las marcas hechas por expertos, los cuales
    %segmentaron con color azul los defectos en las frutas. Paralelamente
    %se tienen las imagenes originales, para poder obtener características
    %reales de los defectos en las frutas.
    ProcessMarks(pathEntradaImagenes, pathEntradaMarca, pathAplicacion, nombreImagenP, ArrayCuadros, areaObjetosRemoverBR, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax )    
    %GENERA imagenes marcadas
    ExtractMarkedRegions(pathEntradaImagenes, pathAplicacion, nombreImagenP)
    %if n==1
    %    break;
    %end;
end %

fprintf('SE HAN SEPARADO LAS REGIONES MARCADAS POR EL EXPERTO \n');
fprintf('Debe correr el proceso para extraer las características \n');
