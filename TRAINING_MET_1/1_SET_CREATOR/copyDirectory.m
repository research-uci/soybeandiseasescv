function [ ] = copyDirectory( tablaDSTArchivos, pathEntradaImagenesFuente, pathEntradaImagenesDestino)
% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
tamanoTablaArchivos=size(tablaDSTArchivos);
TotalFilas=tamanoTablaArchivos(1);

for(contadorRandom=1:1:TotalFilas)
    %% copiando desde imagenes originales a test
    archivoCopiarFuente=strcat(pathEntradaImagenesFuente,tablaDSTArchivos(contadorRandom).name)
    archivoCopiarDestino=strcat(pathEntradaImagenesDestino,tablaDSTArchivos(contadorRandom).name)
    
    %% comando de copia
    comando = { 'cp','-f',archivoCopiarFuente, archivoCopiarDestino};
    command=strjoin(comando);
    [status,cmdout] = system(command);    
end % (contadorRandom=1:1:TotalFilas)




end

