clc; clear all; close all;
addpath 'C:\Program Files\MATLAB\R2017a\funciones\natsortfiles'; %funcion para ordenar alfabeticamente


path2='D:\SOURCE_PICTURES\marked\'; %SOURCE DE IMAGENES MARCADAS POR EL EXPERTO

pathPrincipal='D:/resultado/r_param/';  

pathmagentacrop='1_M_rgb_crop/';
pathmagentacropbin='2_M_bin_crop/';
pathmagentafondoremovido='3_M_BR/';
pathmagenta='4_M_Spot_seg/';
pathmagentabin='5_M_Spot_bin/';

  
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

if ~exist(pathresultadomagenta, 'dir')                               
        mkdir(pathresultadomagenta);
else
        fprintf(' ya ha sido creada= %s \n',pathresultadomagenta);
        filePattern = fullfile(pathresultadomagenta, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathresultadomagenta);
        end
end

if ~exist(pathresultadomagentabin, 'dir')                            
        mkdir(pathresultadomagentabin);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadomagentabin);
        filePattern = fullfile(pathresultadomagentabin, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathresultadomagentabin);
        end
end

if ~exist(pathresultadomagentacrop, 'dir')                          
        mkdir(pathresultadomagentacrop);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadomagentacrop);
        filePattern = fullfile(pathresultadomagentacrop, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathresultadomagentacrop);
        end
end

% pathresultadomagentacropbin
if ~exist(pathresultadomagentacropbin, 'dir')                          
        mkdir(pathresultadomagentacropbin);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadomagentacropbin);
        filePattern = fullfile(pathresultadomagentacropbin, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathresultadomagentacropbin);
        end
end

% pathresultadomagentafondoremovido
if ~exist(pathresultadomagentafondoremovido, 'dir')                          
        mkdir(pathresultadomagentafondoremovido);
    else
        fprintf(' ya ha sido creada= %s \n',pathresultadomagentafondoremovido);
        filePattern = fullfile(pathresultadomagentafondoremovido, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,pathresultadomagentafondoremovido);
        end
end

formato='.jpg';         %formato de imagen
formato2='*.jpg';

files4=dir([path2 formato2]);
[~,ndx4] = natsortfiles({files4.name}); 
files4 = files4(ndx4);


for k = 1:length(files4)                         %este for va desde 1 hasta cuantas imagenes se encuentran en la carpeta.
                              
    files4(k).name;
    
    magentaname=files4(k).name;
   
    imagmagenta=imread([path2 files4(k).name]); %lee imagen
                  
    grisesm=rgb2gray(imagmagenta);
    
    levelm= graythresh(imagmagenta);
    BWM = im2bw(imagmagenta,levelm);                    %binarizacion de imagen
    
%    figure, imshow(BW1);
    %impresion por pantalla de las imagenes originales y las imagenes procesadas
% proceso para extraer fondo
    
    BWM2= ~BWM;
    BWM2= 1-BWM;
    BWM2=(BWM == 0);
%     figure,imshow(BW);
% end proceso para extraer fondo
                   
    BMAG= medfilt2(BWM2);
%     figure, imshow(B);

    imag_bwmag=bwareaopen(BMAG,800);            %apertura
    
      
    [L2 Ne2]= bwlabel(imag_bwmag);

    propied2=regionprops(L2);

    for j2=1: size(propied2,1)                  %se recorre un for de acuerdo a la medida de la hoja
        h2= propied2(j2).BoundingBox;           %guarda las coordenadas en h2 
    end    
    rmagenta=imcrop(imagmagenta,h2);            %recorta la imagen de acuerdo a h2
    qmagenta=imcrop(imag_bwmag, h2);
    
    imwrite((rmagenta),[pathresultadomagentacrop,magentaname]);
    imwrite((qmagenta),[pathresultadomagentacropbin,magentaname]);

%   figure,imshow(rmagenta);
    [magbw,magrgb]=magenta2(rmagenta);
%     figure,imshow(magrgb);
%     figure,imshow(magbw);

    imwrite((magrgb),[pathresultadomagenta,magentaname]); 
    imwrite((magbw), [pathresultadomagentabin,magentaname]);
    
       
%     if (k==1)                
%         break;
%     end
end



files4=dir([pathresultadomagentacropbin formato2]);
files5=dir([pathresultadomagentacrop formato2]);




[~,ndx4] = natsortfiles({files4.name});
[~,ndx5] = natsortfiles({files5.name});



files4 = files4(ndx4);
files5 = files5(ndx5);


% kk = 1:115
for kk = 1:length(files4)
    files4(kk).name;
    imgname2=files4(kk).name;
    im4=imread([pathresultadomagentacropbin files4(kk).name]);
    im5=imread([pathresultadomagentacrop files5(kk).name]);
    
    [imagen_resulmagenta]=RemoveBackground(im5, im4);
%     figure,imshow(imagen_resulmagenta);
    
    imwrite((imagen_resulmagenta),[pathresultadomagentafondoremovido,imgname2]);
end
pathresultadofondoremovido='D:\resultado\r_param\resultadofondoremovido\';   


manchas_analisis_2(pathresultadofondoremovido, pathresultadomagentabin, formato, formato2)

sms = 'La ejecucion ha finalizado, revise los resultados en:';

% fprintf('%s\n %s \n %s \n',sms, pathresultadorgb, pathresultadobin);


