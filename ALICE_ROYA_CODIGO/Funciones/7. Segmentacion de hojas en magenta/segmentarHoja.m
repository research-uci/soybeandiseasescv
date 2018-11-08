function [segFolder] = segmentarHoja(strDir,pathHaz)
% Remoción del fondo de la hoja
% 1 a 0

% Aqui se guardarán las imgs
% segmentadas
pathFolder   = 'imgs_segmentadas/';
segFolder    = strcat(strDir,pathFolder);

% Si no existe carpeta, la crea
    if ~exist(segFolder, 'dir')
        mkdir(segFolder);
    else
        fprintf("la carpeta de img_segmentadas ya ha sido creada\n");
    end
    
% define dir de imagenes
% y cuenta las mismas
renameJPG = dir(fullfile(pathHaz,'*.jpg'));
counter   = length(renameJPG);

    for ii = 1 : counter
        name = renameJPG(ii).name;
        filename = strcat(pathHaz,name);
        im = imread(filename);
        %% Aplicacion de filtro de la mediana [3x3]
        med = imfilter(im,fspecial('average'));
        imHSV = rgb2hsv(med);

        %% separar en canal Saturacion [S]
        S=imHSV(:,:,2);

        %% Aplicación de método global Otsu a nivel 0.4941%
        sotsu = graythresh(S);

        %% Binarizado con graythresh
        SW = imbinarize(S,sotsu);

        %% Multiplicación para la eliminación del fondo
        ima = im;

        ima(:,:,1) = immultiply(im(:,:,1),SW);
        ima(:,:,2) = immultiply(im(:,:,2),SW);
        ima(:,:,3) = immultiply(im(:,:,3),SW);

        % elimina el .jpg
        newStr = erase(name,".jpg");

%         % agrega el S00n
%          newName = strrep(newStr,'crop','R');

        % parametros: (imagen a guardar, [direccion de carpeta en
        % donde guarda, nombre de la imagen original, formato a guardar])
        imwrite(ima,[segFolder,newStr,'.png']);

    end



end

