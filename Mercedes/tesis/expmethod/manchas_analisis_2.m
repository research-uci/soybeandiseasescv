function []= manchas_analisis_2(pathresultadofondoremovido, pathresultadomagentabin, formato, formato2)
filesrgb=dir([pathresultadofondoremovido, formato2]);
filesbinmag=dir([pathresultadomagentabin, formato2]);
scale=0.5;
nn=0;
[~,ndx1] = natsortfiles({filesrgb.name});
[~,ndx2] = natsortfiles({filesbinmag.name});

filesrgb = filesrgb(ndx1);
filesbinmag = filesbinmag(ndx2);

encabezado = {'Name','Area','Perimetro','Excentricidad','AreaFF','MajorAxisLength','MinorAxisLength','Centroid 1','Centroid 2'};
archivo = 'D:\resultado\r_param\carmain9new.xlsx'; % ruta y nombre del archivo

matriz={};  % declaracion de matriz
sheet = 1; %hoja de excel
xlRange = 'A1'; %celda en donde empieza el excel
xlswrite(archivo,encabezado,sheet,xlRange); %funcion que escribe los datos en una planilla

for j=1:length(filesrgb) %por cada hoja
    
    filesrgb(j).name;
    filesbinmag(j).name;
    im1=imread([pathresultadofondoremovido, filesrgb(j).name]);
    % imshow (im1), title('rgb');
    im2=imread([pathresultadomagentabin, filesbinmag(j).name]);
    %para que las dimensiones de x e y sean iguales
    [fA,cA,bA]= size(im1);
    [fB,cB,bB]= size(im2);
    
    if fB ~= fA || cA ~= cB
        im2 = imresize(im2, [fA cA]);
    end
    %end de la pregunta de igualacion de dimensiones
    level = graythresh(im2);
    im22=imbinarize(im2,level);
    %     figure, imshow (im22), title('bin');
    
    im33=imresize(im1,scale);
    im44=imresize(im22,scale);
    
    B = medfilt2(im44);
    BW=imfill(B,'holes');
    
    se = strel('square',1);
    %se = strel('disk',2);
    
    imag_bw=imclose(BW,se);
    
    
    XS=zeros(size(im33),'uint8');
    
    XS(:,:,1)=immultiply(im33(:,:,1),uint8(imag_bw));
    XS(:,:,2)=immultiply(im33(:,:,2),uint8(imag_bw));
    XS(:,:,3)=immultiply(im33(:,:,3),uint8(imag_bw));
    
    %imshow(XS);
    
    fprintf(' j= %d \n',j);
    
    [L Ne]=bwlabel(imag_bw);
    propied= regionprops(L);
    s=find([propied.Area]>10);
    %     fprintf(' s= %.2f \n',size(s,2));
    for n=1:size(s,2)
        h= propied(s(n)).BoundingBox;
        q=imcrop(imag_bw,h); %mancha binaria
        %figure, imshow (q);
        %fprintf(' n= %d \n',n);
        nn=nn+1;
        perimetro=regionprops(q,'Perimeter');
        area12=regionprops(q,'Area');
        fprintf('perimetro =%.2f \n',perimetro.Perimeter);
        fprintf('Area =%.2f \n',area12.Area);
        excentricidad1=regionprops(q,'Eccentricity');
        fprintf('excentricidad =%.2f \n',excentricidad1.Eccentricity);
        areaff=regionprops(q,'FilledArea');
        fprintf('areaff =%.2f \n',areaff.FilledArea);
        alto=regionprops(q,'MajorAxisLength');
        fprintf('alto =%.2f \n',alto.MajorAxisLength);
        ancho=regionprops(q,'MinorAxisLength');
        fprintf('ancho =%.2f \n',ancho.MinorAxisLength);
        stat = regionprops(q,'Centroid');
        fprintf('centroid =%.2f \n',stat.Centroid);
        centroids = cat(1, stat.Centroid);
        fprintf('Fin caracteristicas................................... \n');
        %[ promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB ] = extractMeanCImgRGB( im, closeBW); 
        matriz{j,1}=filesrgb(j).name;
        matriz{j,2}=area12.Area;
        matriz{j,3}=perimetro.Perimeter;
        matriz{j,4}=excentricidad1.Eccentricity;
        matriz{j,5}=areaff.FilledArea;
        matriz{j,6}=alto.MajorAxisLength;
        matriz{j,7}=ancho.MinorAxisLength;        
        matriz{j,8}=centroids(:,1);
        matriz{j,9}=centroids(:,2);
    end
    fprintf(' hoja= %s con cantidad= %d \n',filesrgb(j).name,n);
end
xlRange = 'A2';
xlswrite(archivo,matriz,sheet,xlRange);


