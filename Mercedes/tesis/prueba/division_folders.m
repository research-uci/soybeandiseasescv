clc; clear all; close all;
%declaracion de carpetas
HOME='D:\resultado\';
Resultado='resultado_division\';
pathresultado=strcat(HOME, Resultado);

Dest=strcat(pathresultado,'inputTest\');
pathEntradaImagenesTraining=strcat(pathresultado,'inputTraining\');

Dest1=strcat(pathresultado,'inputTestMarked\');
pathEntradaImagenesTraining1=strcat(pathresultado,'inputTrainingMarked\');

if ~exist(pathresultado, 'dir')
        mkdir(pathresultado);
        fprintf('%s \n',pathresultado,'Creando directorio.');
else
        fprintf('%s \n',pathresultado,'ya ha sido creada.');
end

if ~exist(Dest, 'dir')
        mkdir(Dest);
        fprintf('%s \n',Dest,'Creando directorio.');
else
        fprintf('%s \n',Dest,'ya ha sido creada.');
end
if ~exist(pathEntradaImagenesTraining, 'dir')
        mkdir(pathEntradaImagenesTraining);
        fprintf('%s \n',pathEntradaImagenesTraining,'Creando directorio.');
    else
        fprintf('%s \n',pathEntradaImagenesTraining,'ya ha sido creada.');
end

if ~exist(Dest1, 'dir')
        mkdir(Dest1);
        fprintf('%s \n',Dest1,'Creando directorio.');
else
        fprintf('%s \n',Dest1,'ya ha sido creada.');
end

if ~exist(pathEntradaImagenesTraining1, 'dir')
        mkdir(pathEntradaImagenesTraining1);
        fprintf('%s \n',pathEntradaImagenesTraining1,'Creando directorio.');
    else
        fprintf('%s \n',pathEntradaImagenesTraining1,'ya ha sido creada.');
end

%fin de declaracion de carpetas
%definicion de source
Folder=('D:\SOURCE_PICTURES\source\'); %imagenes originales
pathEntradaImagenesMarcas=('D:\SOURCE_PICTURES\marked\'); %imagenes marcadas por el experto
%fin definicion de source

FileList = dir(fullfile(Folder, '*.jpg')); %leer todos los archivos de la carpeta source de imagenes
le=length(FileList); %calcular la dimension de FileList
tf=randperm(le) > floor(0.70*le); %crear un vector con valores 0 y 1 al azar, con un 70 % de falses y un 30% de trues, y lo hace redondeado con el floor
c=0; s=0; %contadores para chequeo
for k = 1:le %bucle con la distancia de la carpeta source
    if (tf(k)==true) %pregunto si el valor que esta en esa posicion del vector es false, entonces guardo en input test
        c=c+1;
        Source = fullfile(Folder, FileList(k).name);
        copyfile(Source, Dest); 
        Source2 = fullfile(pathEntradaImagenesMarcas, FileList(k).name);
        copyfile(Source2, Dest1); 
    else % osino va a la carpeta input Training
        s=s+1;
       Source = fullfile(Folder, FileList(k).name); 
       copyfile(Source, pathEntradaImagenesTraining);
       Source2 = fullfile(pathEntradaImagenesMarcas, FileList(k).name); 
       copyfile(Source2, pathEntradaImagenesTraining1);
      
     end
    cc=s+c; %suma los valores para saber si es la cantidad correcta
end
fprintf('Test= %i  \n',c); %valor de c en consola
fprintf('Training= %i  \n',s); %valor de s en consola
fprintf('Total Pictures= %i  \n',cc);  %valor de s en consola