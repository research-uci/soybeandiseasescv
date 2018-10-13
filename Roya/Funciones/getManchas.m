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
    
%% donde se guardará el .csv generado
pathResultados           = strcat(rustFolder,'output/');
mkdir                    (pathResultados);
%% Ingresar parametros, porcentaje utilizado para entrenamiento
proporcionTraining=70;
%% crear carpetas
pathEntradaImagenes              = strcat(rustFolder,'inputEntrenamiento/'); 
pathEntradaImagenesTest          = strcat(rustFolder,'inputTests/');
pathEntradaImagenesTraining      = strcat(rustFolder,'inputTraining/');
mkdir                            (pathEntradaImagenes);
mkdir                            (pathEntradaImagenesTest);
mkdir                            (pathEntradaImagenesTraining);
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
%%
   % function [tablaTraining, tablaTest]=splitSetImg(listadoImg, proporcionTraining, rustFolder, pathResultados)
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
   % end
%%
% % se copian las imgs desde inputEntrenamiento a inputTraining
% copyDirectory(tablaTest, pathEntradaImagenes, pathEntradaImagenesTest);
% copyDirectory(tablaTraining, pathEntradaImagenes, pathEntradaImagenesTraining);
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
%%
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
%%
%%
%% procesos de MainSoySegLABKmeans
% pathLabKmeans                    = strcat(folder,'Segkmeans/');   
pathEntradaAprender              = strcat(rustFolder,'inputEntrenamiento/');
pathAplicacionSalidaSeg          = strcat(rustFolder,'Segkmeans/'); 
% mkdir                            (pathLabKmeans);
mkdir                            (pathEntradaAprender);
mkdir                            (pathAplicacionSalidaSeg);

% en cuantos cluster se dividiran cada imagen
numeroClusteres=3;
%carga del listado de nombres
listadoImg=dir(strcat(pathEntradaAprender,'*.png'));
%% lectura en forma de bach del directorio de la cámara
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
 
end %

pathAplicacion                   = strcat(rustFolder,'silueta/');    
pathBinClase1                    = strcat(pathAplicacion,'class1/'); %siluetas de clase1
pathBinClase2                    = strcat(pathAplicacion,'class2/'); %siluetas de clase2
pathEntradaImagenesClass1        = strcat(rustFolder,'class1/'); 
pathEntradaImagenesClass2        = strcat(rustFolder,'class2/');
mkdir                            (pathEntradaImagenesClass1);
mkdir                            (pathEntradaImagenesClass2);
mkdir                            (pathBinClase1);
mkdir                            (pathBinClase2);
nombreImagenP='nombreImagenP';

% BINARIO DE CLASES
postfijoBinClase1='_CL1.jpg';
postfijoBinClase2='_CL2.jpg';

archivoBDENFERMEDADES=strcat(pathResultados,'BDENFERMEDADES.csv');
listado=dir(strcat(pathEntradaImagenesClass1,'*.png'));

