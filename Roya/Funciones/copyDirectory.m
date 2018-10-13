function [ ] = copyDirectory(tablaArchivos, pathEntradaImagenesFuente, pathEntradaImagenesDestino)
    tamanoTablaArchivos=size(tablaArchivos);
    TotalFilas=tamanoTablaArchivos(1);

    for(contadorRandom=1:1:TotalFilas)
        %% copiando desde imagenes originales a test
        archivoCopiarFuente=strcat(pathEntradaImagenesFuente,tablaArchivos(contadorRandom).name)
        archivoCopiarDestino=strcat(pathEntradaImagenesDestino,tablaArchivos(contadorRandom).name)

        %% comando de copia
        comando = { 'cp','-f',archivoCopiarFuente, archivoCopiarDestino};
        command=strjoin(comando);
        [status,cmdout] = system(command);    

    end

end

