% function [ ] = saveClassFeatures( nombreArchivo, filaAgregar)
function [ ] = saveAVDefCalyx2( nombreArchivo, filaAgregar)
% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
fileIDTest = fopen(nombreArchivo,'r'); %el hander para saber si existe
fileID = fopen(nombreArchivo,'a'); %abre el archivo para agregar datos
  

if (fileIDTest==-1)
    %% Es primera vez
    %Si se agregan mas campos, se debe agregar su cabecera
     filaCabecera=sprintf('imagen, numeroROI, contadorObjetos, promedioRGB_R, promedioRGB_G, promedioRGB_B, desviacionRGB_R, desviacionRGB_G, desviacionRGB_B, promedioLAB_L, promedioLAB_A, promedioLAB_B, desviacionLAB_L, desviacionLAB_A, desviacionLAB_B, promedioHSV_H, promedioHSV_S, promedioHSV_V, desviacionHSV_H, desviacionHSV_S, desviacionHSV_V, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, x, y, w, h, clasificacion');
%      filaCabecera=sprintf('Image,Mancha,promedioH,promedioS,promedioV,desviacionH,desviacionS,desviacionV,AreaROI,PerimetroROI,EjeMayorROI,EjeMenorROI,CircROI,ARROI,RoundROI,ExcentricidadROI,NumberPixelsROI,w,h,x,y');
    fprintf('CREANDO ARCHIVO DE CARACTERISTICAS\n');
    fprintf(fileID,'%s \n',filaCabecera);% agrega la cabecera
    fprintf(fileID,'%s',filaAgregar);

else
    fprintf('AGREGANDO DATOS AL ARCHIVO DE CARACTERISTICAS\n');
    fclose(fileIDTest);% cierra el handler de lectura, dado que el archivo existe
    fprintf(fileID,'%s',filaAgregar);
    
end %fin verificacion si el archivo existe
    
    fclose(fileID);    %cierre del archivo para escritura

end %guardarArchivoVector