for n=1:size(listado)
    fprintf('Extrayendo características para entrenamiento-> %s \n',listado(n).name);    
    nombreImagenP=listado(n).name;
    nombreImagenOriginal=nombreImagenP;
    
    nombreImagenColorClase1=strcat(pathEntradaImagenesClass1,nombreImagenOriginal);
    nombreImagenBinClase1=strcat(pathBinClase1,nombreImagenOriginal,postfijoBinClase1);
    
   etiqueta='ROYA';
   %%
  % classDetectionExp( 1, nombreImagenColorClase1, nombreImagenBinClase1, archivoBDENFERMEDADES, nombreImagenOriginal, etiqueta);
     
    %% Lectura de la imagen con fondo removido en color
    ImROI=imread(nombreImagenColorClase1);

    %% Binarización de la silueta fondo removido
    umbral=graythresh(ImROI);
    IFRB1=im2bw(ImROI,umbral); %Imagen binaria para detección de objetos

    %almacenado de imagn intermedia
    imwrite(IFRB1,nombreImagenBinClase1,'jpg');
    %% Etiquetar elementos conectados

    [ListadoObjetos Ne]=bwlabel(IFRB1);

    %% Calcular propiedades de los objetos de la imagen
    propiedades= regionprops(ListadoObjetos);

    %% Buscar áreas de pixeles correspondientes a objetos
    seleccion=find([propiedades.Area]);

    %% obtenr coordenadas de areas
    contadorObjetos=0; %encontrados
    %numeroCuadro='';
    %size(seleccion,2)
    % consulta si existen objetos, puede venir una imagen vacía
    if (size(seleccion,2)==0)
        %si no existen objetos coloca en cero todos los valores de
        %caracteristicas.
        fprintf('cantidad de objetos %i \n', contadorObjetos);
        promedioRGBR=0.0;
        promedioRGBG=0.0;
        promedioRGBB=0.0;
        desviacionRGBR=0.0;
        desviacionRGBG=0.0;
        desviacionRGBB=0.0;
        promedioLABL=0.0;
        promedioLABA=0.0;
        promedioLABB=0.0;
        desviacionLABL=0.0;
        desviacionLABA=0.0;
        desviacionLABB=0.0;
        promedioHSVH=0.0;
        promedioHSVS=0.0;
        promedioHSVV=0.0;
        desviacionHSVH=0.0;
        desviacionHSVS=0.0;
        desviacionHSVV=0.0;
        sumaArea=0;
        perimetro=0.0;
        excentricidad=0.0;
        ejeMayor=0.0;
        ejeMenor=0.0;
        entropia=0.0;
        inercia=0.0;
        energia=0.0;
        etiqueta='VACIO';
        x=0; 
        y=0;
        w=0;
        h=0;
        fila=sprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10i, %10i, %10i, %s \n', nombreImagenOriginal, numeroROI, contadorObjetos, promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB, promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB, promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, x, y, w, h,etiqueta);
        saveAVDefCalyx2(archivoBDENFERMEDADES, fila);%% otra funcion           
    else
    %% ------------------------
    for n=1:size(seleccion,2)
        contadorObjetos=contadorObjetos+1;
        coordenadasAPintar=round(propiedades(seleccion(n)).BoundingBox); %coordenadas de pintado
        %% recorta las imagenes

        % pequeñas areas binarias son utilizadas para recortar imagenes a color
        ISiluetaROI = imcrop(IFRB1,coordenadasAPintar);
        IFondoR = imcrop(ImROI,coordenadasAPintar);

        %% INICIO extraer caracteristicas
        % las siluetas ya denen venir binarizadas con Otzu.
        function [ promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB ] = extractMeanCImgRGB( IFondoR, ISiluetaROI);
        %    fprintf('%i, %f, %f, %f, %f, %f, %f \n',contadorObjetos, promedioR, promedioG, promedioB, desviacionR, desviacionG, desviacionB);
        PRIMER_PLANO=1;
       %Lectura de la imagen con fondo
       IMascara=IMascaraC;
      [filasTope, columnasTope, ~]=size(IRecorteRGB);
    sumaR=double(0.0);
    sumaG=double(0.0);
    sumaB=double(0.0);
    contadorPixeles=double(0.0);
    %variables para el calculo de varianza
    sumaVarianzaR=double(0.0);
    varianzaG=double(0.0);
    sumaVarianzaG=double(0.0);
    varianzaG=double(0.0);
    sumaVarianzaB=double(0.0);
    varianzaB=double(0.0);
    %recorrer la imagen mascara
    for f=1:1:filasTope
        for c=1:1:columnasTope
    %        % Leer de la imagen mascara si el valor es diferente a cero
            pixelMascara=IMascara(f,c);
            if pixelMascara == PRIMER_PLANO
                sumaR=double(IRecorteRGB(f,c,1))+sumaR;
                sumaG=double(IRecorteRGB(f,c,2))+sumaG;
                sumaB=double(IRecorteRGB(f,c,3))+sumaB; 
                contadorPixeles=contadorPixeles+1;
            end %if        
        end %for columnas
    end %for filas
    % --------------------------------------
    %valores de los promedios porcanales
    %---------------------------------------
    promedioR=double(sumaR/contadorPixeles); %promedio canal R
    promedioG=double(sumaG/contadorPixeles); %promedio canal G
    promedioB=double(sumaB/contadorPixeles); %promedio canal B
    %------------------------------------------------------------------------
    % Varianza muestral
    %------------------------------------------------------------------------
    for f=1:1:filasTope
        for c=1:1:columnasTope
    %        % Leer de la imagen mascara si el valor es diferente a cero
            pixelMascara=IMascara(f,c);
            if pixelMascara == PRIMER_PLANO            
                sumaVarianzaR=sumaVarianzaR+(IRecorteRGB(f,c,1)-promedioR)^2;
                sumaVarianzaG=sumaVarianzaG+(IRecorteRGB(f,c,2)-promedioG)^2;
                sumaVarianzaB=sumaVarianzaB+(IRecorteRGB(f,c,3)-promedioB)^2;            
            end %if        
        end %for columnas
    end %for filas
    % -----------------------------------------------------------------------
    desviacionR=sqrt(double(sumaVarianzaR/(contadorPixeles)));
    desviacionG=sqrt(double(sumaVarianzaG/(contadorPixeles)));
    desviacionB=sqrt(double(sumaVarianzaB/(contadorPixeles)));
    %% resultados finales
    end
   
    
        function [ promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB ] = extractMeanCImgLAB( IFondoR, ISiluetaROI);
    %    fprintf('%f, %f, %f, %f, %f, %f \n', promedioL, promedioA, promedioB, desviacionL, desviacionA, desviacionB);
    PRIMER_PLANO=1;

