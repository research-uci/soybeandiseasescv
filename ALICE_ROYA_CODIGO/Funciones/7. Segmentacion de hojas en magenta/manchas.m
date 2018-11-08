function [manchasFolder] = manchas(strDir,pathHaz)

pathM   = 'imgs_recortadas/';
manchasFolder = strcat(strDir,pathM);
% Aqui se guardarán las imgs
% de manchas a color
path   = 'imgs_magenta/';
Folder = strcat(strDir,path);

% Aqui se guardarán las imgs
% de manchas a color
path2   = 'imgs_magenta_bin/';
Folder2 = strcat(strDir,path2);

% Si no existe carpeta, la crea
    if ~exist(Folder, 'dir')
        mkdir(Folder);
    else
        fprintf("la carpeta de imgs_magenta ya ha sido creada\n");
    end
    
% Si no existe carpeta, la crea
    if ~exist(Folder2, 'dir')
        mkdir(Folder2);
    else
        fprintf("la carpeta de imgs_magenta_bin ya ha sido creada\n");
    end
    
files = dir(fullfile(pathHaz,'*.png'));
nFiles  = length(files);

for ii = 1 : nFiles
    filename     = strcat(pathHaz,files(ii).name);
    nombreImagen = files(ii).name;
    ima          = imread(filename);
    imag_hsv     = rgb2hsv(ima);
    H            = imag_hsv(:,:,1);
    hotsu        = graythresh(H);
    HW           = imbinarize(H,hotsu);
    im           = ima;
    ima(:,:,1)   = immultiply(im(:,:,1),HW);
    ima(:,:,2)   = immultiply(im(:,:,2),HW);
    ima(:,:,3)   = immultiply(im(:,:,3),HW);
    
    %% elimina el .png duplicado
    newStr = erase(nombreImagen,".png");
%     newName = strrep(newStr,'crop','R');
    
    imwrite(ima,[Folder,newStr,'.png']);
    
end
files2 = dir(fullfile(Folder,'*.png'));
nFiles  = length(files2);

for ii = 1 : nFiles
    filename     = strcat(Folder,files2(ii).name);
    nombreImagen = files2(ii).name;
    ima          = imread(filename);
    rgbg         = rgb2gray(ima);
    binImage     = imbinarize(rgbg);
    
    %% elimina el .png duplicado
    newStr2 = erase(nombreImagen,".png");
    %         imshow(binImage)
    %% reemplaza el S por bin
%     newName = strrep(newStr2,'crop','R');
    
    %imwrite(binImage,[Folder2,newStr2,strcat('.png','_CALB1.jpg')]);
    imwrite(binImage,[Folder2,newStr2,'.png']);
    
    
end
   removeFiles(manchasFolder); 

end

