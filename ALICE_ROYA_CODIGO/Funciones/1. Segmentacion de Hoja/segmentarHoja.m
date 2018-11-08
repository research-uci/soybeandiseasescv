function [segFolder] = segmentarHoja(strDir,pathHaz)
% Remoción del fondo de la hoja
% 1 a 0
%%
% Aqui se guardarán las imgs
% segmentadas
 fprintf('___________________________________________\n');      
fprintf('|     Preprocesamiento & Segmentación       |\n');
 fprintf('___________________________________________\n\n');

 
pathFolder   = 'imgs_segmentadas/';
segFolder    = strcat(strDir,pathFolder);

% Si no existe carpeta, la crea
    if exist(segFolder, 'dir')
        fprintf('Carpeta [.../%s] existe \n',pathFolder);
        a=dir([segFolder '/*.png']);
        out=size(a,1);
        
        if out > 0
            fprintf('... y no está vacía\n');
            fprintf('Cantidad de imgs en %s = %i\n',pathFolder,out);
            if out == 193
                fprintf('La cant. de imagenes es correcta, pasando al siguiente módulo...\n');
                return
            else
                fprintf('Faltan imágenes a base de datos... Eliminando y Reescribiendo carpeta...\n');
                removeFiles(segFolder);
                mkdir(segFolder);
            end    
        else
            fprintf('... y está vacía\n');

        end
    else

        fprintf('Carpeta [.../%s] no existe \n',pathFolder);
        fprintf('Creando... \n');
        mkdir(segFolder);
        fprintf('Carpeta creada exitosamente!\n');

    end
%%   
% define dir de imagenes
% y cuenta las mismas
renameJPG = dir(fullfile(pathHaz,'*.jpg'));
counter   = length(renameJPG);

    for ii = 1 : counter
        name = renameJPG(ii).name;
        filename = strcat(pathHaz,name);
        im = imread(filename);
        fprintf('\nLeyendo -> %s de %s \n',name,pathHaz); 
        %% Aplicacion de filtro de la mediana [3x3]
        med = imfilter(im,fspecial('average'));
        imHSV = rgb2hsv(med);
        fprintf('Aplicando filtro de la mediana y pasando a HSV... \n'); 
        %% separar en canal Saturacion [S]
        S=imHSV(:,:,2);
        fprintf('Separando a el canal S... \n'); 
        %% Aplicación de método global Otsu a nivel 0.4941%
        sotsu = graythresh(S);
        fprintf('Aplicando graythresh a S... \n'); 
        %% Binarizado con graythresh
        SW = imbinarize(S,sotsu);
        fprintf('Realizando binarización con S y graythresh... \n'); 
        %% Multiplicación para la eliminación del fondo
        ima = im;

        ima(:,:,1) = immultiply(im(:,:,1),SW);
        ima(:,:,2) = immultiply(im(:,:,2),SW);
        ima(:,:,3) = immultiply(im(:,:,3),SW);
        fprintf('Realizando multiplicación por canales... \n');
        % elimina el .jpg
        newStr = erase(name,".jpg");
        % parametros: (imagen a guardar, [direccion de carpeta en
        % donde guarda, nombre de la imagen original, formato a guardar])
        imwrite(ima,[segFolder,newStr,'.png']);
        fprintf('Se guarda -> %s en %s',newStr,segFolder);

    end
%%

end
