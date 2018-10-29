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
pathCrop   = 'imgs_recortadas/';
cropFolder = strcat(strDir,pathCrop);

% Si no existe carpeta, la crea
    if ~exist(cropFolder, 'dir')
        mkdir(cropFolder);
    else
        fprintf("la carpeta de imgs_recortadas ya ha sido creada\n");
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

          % se hallan las propiedades deseadas
          CC = bwconncomp(binImage);
          numPixels = cellfun(@numel,CC.PixelIdxList);
          [biggestSize,idx] = max(numPixels);
          BW2 = false(size(binImage));
          BW2(CC.PixelIdxList{idx}) = true;
          
          propiedades = regionprops(BW2, 'Area', 'BoundingBox');

          % se reemplaza la imagen por la segmentada y corto
          img_crop=imcrop(segImage,propiedades(1).BoundingBox);

          % elimina el .png duplicado
          newStr = erase(nombreImagen,".png");

          % reemplaza el bin por hoja
          newName = erase(newStr,"bin");
          newName2 = strrep(newName,'OY','SOY');
          newName3 = strrep(newName2,'UT','RUST');
            

          % parametros: (imagen a guardar, [direccion de carpeta en
          % donde guarda, nombre de la imagen original, formato a guardar])
          imwrite(img_crop,[cropFolder,newName3,'.png']);
     end
 
 
removeFiles(pathBin);
removeFiles(pathSeg);

end