%Lectura de la imagen con fondo
IRecorteLAB=rgb2lab(IRecorteRGB); % hsv

IMascara=IMascaraC;

[filasTope, columnasTope, ~]=size(IRecorteRGB);

sumaL=double(0.0);
sumaA=double(0.0);
sumaB=double(0.0);
contadorPixeles=double(0.0);

%variables para el calculo de varianza
sumaVarianzaL=double(0.0);
varianzaL=double(0.0);
sumaVarianzaA=double(0.0);
varianzaA=double(0.0);
sumaVarianzaB=double(0.0);
varianzaB=double(0.0);

%recorrer la imagen mascara
for f=1:1:filasTope
    for c=1:1:columnasTope
%        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);

        if pixelMascara == PRIMER_PLANO
            sumaL=double(IRecorteLAB(f,c,1))+sumaL;
            sumaA=double(IRecorteLAB(f,c,2))+sumaA;
            sumaB=double(IRecorteLAB(f,c,3))+sumaB; 
            contadorPixeles=contadorPixeles+1;
        end %if        
    end %for columnas
end %for filas


% --------------------------------------
%valores de los promedios porcanales
%---------------------------------------
promedioL=double(sumaL/contadorPixeles); %promedio canal L
promedioA=double(sumaA/contadorPixeles); %promedio canal A
promedioB=double(sumaB/contadorPixeles); %promedio canal B

%------------------------------------------------------------------------
% Varianza muestral
%------------------------------------------------------------------------
for f=1:1:filasTope
    for c=1:1:columnasTope
%        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);
        if pixelMascara == PRIMER_PLANO            
            sumaVarianzaL=sumaVarianzaL+(IRecorteLAB(f,c,1)-promedioL)^2;
            sumaVarianzaA=sumaVarianzaA+(IRecorteLAB(f,c,2)-promedioA)^2;
            sumaVarianzaB=sumaVarianzaB+(IRecorteLAB(f,c,3)-promedioB)^2;            
        end %if        
    end %for columnas
end %for filas
% -----------------------------------------------------------------------
%cálculo de la varianza por canal H
%sumaBarianzaS
desviacionL=sqrt(sumaVarianzaL/(contadorPixeles));
desviacionA=sqrt(sumaVarianzaA/(contadorPixeles));
desviacionB=sqrt(sumaVarianzaB/(contadorPixeles));

%% resultados finales
  end
        function [ promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV ] = extractMeanCImgHSV( IFondoR, ISiluetaROI);
        PRIMER_PLANO=1;

