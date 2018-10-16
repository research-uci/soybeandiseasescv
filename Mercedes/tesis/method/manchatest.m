function []=manchatest(pathPrincipal,impresionrgb,impresionmul,formato2,formato)
filesrgbcrop=dir([impresionrgb, formato2]);
filesbincrop=dir([impresionmul, formato2]);
encabezado = {'Name','Area','Perimetro','Excentricidad','AreaFF','MajorAxisLength','MinorAxisLength','Centroid 1','Centroid 2'};
archivo = 'D:\resultado\r_param\car.xlsx'; % ruta y nombre del archivo
matriz={};  % declaracion de matriz
sheet = 1; %hoja de excel
xlRange = 'A1'; %celda en donde empieza el excel
xlswrite(archivo,encabezado,sheet,xlRange); %funcion que escribe los datos en una planilla
[~,ndx1] = natsortfiles({filesrgbcrop.name});
filesrgbcrop = filesrgbcrop(ndx1);

[~,ndx2] = natsortfiles({filesbincrop.name});
filesbincrop=filesbincrop(ndx2);
nn=0;
centroids=0;
for crop=1:length(filesrgbcrop)
%for crop=1:3
    filesrgbcrop(crop).name;
    im=imread([impresionrgb filesrgbcrop(crop).name]);
    filesbincrop(crop).name;
    im2=imread([impresionmul filesbincrop(crop).name]);
    
    [L, Ne]=bwlabel(im2);
    propied= regionprops(L);
    s=find([propied.Area]>900);
    fprintf('hoja = %s \n', filesrgbcrop(crop).name);
    for n=1:size(s,2)
        h= propied(s(n)).BoundingBox;
        q=imcrop(im2,h);
        r=imcrop(im,h);
        %imshow(r);
        nn=nn+1;
        perimetro=regionprops(q,'Perimeter');
%         fprintf('perimetro =%.2f \n',perimetro.Perimeter);
        area12=regionprops(q,'Area');
%         fprintf('Area =%.2f \n',area12.Area);
        excentricidad1=regionprops(q,'Eccentricity');
%         fprintf('excentricidad =%.2f \n',excentricidad1.Eccentricity);
        areaff=regionprops(q,'FilledArea');
        % fprintf('areaff =%.2f \n',areaff.FilledArea);
        alto=regionprops(q,'MajorAxisLength');
%         fprintf('alto =%.2f \n',alto.MajorAxisLength);
        ancho=regionprops(q,'MinorAxisLength');
%         fprintf('ancho =%.2f \n',ancho.MinorAxisLength);
        stat = regionprops(q,'Centroid');
%         fprintf('centroid =%.2f \n',stat.Centroid);
        centroids = cat(1, stat.Centroid);
         %[ promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB ] = extractMeanCImgRGB( im, closeBW);
        matriz{crop,1}=  filesrgbcrop(crop).name;
        matriz{crop,2}=  area12.Area;
        matriz{crop,3}= perimetro.Perimeter;  
        matriz{crop,4}=excentricidad1.Eccentricity;
        matriz{crop,5}=areaff.FilledArea;
        matriz{crop,6}=alto.MajorAxisLength;
        matriz{crop,7}=ancho.MinorAxisLength;        
        matriz{crop,8}=centroids(:,1);
        matriz{crop,9}=centroids(:,2);
    end
%           fprintf('perimetro =%.2f \n',perimetro.Perimeter);  
%           fprintf('Area =%.2f \n',area12.Area);
end
xlRange = 'A2';
xlswrite(archivo,matriz,sheet,xlRange);