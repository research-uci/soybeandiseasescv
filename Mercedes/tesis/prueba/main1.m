clc; clear all; close all;
addpath 'C:\Program Files\MATLAB\R2017a\funciones\natsortfiles'; %funcion para ordenar alfabeticamente

% path='D:\resultado\resultado_division\inputTraining\';  %SOURCE DE IMAGENES ORIGINALES
% path2='D:\resultado\resultado_division\inputTrainingMarked\'; %SOURCE DE IMAGENES MARCADAS POR EL EXPERTO

path='D:\SOURCE_PICTURES\source\';  %SOURCE DE IMAGENES ORIGINALES
path2='D:\SOURCE_PICTURES\marked\'; %SOURCE DE IMAGENES MARCADAS POR EL EXPERTO

pathPrincipal='D:/resultado/resultado12/';  

pathFolder= '1_S_rgb_crop/';                                                    
pathFolder2='2_S_bin_crop/';
pathFolder3='3_S_BR/';
pathmagentacrop='4_M_rgb_crop/';
pathmagentacropbin='5_M_bin_crop/';
pathmagentafondoremovido='6_M_BR/';
pathmagenta='7_M_Spot_seg/';
pathmagentabin='8_M_Spot_bin/';

pathresultadorgb= strcat(pathPrincipal,pathFolder);                %resultado
pathresultadobin=strcat(pathPrincipal,pathFolder2);
pathresultadofondoremovido=strcat(pathPrincipal,pathFolder3);       
pathresultadomagenta= strcat(pathPrincipal,pathmagenta);
pathresultadomagentabin=strcat(pathPrincipal,pathmagentabin);
pathresultadomagentacrop=strcat(pathPrincipal,pathmagentacrop);
pathresultadomagentacropbin=strcat(pathPrincipal,pathmagentacropbin);
pathresultadomagentafondoremovido=strcat(pathPrincipal,pathmagentafondoremovido);



% inicio condiciones para creacion de carpeta%
if ~exist(pathPrincipal, 'dir')                                    
        mkdir(pathPrincipal);
    else
        fprintf(' ya ha sido creada= %s \n',pathPrincipal);
end

if ~exist(pathresultadorgb, 'dir')                                   
        mkdir(pathresultadorgb);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadorgb);
end

if ~exist(pathresultadobin, 'dir')                                  
        mkdir(pathresultadobin);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadobin);
end

if ~exist(pathresultadofondoremovido, 'dir')                         
        mkdir(pathresultadofondoremovido);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadofondoremovido);
end

if ~exist(pathresultadomagenta, 'dir')                               
        mkdir(pathresultadomagenta);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadomagenta);
end

if ~exist(pathresultadomagentabin, 'dir')                            
        mkdir(pathresultadomagentabin);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadomagentabin);
end

if ~exist(pathresultadomagentacrop, 'dir')                          
        mkdir(pathresultadomagentacrop);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadomagentacrop);
end

% pathresultadomagentacropbin
if ~exist(pathresultadomagentacropbin, 'dir')                          
        mkdir(pathresultadomagentacropbin);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadomagentacropbin);
end

% pathresultadomagentafondoremovido
if ~exist(pathresultadomagentafondoremovido, 'dir')                          
        mkdir(pathresultadomagentafondoremovido);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadomagentafondoremovido);
end

formato='.jpg';         %formato de imagen
formato2='*.jpg';

files=dir([path formato2]);                     %lectura de directorio
[~,ndx] = natsortfiles({files.name});           %asigancion de indices
files = files(ndx);                            
% 
files4=dir([path2 formato2]);
[~,ndx4] = natsortfiles({files4.name}); 
files4 = files4(ndx4);
% 
% 
for k = 1:length(files)                         %este for va desde 1 hasta cuantas imagenes se encuentran en la carpeta.
    files(k).name;                              %se recorre files dependiendo de la posicion
    files4(k).name;
    imgname=files(k).name;                      %almacena nombre de la imagen
    magentaname=files4(k).name;
    imag=imread([path files(k).name]);          %lee imagen 
    imagmagenta=imread([path2 files4(k).name]); %lee imagen
    grises=rgb2gray(imag);                      %trasforma a escala de grises
    grisesm=rgb2gray(imagmagenta);
    level = graythresh(imag);                   %threshold
    levelm= graythresh(imagmagenta);
    BW1 = im2bw(imag,level);                    %binarizacion de imagen
    BWM = im2bw(imagmagenta,levelm);
