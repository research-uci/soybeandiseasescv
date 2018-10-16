function [] = eliminar(j,y)
%funcion de copiar
    for k=1:length(j)
        basefilename=j(k).name;
        fullfilename=fullfile(y, basefilename);
        fprintf(1, 'Eliminando %s\n', fullfilename);
        delete(fullfilename);
    end
    fprintf('Elementos eliminados %s\n', y);
end