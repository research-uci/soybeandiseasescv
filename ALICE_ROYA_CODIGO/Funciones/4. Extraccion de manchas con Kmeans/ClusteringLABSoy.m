function [output_args] =  ClusteringLABSoy(nClusteres, nombreImagen, nombreImagenSegmentar, nombreImagenSalida,numeroRecorte)
% Asume las imagenes recortadas desde una fuente

%% Inicio de segmentacion k-means
IOrig = imread(nombreImagenSegmentar);
% --------------------------
h = fspecial('average', [5 5]);
ISh = imfilter(IOrig, h);
% --------------------------

% crea una transformacion de color RGB a L*a*b
cform = makecform('srgb2lab');
lab_ISh = applycform(ISh,cform); % aplica transformacoinacion de color independiente del dispositivo


ab = double(lab_ISh(:,:,2:3));
nfilas = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nfilas*ncols,2); %cambia la figura 


% repetir agrupamiento 3 veces para evitar un mínimo local
[cluster_idx cluster_center] = kmeans(ab,nClusteres,'distance','sqEuclidean', 'Replicates',3);

pixel_etiqueta = reshape(cluster_idx,nfilas,ncols);


%% crear imagenes

segmented_images = cell(1,3);
imagenFinal= cell(1,3);
rgb_label = repmat(pixel_etiqueta,[1 1 3]);

%imagenFinal;
%% Armar imagenes de los clusteres y guardarlas en archivos
for k = 1:nClusteres
    color = ISh;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
    
    %% nombre de imagen, eliminar .png
    newStr = erase(nombreImagen,".png");
    
    %% Almacenar en archivos las imagenes de clusteres
    extension=strcat(numeroRecorte,'C',strcat(int2str(k),'.png'));%'.jpg'
    nombreImagenCluster=strcat(nombreImagenSalida,extension);
    
    fprintf('imagen custer-> %s \n',nombreImagenCluster);
    imwrite(segmented_images{k},nombreImagenCluster,'png');%'jpg'
    
end

end

