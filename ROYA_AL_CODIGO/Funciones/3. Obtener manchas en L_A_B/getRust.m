function [rustFolder] = getRust(strDir,pathCrop);
% Toma la hoja previamente recortada, lo transforma al espacio LAB
% de manera a realizar una máscara para quitar el área de interes (ROI)
% de la mancha de la enfermedad
%%
 fprintf('___________________________________________\n');      
fprintf('|    Extracción de Manchas ~ [Espacio LAB] ~|\n');
 fprintf('___________________________________________\n\n');
 
pathRust   = 'imgsrust/mLAB/';
rustFolder = strcat(strDir,pathRust);

% Si no existe carpeta, la crea
    if exist(rustFolder, 'dir')
        fprintf('Carpeta [.../%s] existe \n',pathRust);
        a=dir([rustFolder '/*.png']);
        out=size(a,1);
        
        if out > 0
            fprintf('... y no está vacía\n');
            fprintf('Cantidad de imgs en %s = %i\n',pathRust,out);
            if out == 193
                fprintf('La cant. de imagenes es correcta, pasando al siguiente módulo...\n');
                return
            else
                fprintf('Faltan imágenes a base de datos... Eliminando y Reescribiendo carpeta...\n');
                removeFiles(rustFolder);
                mkdir(rustFolder);
            end    
        else
            fprintf('... y está vacía\n');

        end
    else

        fprintf('Carpeta [.../%s] no existe \n',pathRust);
        fprintf('Creando... \n');
        mkdir(rustFolder);
        fprintf('Carpeta creada exitosamente!\n');

    end
% define dir de imagenes
% y cuenta las mismas
images  = dir(fullfile(pathCrop,'*.png'));
contador   = length(images);
     for ii = 1 : contador
        name = images(ii).name;
        filename = strcat(pathCrop,name);
        im = imread(filename);
        fprintf('\nLeyendo -> %s de %s \n',name,pathCrop);
        %%
        I = rgb2lab(im);
        fprintf('Transformando a L*A*B...\n');
        %%
        channel1Min = 0.000;
        channel1Max = 24.681;
        %%
        channel2Min = -16.632;
        channel2Max = 20.176;
        %%
        channel3Min = 0.000;
        channel3Max = 67.289;
        %%
        sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
        BW = sliderBW;
        %%
        maskedRGBImage = im;
        %%
        maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
        %% elimina el .png
        newStr = erase(name,".png");
        % parametros: (imagen a guardar, [direccion de carpeta en
        % donde guarda, nombre de la imagen original, formato a guardar])
        imwrite(maskedRGBImage,[rustFolder,newStr,'.png']);
        fprintf('Se guarda -> %s en %s',newStr,rustFolder);
     end

end

