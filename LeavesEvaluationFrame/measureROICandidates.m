function [ ] = measureROICandidates( pathPrincipal, numROI, imagenNombreFR, archivoVectorDef, nombreImagenOriginal)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%A partir de una imagen ROI de los defectos, obtiene un listado en un
%archivo, para saber cuanto miden los objetos detectados.

etiqueta='CANDIDATO';

HOME=strcat(pwd,'/');
pathResultados=strcat(HOME,'SoyResults/byDisease/PSMet2/LeavesEvaluation/','output/'); %

pathTraining=strcat(HOME,'SoyResults/byDisease/PSMet2/TMet2/SegMarkExpExtractionMet2/','output/'); %



%%borrar las caracteristicas anteriores
%removerArchivos(archivoVectorDef);

%% Lectura de la imagen con fondo removido
IFR=imread(imagenNombreFR);


%% Binarización de la silueta fondo removido
umbral=graythresh(IFR);
IFRB1=im2bw(IFR,umbral); %Imagen tratada

%% Etiquetar elementos conectados

[ListadoObjetos Ne]=bwlabel(IFRB1);

%% Calcular propiedades de los objetos de la imagen
propiedades= regionprops(ListadoObjetos);

%% Buscar áreas de pixeles correspondientes a objetos
seleccion=find([propiedades.Area]);

%% primera configuracion
formatSpec='%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s';

%% obtenr coordenadas de areas
contadorObjetos=0; %encontrados
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
    fila=sprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10i, %10i, %10i, %s \n', nombreImagenOriginal, numROI, contadorObjetos, promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB, promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB, promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, x, y, w, h,etiqueta);
    guardarAVDefCalyx2( archivoVectorDef, fila);       
else
%% ------------------------
for n=1:size(seleccion,2)

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
    etiqueta='CANDIDATO';
    x=0; 
    y=0;
    w=0;
    h=0;
    
    
    
    fprintf('contadorObjetos= %f \n', contadorObjetos);
        
    contadorObjetos=contadorObjetos+1;
    coordenadasAPintar=round(propiedades(seleccion(n)).BoundingBox); %coordenadas de pintado
    %% recorta las imagenes

    ISiluetaROI = imcrop(IFRB1,coordenadasAPintar);
    
    %% INICIO extraer caracteristicas
    [ sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor ] = extractDefCarGeoImg(ISiluetaROI);
    
    %% guardar el archivo
    fila=sprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10i, %10i, %10i, %s \n', nombreImagenOriginal, numROI, contadorObjetos, promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB, promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB, promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, coordenadasAPintar(1), coordenadasAPintar(2), coordenadasAPintar(3), coordenadasAPintar(4), etiqueta);
    saveAVDefCalyx2( archivoVectorDef, fila);
    
end % fin de ciclo


end% fin if


end %fin funcion

