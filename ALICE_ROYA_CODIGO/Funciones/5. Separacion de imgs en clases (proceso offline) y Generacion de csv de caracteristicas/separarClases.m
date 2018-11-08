clc;
clear;
close all; 

home          = strcat(pwd,'/');
strDir        = strcat(home,'Escritorio/roya2018/');
rustFolder2   = strcat(strDir,'imgsrust/');
pathAplicacion                   = strcat(rustFolder2,'silueta/');    
pathBinClase1                    = strcat(pathAplicacion,'class1/'); %siluetas de clase1
pathBinClase2                    = strcat(pathAplicacion,'class2/'); %siluetas de clase2
pathBinClase3                    = strcat(pathAplicacion,'class3/'); %siluetas de clase2
pathEntradaImagenesClass1        = strcat(rustFolder2,'class1/'); 
pathEntradaImagenesClass2        = strcat(rustFolder2,'class2/');
pathEntradaImagenesClass3        = strcat(rustFolder2,'class3/');
pathResultados                   = strcat(rustFolder2,'output/');


% Si no existe carpeta, la crea
if exist(pathEntradaImagenesClass1, 'dir')
    fprintf('Carpeta [.../%s] existe \n',pathEntradaImagenesClass1);
    a=dir([pathEntradaImagenesClass1  '/*.png']);
    out=size(a,1);
    
    if out > 0
        fprintf('... y no está vacía\n');
        fprintf('Eliminando y Reescribiendo carpeta...\n');
        removeFiles(pathEntradaImagenesClass1);
        mkdir(pathEntradaImagenesClass1);
    else
        fprintf('... y está vacía\n');
        fprintf('\nINGRESE IMAGENES PARA CLASS 1 (ROYA)\n');
        pause(300) %se dan 5 min.
        
    end
else
    
    fprintf('Carpeta [.../%s] no existe \n',pathEntradaImagenesClass1);
    fprintf('Creando... \n');
    mkdir(pathEntradaImagenesClass1);
    fprintf('Carpeta creada exitosamente!\n');
    fprintf('\nINGRESE IMAGENES PARA CLASS 1 (ROYA)\n');
    pause(300) %se dan 5 min.
    
end

if exist(pathEntradaImagenesClass2, 'dir')
    fprintf('Carpeta [.../%s] existe \n',pathEntradaImagenesClass2);
    a=dir([pathEntradaImagenesClass2 '/*.png']);
    out=size(a,1);
    
    if out > 0
        fprintf('... y no está vacía\n');
        fprintf('Eliminando y Reescribiendo carpeta...\n');
        removeFiles(pathEntradaImagenesClass2);
        mkdir(pathEntradaImagenesClass2);
    else
        fprintf('... y está vacía\n');
        fprintf('\nINGRESE IMAGENES PARA CLASS 2 (NO ROYA)\n');
        pause(300) %se dan 5 min.
        
    end
else
    
    fprintf('Carpeta [.../%s] no existe \n',pathEntradaImagenesClass2);
    fprintf('Creando... \n');
    mkdir(pathEntradaImagenesClass2);
    fprintf('Carpeta creada exitosamente!\n');
    fprintf('\nINGRESE IMAGENES PARA CLASS 2 (NO ROYA)\n');
     pause(300) %se dan 5 min.

    
end

if exist(pathEntradaImagenesClass3, 'dir')
    fprintf('Carpeta [.../%s] existe \n',pathEntradaImagenesClass3);
    a=dir([pathEntradaImagenesClass3 '/*.png']);
    out=size(a,1);
    
    if out > 0
        fprintf('... y no está vacía\n');
        fprintf('Eliminando y Reescribiendo carpeta...\n');
        removeFiles(pathEntradaImagenesClass3);
        mkdir(pathEntradaImagenesClass3);
    else
        fprintf('... y está vacía\n');
        fprintf('\nINGRESE IMAGENES PARA CLASS 3 (HOJA)\n');
        pause(300) %se dan 5 min.
        
    end
else
    
    fprintf('Carpeta [.../%s] no existe \n',pathEntradaImagenesClass3);
    fprintf('Creando... \n');
    mkdir(pathEntradaImagenesClass3);
    fprintf('Carpeta creada exitosamente!\n');
    fprintf('\nINGRESE IMAGENES PARA CLASS 3 (HOJA)\n');
    pause(300) %se dan 5 min.
    
end

mkdir                            (pathBinClase1);
mkdir                            (pathBinClase2);
mkdir                            (pathBinClase3);
mkdir                            (pathResultados);
nombreImagenP='nombreImagenP';
postfijoBinClase1='_CL1.jpg';
postfijoBinClase2='_CL2.jpg';
postfijoBinClase3='_CL3.jpg';
archivoBDENFERMEDADES=strcat(pathResultados,'BDENFERMEDADES.csv');
%% _________________________________________________________________________
listado=dir(strcat(pathEntradaImagenesClass1,'*.png'));

for n=1:size(listado)
    fprintf('Extrayendo características para entrenamiento-> %s \n',listado(n).name);    
    nombreImagenP=listado(n).name;
    nombreImagenOriginal=nombreImagenP;
    
    nombreImagenColorClase1=strcat(pathEntradaImagenesClass1,nombreImagenOriginal);
    nombreImagenBinClase1=strcat(pathBinClase1,nombreImagenOriginal,postfijoBinClase1);
    
   etiqueta='ROYA';
   classDetectionExp( 1, nombreImagenColorClase1, nombreImagenBinClase1, archivoBDENFERMEDADES, nombreImagenOriginal, etiqueta);
    
end
% %% _________________________________________________________________________
listado=dir(strcat(pathEntradaImagenesClass2,'*.png'));
for n=1:size(listado)
    fprintf('Extrayendo características para entrenamiento-> %s \n',listado(n).name);    
    nombreImagenP=listado(n).name;
    nombreImagenOriginal=nombreImagenP;
    
    nombreImagenColorClase2=strcat(pathEntradaImagenesClass2,nombreImagenOriginal);
    nombreImagenBinClase2=strcat(pathBinClase2,nombreImagenOriginal,postfijoBinClase2);
    
    
    etiqueta='NO ROYA';
    classDetectionExp( 1, nombreImagenColorClase2, nombreImagenBinClase2, archivoBDENFERMEDADES, nombreImagenOriginal, etiqueta);
end
% 
% %% _________________________________________________________________________
listado=dir(strcat(pathEntradaImagenesClass3,'*.png'));
 for n=1:size(listado)
    fprintf('Extrayendo características para entrenamiento-> %s \n',listado(n).name);    
    nombreImagenP=listado(n).name;
    nombreImagenOriginal=nombreImagenP;
    
    nombreImagenColorClase3=strcat(pathEntradaImagenesClass3,nombreImagenOriginal);
    nombreImagenBinClase3=strcat(pathBinClase3,nombreImagenOriginal,postfijoBinClase3);
    
    
    etiqueta='HOJA';
    classDetectionExp( 1, nombreImagenColorClase3, nombreImagenBinClase3, archivoBDENFERMEDADES, nombreImagenOriginal, etiqueta);
 end  
 total=size(listado);


fprintf('\n -------------------------------- \n');
fprintf('Se procesaron un total de %i archivos \n',total(1));
fprintf('En el archivo %s se guardaron los DEFECTOS\n', archivoBDENFERMEDADES);
fprintf('\n -------------------------------- \n');

