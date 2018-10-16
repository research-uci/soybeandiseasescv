function []=spotsegmentacion(pathPrincipal,pathresultadorgb,pathresultadobin,formato2,formato)

filesrgbcrop=dir([pathresultadorgb, formato2]);
filesbincrop=dir([pathresultadobin, formato2]);

pathFolder3='4_resultado_mancha_rgb/';
pathFolder4='5_resultado_mancha_bin/';
pathFolder5='6_result/';

impresionrgb=strcat(pathPrincipal,pathFolder3);
impresionbin=strcat(pathPrincipal,pathFolder4);
impresionmul=strcat(pathPrincipal,pathFolder5);

if ~exist(impresionrgb, 'dir')
        mkdir(impresionrgb);
    else
        fprintf(' ya ha sido creada= %s \n',impresionrgb);
        filePattern = fullfile(impresionrgb, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,impresionrgb);
        end
end

if ~exist(impresionbin, 'dir')
        mkdir(impresionbin);
    else
        fprintf(' ya ha sido creada= %s \n',impresionbin);
        filePattern = fullfile(impresionbin, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,impresionbin);
        end
end

if ~exist(impresionmul, 'dir')
        mkdir(impresionmul);
    else
        fprintf(' ya ha sido creada= %s \n',impresionmul);
        filePattern = fullfile(impresionmul, '*.jpg');
        theFiles=dir(filePattern);
        if ~isempty(theFiles)
            eliminar(theFiles,impresionmul);
        end
end

[~,ndx1] = natsortfiles({filesrgbcrop.name}); 
filesrgbcrop = filesrgbcrop(ndx1);

[~,ndx2] = natsortfiles({filesbincrop.name});
filesbincrop=filesbincrop(ndx2);

    for crop=1:length(filesrgbcrop)
        filesrgbcrop(crop).name;
        im=imread([pathresultadorgb filesrgbcrop(crop).name]); 
        filesbincrop(crop).name;
        im2=imread([pathresultadobin filesbincrop(crop).name]);

        [bw,rgb]=manchasegmentada(im);
        imwrite(uint8(rgb),[impresionrgb,filesrgbcrop(crop).name]);
        imwrite((bw),[impresionbin,filesbincrop(crop).name]); 

        result=immultiply(bw,im2);  
        
        imwrite((result),[impresionmul,filesbincrop(crop).name]); 
    end
    
    sms = 'La ejecucion ha finalizado, revise los resultados en:';

    fprintf('%s\n %s \n %s \n %s \n',sms, impresionrgb, impresionbin,impresionmul);   %imprime un mensaje en la consola
    
    %Extraccion de caracteristicas segun el metodo propuesto
    manchatest(pathPrincipal,impresionrgb,impresionmul,formato2,formato)
    
    
end