%     figure, imshow(imag), figure, imshow(grises), figure, imshow(BW1);
    %impresion por pantalla de las imagenes originales y las imagenes procesadas
% proceso para extraer fondo
    BW = ~BW1;          
    BW = 1-BW1;
    BW = (BW1 == 0);
    BWM2= ~BWM;
    BWM2= 1-BWM;
    BWM2=(BWM == 0);
%     figure,imshow(BW);
% end proceso para extraer fondo
    B = medfilt2(BW);                           %filtro de la mediana
    BMAG= medfilt2(BWM2);
%     figure, imshow(B);
    imag_bw=bwareaopen(B,800);                  %apertura
    imag_bwmag=bwareaopen(BMAG,800);            %apertura
    
    [L Ne]=bwlabel(imag_bw);                    %label de que hay en una imagen                    
    [L2 Ne2]= bwlabel(imag_bwmag);
    propied=regionprops(L);                     %con regionpropos se pueden extraer caracteristicas de una imagen, como tamaño etc
    propied2=regionprops(L2);
    
    for j=1:size(propied,1)                     %se recorre un for de acuerdo a la medida de la hoja
        rectangle('Position',propied(j).BoundingBox,'EdgeColor','g','LineWidth',2);
        h= propied(j).BoundingBox;              %guarda en h los valores
    end
    r=imcrop(imag,h);                           %recorta una imagen de acuerdo a unas coordenadas obtenidas 
   
    q=imcrop(imag_bw,h);
%         figure,imshow(r);
%     figure,imshow(q);

    imwrite((r),[pathresultadorgb,imgname]);    %escribe los resultados en las carpeta
    imwrite((q),[pathresultadobin,imgname]);    %escribe los resultados en las carpeta

    for j2=1: size(propied2,1)                  %se recorre un for de acuerdo a la medida de la hoja
        h2= propied2(j2).BoundingBox;           %guarda las coordenadas en h2 
    end    
    rmagenta=imcrop(imagmagenta,h2);            %recorta la imagen de acuerdo a h2
    qmagenta=imcrop(imag_bwmag, h2);
    
    imwrite((rmagenta),[pathresultadomagentacrop,imgname]);
    imwrite((qmagenta),[pathresultadomagentacropbin,imgname]);

%     figure,imshow(rmagenta);
    [magbw,magrgb]=magenta2(rmagenta);
%     figure,imshow(magrgb);
%     figure,imshow(magbw);

    imwrite((magrgb),[pathresultadomagenta,imgname]); 
    imwrite((magbw), [pathresultadomagentabin,imgname]);
    
       
%     if (k==1)                
%         break;
%     end
end

files2=dir([pathresultadobin formato2]);
files3=dir([pathresultadorgb formato2]);

files4=dir([pathresultadomagentacropbin formato2]);
files5=dir([pathresultadomagentacrop formato2]);


[~,ndx2] = natsortfiles({files2.name});
[~,ndx3] = natsortfiles({files3.name});

[~,ndx4] = natsortfiles({files4.name});
[~,ndx5] = natsortfiles({files5.name});


files2 = files2(ndx2);
files3 = files3(ndx3);

files4 = files4(ndx4);
files5 = files5(ndx5);


% kk = 1:115
for kk = 1:length(files2)
    files2(kk).name;
    imgname2=files2(kk).name;
    im2=imread([pathresultadobin files2(kk).name]);
    im3=imread([pathresultadorgb files3(kk).name]);
    im4=imread([pathresultadomagentacropbin files4(kk).name]);
    im5=imread([pathresultadomagentacrop files5(kk).name]);
    
    [imagen_resul]=RemoveBackground(im3, im2); %funcion que remueve el fondo de las imagenes
    [imagen_resulmagenta]=RemoveBackground(im5, im4);
%     figure,imshow(imagen_resulmagenta);
    
    imwrite((imagen_resul),[pathresultadofondoremovido,imgname2]);   %escritura de resultado en carpeta
    imwrite((imagen_resulmagenta),[pathresultadomagentafondoremovido,imgname2]);
end

%extraccion de caracteristicas de la mancha
%manchas_analisis(pathresultadofondoremovido, pathresultadomagentabin, formato, formato2)
manchas_analisis_2(pathresultadofondoremovido, pathresultadomagentabin, formato, formato2)

sms = 'La ejecucion ha finalizado, revise los resultados en:';

fprintf('%s\n %s \n %s \n',sms, pathresultadorgb, pathresultadobin);


