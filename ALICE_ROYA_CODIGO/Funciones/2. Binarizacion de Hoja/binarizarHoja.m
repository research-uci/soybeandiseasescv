function [binFolder] = binarizarHoja(strDir,pathSeg)
% Binarización de las imágenes 
% para procesos consecutivos (binarizar = reducción de información 
% en la que los únicos valores posibles son verdadero y falso (1 y 0))


% Aqui se guardarán las imgs
% binarizadas       
fprintf('\n\n####     Binarización    ####\n\n');

pathBin   = 'imgs_bin/';
binFolder = strcat(strDir,pathBin);


% Si no existe carpeta, la crea
    if exist(binFolder, 'dir')
        fprintf('Carpeta [.../%s] existe \n',pathBin);
        a=dir([binFolder '/*.png']);
        out=size(a,1);
        
        if out > 0
            fprintf('... y no está vacía\n');
            fprintf('Cantidad de imgs en %s = %i\n',pathBin,out);
            if out == 193
                fprintf('La cant. de imagenes es correcta, pasando al siguiente módulo...\n');
                return
            else
                fprintf('Faltan imágenes a base de datos... Eliminando y Reescribiendo carpeta...\n');
                removeFiles(binFolder);
                mkdir(binFolder);
            end    
        else
            fprintf('... y está vacía\n');

        end
    else

        fprintf('Carpeta [.../%s] no existe \n',pathBin);
        fprintf('Creando... \n');
        mkdir(binFolder);
        fprintf('Carpeta creada exitosamente!\n');

    end
% define dir de imagenes
% y cuenta las mismas
segPNG = dir(fullfile(pathSeg,'*.png'));
counter   = length(segPNG);

    for ii = 1 : counter
        name = segPNG(ii).name;
        filename = strcat(pathSeg,name);
        im = imread(filename);
        fprintf('\nLeyendo -> %s de %s \n',name,pathSeg);
        %% se pasa imagen a escala de grises
        grayImage = rgb2gray(im);
        fprintf('Pasando imagen a escala de grises...\n');
        %% se binariza
        binImage = imbinarize(grayImage);
        fprintf('Binarizando imagen...\n');
        %% elimina el .png duplicado
        newStr = erase(name,".png");
        % parametros: (imagen a guardar, [direccion de carpeta en
        % donde guarda, nombre de la imagen original, formato a guardar])
        imwrite(binImage,[binFolder, newStr,'.png']);
        fprintf('Se guarda -> %s en %s', newStr,binFolder);

    end
        
        

end
