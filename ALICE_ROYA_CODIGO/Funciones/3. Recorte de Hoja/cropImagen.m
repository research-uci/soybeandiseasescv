function [cropFolder] =  cropImagen(strDir,pathSeg,pathBin)
% Debido a la dimension original de las imagenes (4032 x 3024px)
% los procesos requieren recursos computacionales mayores,
% se ha optado por el corte de la region aislando unicamente la hoja
% despreciando el fondo (0).
% La diferencia en resultados entre una imagen sin ningun corte y cortada?
% aun no se puede definir completamente. 
% Pero en papers menciona que la perdida de informacion no es excesiva*


% Aqui se guardarán las imgs
% cortadas
fprintf('\n\n####    Corte de hoja para ahorrar recursos    ####\n\n');
pathCrop   = 'imgscrop/';
cropFolder = strcat(strDir,pathCrop);

% Si no existe carpeta, la crea
    if exist(cropFolder, 'dir')
        fprintf('Carpeta [.../%s] existe \n',pathCrop);
        a=dir([cropFolder '/*.png']);
        out=size(a,1);
        
        if out > 0
            fprintf('... y no está vacía\n');
            fprintf('Cantidad de imgs en %s = %i\n',pathCrop,out);
            if out == 193
                fprintf('La cant. de imagenes es correcta, pasando al siguiente módulo...\n');
                return
            else
                fprintf('Faltan imágenes a base de datos... Eliminando y Reescribiendo carpeta...\n');
                removeFiles(cropFolder);
                mkdir(cropFolder);
            end    
        else
            fprintf('... y está vacía\n');

        end
    else

        fprintf('Carpeta [.../%s] no existe \n',pathBin);
        fprintf('Creando... \n');
        mkdir(cropFolder);
        fprintf('Carpeta creada exitosamente!\n');

    end
    
 % Define dir de imagenes ha utilizar para el recorte
 % las imagenes a color con fondo removido (imgs_segmentadas)
 % y sus correspondientes en binario (img_bin)
 
 binFile =  dir(fullfile(pathBin,'*.png'));
 segFile =  dir(fullfile(pathSeg,'*.png'));
 nFiles  = length(binFile);
 
  for ii = 1 : nFiles
          filenameBin = strcat(pathBin,binFile(ii).name);
          filenameSeg = strcat(pathSeg, segFile(ii).name);
          nombreImagen = binFile(ii).name;

          binImage = imread(filenameBin);  
          segImage = imread(filenameSeg);
          fprintf('Leyendo imgs -> %s y %s \n',filenameBin,filenameSeg);

          % se hallan las propiedades deseadas
          CC = bwconncomp(binImage);
          numPixels = cellfun(@numel,CC.PixelIdxList);
          [biggestSize,idx] = max(numPixels);
          BW2 = false(size(binImage));
          BW2(CC.PixelIdxList{idx}) = true;
          
          propiedades = regionprops(BW2, 'Area', 'BoundingBox');
          fprintf('Se realizan procesos para corte de imagen...\n');
          % se reemplaza la imagen por la segmentada y corto
          img_crop=imcrop(segImage,propiedades(1).BoundingBox);
          fprintf('Se realiza corte de imagen...\n');

          % elimina el .png duplicado
          newStr = erase(nombreImagen,".png");

          % parametros: (imagen a guardar, [direccion de carpeta en
          % donde guarda, nombre de la imagen original, formato a guardar])
          imwrite(img_crop,[cropFolder,newStr,'.png']);
          fprintf('Se guarda como-> %s en %s \n',newStr,cropFolder);
     end
 

end