%Lectura de la imagen con fondo
IRecorteHSV=rgb2hsv(IRecorteRGB); % hsv
IMascara=IMascaraC;

[filasTope, columnasTope, ~]=size(IRecorteRGB);

sumaH=double(0.0);
sumaS=double(0.0);
sumaV=double(0.0);
contadorPixeles=double(0.0);

%variables para el calculo de varianza
sumaVarianzaH=double(0.0);
varianzaH=double(0.0);
sumaVarianzaS=double(0.0);
varianzaS=double(0.0);
sumaVarianzaV=double(0.0);
varianzaV=double(0.0);

%recorrer la imagen mascara
for f=1:1:filasTope
    for c=1:1:columnasTope
        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);
        if pixelMascara == PRIMER_PLANO
            sumaH=double(IRecorteHSV(f,c,1))+sumaH;
            sumaS=double(IRecorteHSV(f,c,2))+sumaS;
            sumaV=double(IRecorteHSV(f,c,3))+sumaV; 
            contadorPixeles=contadorPixeles+1;
        end %if        
    end %for columnas
end %for filas

% --------------------------------------
%valores de los promedios porcanales
%---------------------------------------
promedioH=double(sumaH/contadorPixeles); %promedio canal H
promedioS=double(sumaS/contadorPixeles); %promedio canal S
promedioV=double(sumaV/contadorPixeles); %promedio canal V

%------------------------------------------------------------------------
% Varianza muestral
%------------------------------------------------------------------------
for f=1:1:filasTope
    for c=1:1:columnasTope
        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);
        if pixelMascara == PRIMER_PLANO            
            sumaVarianzaH=sumaVarianzaH+(IRecorteHSV(f,c,1)-promedioH)^2;
            sumaVarianzaS=sumaVarianzaS+(IRecorteHSV(f,c,2)-promedioS)^2;
            sumaVarianzaV=sumaVarianzaV+(IRecorteHSV(f,c,3)-promedioV)^2;            
        end %if        
    end %for columnas
end %for filas
% -----------------------------------------------------------------------
desviacionH=sqrt(sumaVarianzaH/(contadorPixeles));
desviacionS=sqrt(sumaVarianzaS/(contadorPixeles));
desviacionV=sqrt(sumaVarianzaV/(contadorPixeles));
    %    fprintf('%f, %f, %f, %f, %f, %f \n', promedioH, promedioS, promedioV, desviacionH, desviacionS, desviacionV);
 end
    %    fprintf('contador objetos %i \n', contadorObjetos);    
       function [ sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor ] = extractDefCarGeoImg(ISiluetaROI);
    %    fprintf('%10i, %10.4f, %10.4f, %10.4f, %10.4f, \n',  sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor);
    IB1=IOrig;

%% Etiquetado de áreas conectadas, se necesita una imagen binaria
[L Ne]=bwlabel(IB1); %en L los objetos y en Ne= números de áreas etiquetadas

%% Cálculo de propiedades de los objetos de la imagen
% se toman los datos geométricos necesarios para luego poder caracterizarlos.
propiedades= regionprops(L,'Area','Perimeter','Eccentricity','MajorAxisLength','MinorAxisLength');


%% Mostrar características geométricas
% Se recorre de principio a fin las propiedades obtenidas
sumaArea=0;
redondez=0;
diametro=0;

ejeMayor=0;
ejeMenor=0;

%fprintf('       N#;      Area;  Perimetro; \n');
tamano=1;

for n=1:size(propiedades,1)
%    if(propiedades(n).Area > tamano)
%        fprintf('%10i; %10.4f; %10.4f; %10.4f; %10.4f; \n', propiedades(n).Area, propiedades(n).Perimeter, propiedades(n).Eccentricity, propiedades(n).MajorAxisLength, propiedades(n).MinorAxisLength);
         sumaArea=propiedades(n).Area;
         perimetro=propiedades(n).Perimeter;
         excentricidad=propiedades(n).Eccentricity;
         ejeMayor=propiedades(n).MajorAxisLength;
         ejeMenor=propiedades(n).MinorAxisLength; 
