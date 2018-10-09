% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%% Creador de conjuntos de entrenamiento y pruebas
% Se encarga de crear un conjunto de entrenamiento y pruebas al azar.
% Crea un listado inicial de imágenes a partir de un directorio de muestras, las cuales
% cuentan con su correspondencia de marcacion por el experto. Es decir
% 001.jpg original tiene su contrapartida como 001.jpg marcada por el
% experto.


% * Leer el DIRECTORIO principal de imagenes.
% * Leer los valores de proporcion de los conjuntos.
% * Leer tabla del archivo conjunto principal.
% * Tomando el set principal, crear en forma aleatoria el conjunto para
% TEST y para TRAINING. Genera dos directorios con imágenes copiadas.



%% Ajuste de parámetros iniciales
clc; clear all; close all;

HOME=strcat(pwd,'/');
pathPrincipal=strcat(HOME,'SoyResults2/TrainingMet1/SetCreator/');
pathResultados=strcat(pathPrincipal,'output/');

nombreArchivoSetCompleto='setCompleto.csv';


%% Apertura del diario de pantallas
%diary(fileHandlerDiary)


%% Ingresar parametros, porcentaje utilizado para entrenamiento
proporcionTraining=70;

 %% Definicion de estructura de directorios 
pathEntradaImagenes=strcat(HOME,'SoyResults2/SOURCE/'); %source
pathEntradaImagenesMarcas=strcat(HOME,'SoyResults2/MARKED/'); % marked
pathEntradaImagenesTest=strcat(HOME,'SoyResults2/inputTest/');
pathEntradaImagenesTraining=strcat(HOME,'SoyResults2/inputTraining/');

%carga del listado de nombres
listado=dir(strcat(pathEntradaImagenes,'*.jpg'));
[tablaDSTraining, tablaDSTest]=splitSetImg( listado, proporcionTraining, pathPrincipal, pathResultados, nombreArchivoSetCompleto);

%tablaDSTraining
%% borrado de test y de training
% inputToLearn -> BD de datos inicial.
% inputMarked -> BD on correspondencia marcadas
% inputTest -> se borra y se crea con las imagenes
% inputTraining -> se borra y se crea con las imagenes
%% copiar de
archivosProbar=strcat(pathEntradaImagenesTest,'*');
removeFiles(archivosProbar);

archivosTraining=strcat(pathEntradaImagenesTraining,'*');
removeFiles(archivosTraining);

copyDirectory( tablaDSTest, pathEntradaImagenes, pathEntradaImagenesTest);
copyDirectory( tablaDSTraining, pathEntradaImagenesMarcas, pathEntradaImagenesTraining);
%% -------------------------------------------------------------------