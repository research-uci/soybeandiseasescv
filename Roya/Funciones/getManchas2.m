function [rustFolder] = getManchas(strDir,pathCrop);
% Toma la mancha previamente recortada, lo transforma al espacio HSI
% de manera a realizar una máscara para quitar el área de interes (ROI)
% de la mancha de la enfermedad
%%
% Aqui se guardarán las imgs
% de manchas a color
 fprintf('___________________________________________\n');      
fprintf('|         Extracción de Manchas             |\n');
 fprintf('___________________________________________\n\n');

pathRust   = 'imgsrust/';
rustFolder = strcat(strDir,pathRust);

% Si no existe carpeta, la crea
    if exist(rustFolder, 'dir')
        fprintf('Carpeta [.../%s] existe \n',pathRust);
        a=dir([rustFolder '/*.png']);
        out=size(a,1);
        
        if out > 0
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
    
pathEntradaImagenes              = strcat(rustFolder,'inputEntrenamiento/'); 
pathEntradaImagenesTest          = strcat(rustFolder,'inputTests/');
pathEntradaImagenesTraining      = strcat(rustFolder,'inputTraining/');
pathEntradaAprender              = strcat(rustFolder,'inputEntrenamiento/');
pathAplicacionSalidaSeg          = strcat(rustFolder,'Segkmeans/'); 
pathAplicacion                   = strcat(rustFolder,'silueta/');    
pathBinClase1                    = strcat(pathAplicacion,'class1/'); %siluetas de clase1
pathBinClase2                    = strcat(pathAplicacion,'class2/'); %siluetas de clase2
pathEntradaImagenesClass1        = strcat(rustFolder,'class1/'); 
pathEntradaImagenesClass2        = strcat(rustFolder,'class2/');
pathResultados                   = strcat(rustFolder,'output/');

mkdir                            (pathEntradaImagenes);
mkdir                            (pathEntradaImagenesTest);
mkdir                            (pathEntradaImagenesTraining);
mkdir                            (pathEntradaAprender);
mkdir                            (pathAplicacionSalidaSeg);
mkdir                            (pathEntradaImagenesClass1);
mkdir                            (pathEntradaImagenesClass2);
mkdir                            (pathBinClase1);
mkdir                            (pathBinClase2);
mkdir                            (pathResultados);

nombreImagenP='nombreImagenP';
%BINARIO DE CLASES
postfijoBinClase1='_CL1.jpg';
postfijoBinClase2='_CL2.jpg';
archivoBDENFERMEDADES=strcat(pathResultados,'BDENFERMEDADES.csv');

%% se traen las imagenes de imgcrop a inputEntrenamiento
nfiles = length(pathCrop);
fil = dir(fullfile(pathCrop,'*.png'));
for ii = 1 : nfiles
     filename = strcat(pathCrop,fil(ii).name);
     nombreImagen = fil(ii).name;
     ima          = imread(filename);
     imwrite(ima,[pathEntradaImagenes,nombreImagen]);
end
% se listan las imagenes copiadas anteriormente
listadoImg=dir(strcat(pathEntradaImagenes,'*.png'));
% % se contabilizan cuantas imagenes serán para test y se copian en inputTest
% % (imagenes al azar)
        function [tablaTraining, tablaTest]=splitSetImg(listadoImg, proporcionTraining, rustFolder, pathResultados)
        tablaSetCompleto = listadoImg;
        tamanoTabla=size(tablaSetCompleto);
        %% Declaracion de variables
        TotalFilas=tamanoTabla(1); %tamano filas automatico
        proporcionTest=0;   
        TotalFilasTraining=0;
        TotalFilasTest=0;
            %Al menos 1porciento debe quedar para test
            if(proporcionTraining<=99)
                proporcionTest=100-proporcionTraining; 
                TotalFilasTraining=floor((TotalFilas*proporcionTraining)/100);
                TotalFilasTest=floor((TotalFilas*proporcionTest)/100);
            else
                fprintf('No se aplica la PROPORCION, debe existir al menos 1% para el archivo Test \n');
            end % fin validacion
        %% Dividir conjunto
        contadorRandom=0;
        fprintf('Elegidas %i filas al azar para Test \n',TotalFilasTest);
        %% Ciclo para creacion de los conjuntos de entrenamiento y de test
            for(contadorRandom=1:1:TotalFilasTest)
                rng('shuffle');
                tamanoTabla=size(tablaSetCompleto);
                TotalFilas=tamanoTabla(1); %tamano filas automatico
                filaIndexEleccion=int16(rand()*TotalFilas)+1;
            %    fprintf('%i) %i fila seleccionada \n',contadorRandom,filaIndexEleccion);
            %Elegir fila al azar
            %posicionarse en la fila y borrar del conjunto general
            filaElegida=tablaSetCompleto(filaIndexEleccion,:);
            if(contadorRandom==1)
                %crea la primera fila
                tablaTest=filaElegida;
            else
                %Agrega filas
                tablaTest=[tablaTest; filaElegida];
            end %(contadorRandom==1)
            tablaSetCompleto(filaIndexEleccion,:)=[]; %borrar la fila seleccionada del conjunto principal
            end %end for
        %Guardar los restantes en training
        tablaTraining=tablaSetCompleto;
    end