%    end
end
       end
       function [ entropia, inercia, energia  ] = extractCTextures( IFondoR, ISiluetaROI);
       entropia=0.0;
       inercia=0.0;
       energia=0.0;
       
       end 
        fprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %s \n', nombreImagenOriginal, numeroROI, contadorObjetos, promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB, promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB, promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, etiqueta); 
        %% FIN extraer caracteristicas  
    %fprintf('En el archivo %s antes de correr el clasificador de DEFECTOS\n', archivoVectorDef);
        %% guardar el archivo    
        fila=sprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10i, %10i, %10i, %s \n', nombreImagenOriginal, numeroROI, contadorObjetos, promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB, promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB, promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, coordenadasAPintar(1), coordenadasAPintar(2), coordenadasAPintar(3), coordenadasAPintar(4), etiqueta);
        saveClassFeatures(archivoBDENFERMEDADES, fila);

    end % fin de ciclo

    %% ------------------------

    end% fin if
   
   %% 
end

listado=dir(strcat(pathEntradaImagenesClass2,'*.png'));
for n=1:size(listado)
    fprintf('Extrayendo características para entrenamiento-> %s \n',listado(n).name);    
    nombreImagenP=listado(n).name;
    nombreImagenOriginal=nombreImagenP;
    
    nombreImagenColorClase2=strcat(pathEntradaImagenesClass2,nombreImagenOriginal);
    nombreImagenBinClase2=strcat(pathBinClase2,nombreImagenOriginal,postfijoBinClase2);
    
    
    etiqueta='NO ROYA';
    %%
  % classDetectionExp( 1, nombreImagenColorClase2, nombreImagenBinClase2, archivoBDENFERMEDADES, nombreImagenOriginal, etiqueta);
   %classDetectionExp(numeroROI, imagenNombreROI, imagenNombreFR, archivoVectorDef, nombreImagenOriginal, etiqueta)
   %numeroROI=1 , imagenNombreROI=nombreImagenColorClase2, imagenNombreFR=nombreImagenBinClase2, archivoVectorDef=archivoBDENFERMEDADES,
   %nombreImagenOriginal=nombreImagenOriginal, etiqueta=etiqueta
   
    %% Lectura de la imagen con fondo removido en color
    ImROI=imread(nombreImagenColorClase2);

    %% Binarización de la silueta fondo removido
    umbral=graythresh(ImROI);
    IFRB1=im2bw(ImROI,umbral); %Imagen binaria para detección de objetos

    %almacenado de imagn intermedia
    imwrite(IFRB1,nombreImagenBinClase2,'jpg');
    %% Etiquetar elementos conectados

    [ListadoObjetos Ne]=bwlabel(IFRB1);

    %% Calcular propiedades de los objetos de la imagen
    propiedades= regionprops(ListadoObjetos);

    %% Buscar áreas de pixeles correspondientes a objetos
    seleccion=find([propiedades.Area]);

    %% obtenr coordenadas de areas
    contadorObjetos=0; %encontrados
    %numeroCuadro='';
    %size(seleccion,2)
    % consulta si existen objetos, puede venir una imagen vacía
    if (size(seleccion,2)==0)
        %si no existen objetos coloca en cero todos los valores de
        %caracteristicas.
        fprintf('cantidad de objetos %i \n', contadorObjetos);
        promedioRGBR=0.0;
        promedioRGBG=0.0;
        promedioRGBB=0.0;
        desviacionRGBR=0.0;
        desviacionRGBG=0.0;
        desviacionRGBB=0.0;
        promedioLABL=0.0;
        promedioLABA=0.0;
        promedioLABB=0.0;
        desviacionLABL=0.0;
        desviacionLABA=0.0;
        desviacionLABB=0.0;
        promedioHSVH=0.0;
        promedioHSVS=0.0;
        promedioHSVV=0.0;
        desviacionHSVH=0.0;
        desviacionHSVS=0.0;
        desviacionHSVV=0.0;
        sumaArea=0;
        perimetro=0.0;
        excentricidad=0.0;
        ejeMayor=0.0;
        ejeMenor=0.0;
        entropia=0.0;
        inercia=0.0;
        energia=0.0;
        etiqueta='VACIO';
        x=0; 
        y=0;
        w=0;
        h=0;
        fila=sprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10i, %10i, %10i, %s \n', nombreImagenOriginal, numeroROI, contadorObjetos, promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB, promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB, promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, x, y, w, h,etiqueta);
        saveAVDefCalyx2(archivoBDENFERMEDADES, fila);           
    else
    %% ------------------------
    for n=1:size(seleccion,2)
        contadorObjetos=contadorObjetos+1;
        coordenadasAPintar=round(propiedades(seleccion(n)).BoundingBox); %coordenadas de pintado
        %% recorta las imagenes

        % pequeñas areas binarias son utilizadas para recortar imagenes a color
        ISiluetaROI = imcrop(IFRB1,coordenadasAPintar);
        IFondoR = imcrop(ImROI,coordenadasAPintar);

        %% INICIO extraer caracteristicas
        % las siluetas ya denen venir binarizadas con Otzu.
            function [ promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB ] = extractMeanCImgRGB( IFondoR, ISiluetaROI);
        %    fprintf('%i, %f, %f, %f, %f, %f, %f \n',contadorObjetos, promedioR, promedioG, promedioB, desviacionR, desviacionG, desviacionB);
        PRIMER_PLANO=1;
       %Lectura de la imagen con fondo
       IMascara=IMascaraC;
      [filasTope, columnasTope, ~]=size(IRecorteRGB);
    sumaR=double(0.0);
    sumaG=double(0.0);
    sumaB=double(0.0);
    contadorPixeles=double(0.0);
    %variables para el calculo de varianza
    sumaVarianzaR=double(0.0);
    varianzaG=double(0.0);
    sumaVarianzaG=double(0.0);
    varianzaG=double(0.0);
    sumaVarianzaB=double(0.0);
    varianzaB=double(0.0);
    %recorrer la imagen mascara
    for f=1:1:filasTope
        for c=1:1:columnasTope
    %        % Leer de la imagen mascara si el valor es diferente a cero
            pixelMascara=IMascara(f,c);
            if pixelMascara == PRIMER_PLANO
                sumaR=double(IRecorteRGB(f,c,1))+sumaR;
                sumaG=double(IRecorteRGB(f,c,2))+sumaG;
                sumaB=double(IRecorteRGB(f,c,3))+sumaB; 
                contadorPixeles=contadorPixeles+1;
            end %if        
        end %for columnas
    end %for filas
    % --------------------------------------
    %valores de los promedios porcanales
    %---------------------------------------
    promedioR=double(sumaR/contadorPixeles); %promedio canal R
    promedioG=double(sumaG/contadorPixeles); %promedio canal G
    promedioB=double(sumaB/contadorPixeles); %promedio canal B
    %------------------------------------------------------------------------
    % Varianza muestral
    %------------------------------------------------------------------------
    for f=1:1:filasTope
        for c=1:1:columnasTope
    %        % Leer de la imagen mascara si el valor es diferente a cero
            pixelMascara=IMascara(f,c);
            if pixelMascara == PRIMER_PLANO            
                sumaVarianzaR=sumaVarianzaR+(IRecorteRGB(f,c,1)-promedioR)^2;
                sumaVarianzaG=sumaVarianzaG+(IRecorteRGB(f,c,2)-promedioG)^2;
                sumaVarianzaB=sumaVarianzaB+(IRecorteRGB(f,c,3)-promedioB)^2;            
            end %if        
        end %for columnas
    end %for filas
    % -----------------------------------------------------------------------
    desviacionR=sqrt(double(sumaVarianzaR/(contadorPixeles)));
    desviacionG=sqrt(double(sumaVarianzaG/(contadorPixeles)));
    desviacionB=sqrt(double(sumaVarianzaB/(contadorPixeles)));
    %% resultados finales
    end
   
    
        function [ promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB ] = extractMeanCImgLAB( IFondoR, ISiluetaROI);
    %    fprintf('%f, %f, %f, %f, %f, %f \n', promedioL, promedioA, promedioB, desviacionL, desviacionA, desviacionB);
    PRIMER_PLANO=1;

