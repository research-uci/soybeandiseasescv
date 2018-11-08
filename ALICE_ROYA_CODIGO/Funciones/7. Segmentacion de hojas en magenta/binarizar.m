function [binFolder] = binarizar(strDir,pathSeg)
% Binarización de las imágenes 
% para procesos consecutivos (binarizar = reducción de información 
% en la que los únicos valores posibles son verdadero y falso (1 y 0))


% Aqui se guardarán las imgs
% binarizadas
pathBin   = 'imgs_binarizadas/';
binFolder = strcat(strDir,pathBin);


% Si no existe carpeta, la crea
    if ~exist(binFolder, 'dir')
        mkdir(binFolder);
    else
        fprintf("la carpeta de imgs_binarizadas ya ha sido creada\n");
    end
    
% define dir de imagenes
% y cuenta las mismas
segPNG = dir(fullfile(pathSeg,'*.png'));
counter   = length(segPNG);

    for ii = 1 : counter
        name = segPNG(ii).name;
        filename = strcat(pathSeg,name);
        im = imread(filename);


        %% se pasa imagen a escala de grises
        grayImage = rgb2gray(im);

        %% se binariza
        binImage = imbinarize(grayImage);

        %% elimina el .png duplicado
        newStr = erase(name,".png");


        % parametros: (imagen a guardar, [direccion de carpeta en
        % donde guarda, nombre de la imagen original, formato a guardar])
        imwrite(binImage,[binFolder,newStr,'.png']);

    end
        
        

end

