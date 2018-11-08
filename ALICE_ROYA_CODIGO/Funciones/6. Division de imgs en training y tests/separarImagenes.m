%% Ajuste de parámetros iniciales
clc; clear all; close all;
HOME=strcat(pwd,'/');
pathPrincipal=strcat(HOME,'Escritorio/roya2018/DivisionImagenes/');
mkdir(pathPrincipal);
pathResultados=strcat(pathPrincipal,'output/');
mkdir(pathResultados);
nombreArchivoSetCompleto='setCompleto.csv';
%% Ingresar parametros, porcentaje utilizado para entrenamiento
proporcionTraining=70;
 %% Definicion de estructura de directorios 
%pathEntradaImagenes=strcat(HOME,'Escritorio/SOURCE/'); %source
%pathEntradaImagenesMarcas=strcat(HOME,'Escritorio/MARKED/'); % marked
pathEntradaImagenes=strcat(HOME,'Escritorio/clasificading/imgsprueba/'); %source de imgs para clasificador
pathEntradaImagenesMarcas=strcat(HOME,'Escritorio/clasificading/pruebasMARKED/'); %source de imgs para clasificador marcadas
pathEntradaImagenesTest=strcat(HOME,'Escritorio/roya2018/DivisionImagenes/inputTest/');
pathEntradaImagenesTraining=strcat(HOME,'Escritorio/roya2018/DivisionImagenes/inputTraining/');
mkdir(pathEntradaImagenesTest);
mkdir(pathEntradaImagenesTraining);
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