%Lectura de la imagen con fondo
IRecorteLAB=rgb2lab(IRecorteRGB); % hsv

IMascara=IMascaraC;

[filasTope, columnasTope, ~]=size(IRecorteRGB);

sumaL=double(0.0);
sumaA=double(0.0);
sumaB=double(0.0);
contadorPixeles=double(0.0);

%variables para el calculo de varianza
sumaVarianzaL=double(0.0);
varianzaL=double(0.0);
sumaVarianzaA=double(0.0);
varianzaA=double(0.0);
sumaVarianzaB=double(0.0);
varianzaB=double(0.0);

%recorrer la imagen mascara
for f=1:1:filasTope
    for c=1:1:columnasTope
%        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);

        if pixelMascara == PRIMER_PLANO
            sumaL=double(IRecorteLAB(f,c,1))+sumaL;
            sumaA=double(IRecorteLAB(f,c,2))+sumaA;
            sumaB=double(IRecorteLAB(f,c,3))+sumaB; 
            contadorPixeles=contadorPixeles+1;
        end %if        
    end %for columnas
end %for filas


% --------------------------------------
%valores de los promedios porcanales
%---------------------------------------
promedioL=double(sumaL/contadorPixeles); %promedio canal L
promedioA=double(sumaA/contadorPixeles); %promedio canal A
promedioB=double(sumaB/contadorPixeles); %promedio canal B

