function [ ] = diferencia(nombreMascaraExp, nombreMascaraSoft, nombreMascaraFinal)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################

IExp=imread(nombreMascaraExp);
ISoft=imread(nombreMascaraSoft);

%% 
nivel=graythresh(IExp);
IBExp=im2bw(IExp,nivel);

%% 
nivel=graythresh(ISoft);
IBSoft=im2bw(ISoft,nivel);
... aqui salta el error porque las dimensiones no son las mismas..
... se hallan las dimensiones de la imagen binaria de experto
 [y1,x1] = size(IBExp);
... se crea una nueva variable donde; se toma la imagen IBSoft y se le hace el resize
    ... con respecto a la imagen experto
      ... llamandola IBSoft2
 IBSoft2 = imresize(IBSoft,[y1 x1]); 
................................................................

final=bitxor(IBExp,IBSoft2);
imwrite(final,nombreMascaraFinal,'jpg');

end %funcion
