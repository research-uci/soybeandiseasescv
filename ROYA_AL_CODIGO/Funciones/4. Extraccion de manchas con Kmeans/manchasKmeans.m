
% Aqui se guardarán las imgs
% de manchas a color
 fprintf('___________________________________________\n');      
fprintf('|     Extracción de Manchas con Kmeans      |\n');
 fprintf('___________________________________________\n\n');
 
home          = strcat(pwd,'/');
strDir        = strcat(home,'Escritorio/roya2018/');
pathRust      = 'imgsrust/mLAB/';
rustFolder    = strcat(strDir,pathRust);
rustFolder2   = strcat(strDir,'imgsrust/');
% Si no existe carpeta, la crea
    if exist(rustFolder, 'dir')
        fprintf('Carpeta [.../%s] existe \n',pathRust);
        foldercontent = dir(rustFolder); 
        if numel(foldercontent) > 2
             fprintf('... y no está vacía\n');

        else
             fprintf('... y está vacía\n');

        end

    else

        fprintf('Carpeta [.../%s] no existe \n',pathRust);
        fprintf('Creando... \n');
        mkdir(rustFolder);
        fprintf('Carpeta creada exitosamente!\n');
    end
    
pathAplicacionSalidaSeg          = strcat(rustFolder2,'Segkmeans/'); 
mkdir                            (pathAplicacionSalidaSeg);
    
% en cuantos cluster se dividiran cada imagen
numeroClusteres=3;
%carga del listado de nombres
listadoImg=dir(strcat(rustFolder,'*.png'));
%% lectura en forma de bach del directorio de la cámara
for n=1:size(listadoImg)
    fprintf('Extrayendo manchas-> %s \n',listadoImg(n).name);    
    nombreImagenP=listadoImg(n).name;
    %% salida segmentacion
    nombreImagenEntrada1=strcat(rustFolder,nombreImagenP);    
    nombreImagenSalida1=strcat(pathAplicacionSalidaSeg,nombreImagenP);
    nombreImagen=listadoImg(n).name;
    fprintf('Clustering -> %s \n',nombreImagen);        
    fprintf('nombreImagenEntrada1 -> %s \n',nombreImagenEntrada1);        
    fprintf('nombreImagenSalida1 -> %s \n',nombreImagenSalida1);    
    ClusteringLABSoy(numeroClusteres, nombreImagen, nombreImagenEntrada1, nombreImagenSalida1, '1');    
 
end 
