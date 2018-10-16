function [ ] = coincidencia(nombreMascaraExp, nombreMascaraSoft, nombreMascaraFinal)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
IExp=imread(nombreMascaraExp);
ISoft=imread(nombreMascaraSoft);

%% 
%para que sean iguales las imagenes
[fA,cA,bA]= size(IExp);
    [fB,cB,bB]= size(ISoft);
    
    if fB ~= fA || cA ~= cB
        ISoft = imresize(ISoft, [fA cA]);
    end
    
nivel=graythresh(IExp);
IBExp=im2bw(IExp,nivel);

%% 
nivel=graythresh(ISoft);
IBSoft=im2bw(ISoft,nivel);
final=bitor(IBExp,IBSoft);
imwrite(final,nombreMascaraFinal,'jpg');


end %funcion