%------------------------------------------------------------------------
% Varianza muestral
%------------------------------------------------------------------------
for f=1:1:filasTope
    for c=1:1:columnasTope
%        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);
        if pixelMascara == PRIMER_PLANO            
            sumaVarianzaL=sumaVarianzaL+(IRecorteLAB(f,c,1)-promedioL)^2;
            sumaVarianzaA=sumaVarianzaA+(IRecorteLAB(f,c,2)-promedioA)^2;
            sumaVarianzaB=sumaVarianzaB+(IRecorteLAB(f,c,3)-promedioB)^2;            
        end %if        
    end %for columnas
end %for filas
% -----------------------------------------------------------------------
%cálculo de la varianza por canal H
%sumaBarianzaS
desviacionL=sqrt(sumaVarianzaL/(contadorPixeles));
desviacionA=sqrt(sumaVarianzaA/(contadorPixeles));
desviacionB=sqrt(sumaVarianzaB/(contadorPixeles));

%% resultados finales
  end
        function [ promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV ] = extractMeanCImgHSV( IFondoR, ISiluetaROI);
        PRIMER_PLANO=1;

%Lectura de la imagen con fondo
IRecorteHSV=rgb2hsv(IRecorteRGB); % hsv
IMascara=IMascaraC;

[filasTope, columnasTope, ~]=size(IRecorteRGB);

sumaH=double(0.0);
sumaS=double(0.0);
sumaV=double(0.0);
contadorPixeles=double(0.0);

%variables para el calculo de varianza
sumaVarianzaH=double(0.0);
varianzaH=double(0.0);
sumaVarianzaS=double(0.0);
varianzaS=double(0.0);
sumaVarianzaV=double(0.0);
varianzaV=double(0.0);

%recorrer la imagen mascara
for f=1:1:filasTope
    for c=1:1:columnasTope
        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);
        if pixelMascara == PRIMER_PLANO
            sumaH=double(IRecorteHSV(f,c,1))+sumaH;
            sumaS=double(IRecorteHSV(f,c,2))+sumaS;
            sumaV=double(IRecorteHSV(f,c,3))+sumaV; 
            contadorPixeles=contadorPixeles+1;
        end %if        
    end %for columnas
end %for filas

% --------------------------------------
%valores de los promedios porcanales
%---------------------------------------
promedioH=double(sumaH/contadorPixeles); %promedio canal H
promedioS=double(sumaS/contadorPixeles); %promedio canal S
promedioV=double(sumaV/contadorPixeles); %promedio canal V

