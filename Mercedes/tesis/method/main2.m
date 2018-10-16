clc; clear all; close all;
%METODO PROPUESTO EN EL TRABAJO
addpath 'C:\Program Files\MATLAB\R2017a\funciones\natsortfiles'; %funcion para ordenar alfabeticamente

path='D:\SOURCE_PICTURES\source\';  %SOURCE DE IMAGENES ORIGINALES
pathPrincipal='D:/resultado/r_param/';  
pathFolder= '1_S_rgb_crop/';                                                    
pathFolder2='2_S_bin_crop/';
pathFolder3='3_S_BR/';
pathresultadorgb= strcat(pathPrincipal,pathFolder);                %resultado
pathresultadobin=strcat(pathPrincipal,pathFolder2);
pathresultadofondoremovido=strcat(pathPrincipal,pathFolder3);       

% inicio condiciones para creacion de carpeta%
if ~exist(pathPrincipal, 'dir')                                    
        mkdir(pathPrincipal);
    else
        fprintf(' Ya ha sido creada= %s \n',pathPrincipal); 
end

if ~exist(pathresultadorgb, 'dir')                                   
        mkdir(pathresultadorgb);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadorgb);
        filePattern = fullfile(pathresultadorgb, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathresultadorgb);
        end
end

if ~exist(pathresultadobin, 'dir')                                  
        mkdir(pathresultadobin);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadobin);
        filePattern = fullfile(pathresultadobin, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathresultadobin);
        end
end

if ~exist(pathresultadofondoremovido, 'dir')                         
        mkdir(pathresultadofondoremovido);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadofondoremovido);
        filePattern = fullfile(pathresultadofondoremovido, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathresultadofondoremovido);
        end
end

formato='.jpg';         %formato de imagen
formato2='*.jpg';

files=dir([path formato2]);                     %lectura de directorio
[~,ndx] = natsortfiles({files.name});           %asigancion de indices 
files = files(ndx);                             %ordenacion de indices en orden alfabético  %esto se repite tantas veces como el se toman archivos de carpetas, dentro del código aparecen varias veces.

for k = 1:length(files)                         %este for va desde 1 hasta cuantas imagenes se encuentran en la carpeta.
    files(k).name;                              %se recorre files dependiendo de la posicion
    imgname=files(k).name;                      %almacena nombre de la imagen
    imag=imread([path files(k).name]);          %lee imagen 
    grises=rgb2gray(imag);                      %trasforma a escala de grises
    level = graythresh(imag);                   %threshold
    BW1 = im2bw(imag,level);                    %binarizacion de imagen
%     BWM = im2bw(imagmagenta,levelm);
%     figure, imshow(imag);
    %impresion por pantalla de las imagenes originales y las imagenes procesadas
% proceso para extraer fondo
    BW = ~BW1;          
    BW = 1-BW1;
    BW = (BW1 == 0);
% end proceso para extraer fondo
    B = medfilt2(BW);                           %filtro de la mediana
%     figure, imshow(B);
    imag_bw=bwareaopen(B,800);                  %apertura    
    [L Ne]=bwlabel(imag_bw);                    %label de que hay en una imagen                    
    propied=regionprops(L);                     %con regionpropos se pueden extraer caracteristicas de una imagen, como tamaño etc
    
    for j=1:size(propied,1)                     %se recorre un for de acuerdo a la medida de la hoja
%         rectangle('Position',propied(j).BoundingBox,'EdgeColor','g','LineWidth',2);
        h= propied(j).BoundingBox;              %guarda en h los valores
    end
    r=imcrop(imag,h);                           %recorta una imagen de acuerdo a unas coordenadas obtenidas 
   
    q=imcrop(imag_bw,h);
%     figure,imshow(r);
%     figure,imshow(q);

    imwrite((r),[pathresultadorgb,imgname]);    %escribe los resultados en las carpeta
    imwrite((q),[pathresultadobin,imgname]);    %escribe los resultados en las carpeta
      
%     if (k==1)                
%         break;
%     end
end

files2=dir([pathresultadobin formato2]);
files3=dir([pathresultadorgb formato2]);

[~,ndx2] = natsortfiles({files2.name});
[~,ndx3] = natsortfiles({files3.name});

files2 = files2(ndx2);
files3 = files3(ndx3);

% kk = 1:115
for kk = 1:length(files2)
    files2(kk).name;
    imgname2=files2(kk).name;
    im2=imread([pathresultadobin files2(kk).name]);
    im3=imread([pathresultadorgb files3(kk).name]);
   
    [imagen_resul]=RemoveBackground(im3, im2); %funcion que remueve el fondo de las imagenes
   
    imwrite((imagen_resul),[pathresultadofondoremovido,imgname2]);   %escritura de resultado en carpeta
%     imwrite((imagen_resulmagenta),[pathresultadomagentafondoremovido,imgname2]);
end

%funcion de segmentacion de manchas con el metodo propuesto
spotsegmentacion(pathPrincipal, pathresultadofondoremovido,pathresultadobin,formato2,formato);

sms = 'La ejecucion ha finalizado, revise los resultados en:';

fprintf('%s\n %s \n %s \n',sms, pathresultadorgb, pathresultadobin);


