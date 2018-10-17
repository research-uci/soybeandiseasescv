function []= manchas_analisis(pathresultadofondoremovido, pathresultadomagentabin, formato, formato2)
filesrgb=dir([pathresultadofondoremovido, formato2]);
filesbinmag=dir([pathresultadomagentabin, formato2]);
scale=0.5;
nn=0; 
 [~,ndx1] = natsortfiles({filesrgb.name}); 
 [~,ndx2] = natsortfiles({filesbinmag.name}); 
 
  filesrgb = filesrgb(ndx1);
  filesbinmag = filesbinmag(ndx2);
  
  for j=1:length(filesrgb)
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
    
    for n=1:size(s,2)
        h= propied(s(n)).BoundingBox;  
        q=imcrop(imag_bw,h); %mancha binaria
       %figure, imshow (q);
       %fprintf(' n= %d \n',n);
       nn=nn+1;
    end
    
    fprintf(' hoja= %s con cantidad= %d \n',filesrgb(j).name,n);   
   
    
  end
  
   fprintf(' Cantidad= %d \n',nn);   