%------------------------------------------------------------------------
% Varianza muestral
%------------------------------------------------------------------------
for f=1:1:filasTope
    for c=1:1:columnasTope
        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);
        if pixelMascara == PRIMER_PLANO            
            sumaVarianzaH=sumaVarianzaH+(IRecorteHSV(f,c,1)-promedioH)^2;
            sumaVarianzaS=sumaVarianzaS+(IRecorteHSV(f,c,2)-promedioS)^2;
            sumaVarianzaV=sumaVarianzaV+(IRecorteHSV(f,c,3)-promedioV)^2;            
        end %if        
    end %for columnas
end %for filas
% -----------------------------------------------------------------------
desviacionH=sqrt(sumaVarianzaH/(contadorPixeles));
desviacionS=sqrt(sumaVarianzaS/(contadorPixeles));
desviacionV=sqrt(sumaVarianzaV/(contadorPixeles));
    %    fprintf('%f, %f, %f, %f, %f, %f \n', promedioH, promedioS, promedioV, desviacionH, desviacionS, desviacionV);
 end
    %    fprintf('contador objetos %i \n', contadorObjetos);    
       function [ sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor ] = extractDefCarGeoImg(ISiluetaROI);
    %    fprintf('%10i, %10.4f, %10.4f, %10.4f, %10.4f, \n',  sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor);
    IB1=IOrig;

%% Etiquetado de áreas conectadas, se necesita una imagen binaria
[L Ne]=bwlabel(IB1); %en L los objetos y en Ne= números de áreas etiquetadas

%% Cálculo de propiedades de los objetos de la imagen
% se toman los datos geométricos necesarios para luego poder caracterizarlos.
propiedades= regionprops(L,'Area','Perimeter','Eccentricity','MajorAxisLength','MinorAxisLength');


%% Mostrar características geométricas
% Se recorre de principio a fin las propiedades obtenidas
sumaArea=0;
redondez=0;
diametro=0;

ejeMayor=0;
ejeMenor=0;

%fprintf('       N#;      Area;  Perimetro; \n');
tamano=1;

for n=1:size(propiedades,1)
%    if(propiedades(n).Area > tamano)
%        fprintf('%10i; %10.4f; %10.4f; %10.4f; %10.4f; \n', propiedades(n).Area, propiedades(n).Perimeter, propiedades(n).Eccentricity, propiedades(n).MajorAxisLength, propiedades(n).MinorAxisLength);
         sumaArea=propiedades(n).Area;
         perimetro=propiedades(n).Perimeter;
         excentricidad=propiedades(n).Eccentricity;
         ejeMayor=propiedades(n).MajorAxisLength;
         ejeMenor=propiedades(n).MinorAxisLength; 
%    end
end
       end
       function [ entropia, inercia, energia  ] = extractCTextures( IFondoR, ISiluetaROI);
       entropia=0.0;
       inercia=0.0;
       energia=0.0;
       
       end 
        fprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %s \n', nombreImagenOriginal, numeroROI, contadorObjetos, promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB, promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB, promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, etiqueta); 
        %% FIN extraer caracteristicas  
    %fprintf('En el archivo %s antes de correr el clasificador de DEFECTOS\n', archivoVectorDef);
        %% guardar el archivo    
        fila=sprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10i, %10i, %10i, %s \n', nombreImagenOriginal, numeroROI, contadorObjetos, promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB, promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB, promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, coordenadasAPintar(1), coordenadasAPintar(2), coordenadasAPintar(3), coordenadasAPintar(4), etiqueta);
        saveClassFeatures(archivoBDENFERMEDADES, fila);

    end % fin de ciclo

    %% ------------------------

    end% fin if
   
   
 %%
end  % fin listado
total=size(listado);


fprintf('\n -------------------------------- \n');
fprintf('Se procesaron un total de %i archivos \n',total(1));
fprintf('En el archivo %s se guardaron los DEFECTOS\n', archivoBDENFERMEDADES);
fprintf('\n -------------------------------- \n');

end