% % se copian las imgs desde inputEntrenamiento a inputTraining
    function [] = copyDirectory(tablaTest, pathEntradaImagenes, pathEntradaImagenesTest)
    tamanoTablaArchivos=size(tablaTest);
    TotalFilas=tamanoTablaArchivos(1);
        for contadorRandom=1:1:TotalFilas
        %% copiando desde imagenes originales a test
        archivoCopiarFuente=strcat(pathEntradaImagenes,tablaTest(contadorRandom).name);
        archivoCopiarDestino=strcat(pathEntradaImagenesTest,tablaTest(contadorRandom).name);
        %% comando de copia
        comando = { 'cp','-f',archivoCopiarFuente, archivoCopiarDestino};
        command=strjoin(comando);
        [status,cmdout] = system(command);    
        end
    end

    function [] = copyDirectory2(tablaTraining, pathEntradaImagenes, pathEntradaImagenesTraining)
    tamanoTablaArchivos=size(tablaTraining);
    TotalFilas=tamanoTablaArchivos(1);
        for contadorRandom=1:1:TotalFilas
            %% copiando desde imagenes originales a test
            archivoCopiarFuente=strcat(pathEntradaImagenes,tablaTraining(contadorRandom).name);
            archivoCopiarDestino=strcat(pathEntradaImagenesTraining,tablaTraining(contadorRandom).name);

            %% comando de copia
            comando = { 'cp','-f',archivoCopiarFuente, archivoCopiarDestino};
            command=strjoin(comando);
            [status,cmdout] = system(command);    

        end
    end
% % en cuantos cluster se dividiran cada imagen
numeroClusteres=3;
% % carga del listado de nombres
listadoImg=dir(strcat(pathEntradaAprender,'*.png'));
% % lectura en forma de bach del directorio de la cámara
    for n=1:size(listadoImg)
    fprintf('Extrayendo manchas-> %s \n',listadoImg(n).name);    
    nombreImagenP=listadoImg(n).name;
    %% salida segmentacion
    nombreImagenEntrada1=strcat(pathEntradaAprender,nombreImagenP);    
    nombreImagenSalida1=strcat(pathAplicacionSalidaSeg,nombreImagenP);
    nombreImagen=listadoImg(n).name;
    fprintf('Clustering -> %s \n',nombreImagen);        
    fprintf('nombreImagenEntrada1 -> %s \n',nombreImagenEntrada1);        
    fprintf('nombreImagenSalida1 -> %s \n',nombreImagenSalida1);    
    %ClusteringLABSoy(numeroClusteres, nombreImagen, nombreImagenEntrada1, nombreImagenSalida1, '1');
    %ClusteringLABSoy(numeroClusteres, nombreImagen, nombreImagenEntrada1,nombreImagenSalida1,'1')
    %% Inicio de segmentacion k-means
    IOrig = imread(nombreImagenEntrada1);
    % --------------------------
    h = fspecial('average', [5 5]);
    ISh = imfilter(IOrig, h);
    % --------------------------
    % crea una transformacion de color RGB a L*a*b
    cform = makecform('srgb2lab');
    lab_ISh = applycform(ISh,cform); % aplica transformacoinacion de color independiente del dispositivo
    ab = double(lab_ISh(:,:,2:3));
    nfilas = size(ab,1);
    ncols = size(ab,2);
    ab = reshape(ab,nfilas*ncols,2); %cambia la figura 
    % repetir agrupamiento 3 veces para evitar un mínimo local
    [cluster_idx cluster_center] = kmeans(ab,numeroClusteres,'distance','sqEuclidean', 'Replicates',3);
    pixel_etiqueta = reshape(cluster_idx,nfilas,ncols);
    %% crear imagenes
    segmented_images = cell(1,3);
    imagenFinal= cell(1,3);
    rgb_label = repmat(pixel_etiqueta,[1 1 3]);
    %imagenFinal;
    %% Armar imagenes de los clusteres y guardarlas en archivos
    for k = 1:numeroClusteres
        color = ISh;
        color(rgb_label ~= k) = 0;
        segmented_images{k} = color;

        %% nombre de imagen, eliminar .png
        newStr = erase(nombreImagen,".png");

        %% Almacenar en archivos las imagenes de clusteres
        extension=strcat('1','C',strcat(int2str(k),'.png'));%'.jpg'
        nombreImagenCluster=strcat(nombreImagenSalida1,extension);

        fprintf('imagen custer-> %s \n',nombreImagenCluster);
        imwrite(segmented_images{k},nombreImagenCluster,'png');%'jpg'
    end
 
  end
listado=dir(strcat(pathEntradaImagenesClass1,'*.png'));









end
