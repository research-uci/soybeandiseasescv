function [ ] = objectDetection3( imageNameFR, imageNameROI, imageNameSilhouetteN, imageNameRemoved)

% ########################################################################
% Project AUTOMATIC DETECTION OF SOYBEAN DISEASES USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%
% OUTPUTS= imageNameSilhouetteN, imageNameRemoved
% Receive a segmented image in black and white, this is used as
% mask to detect objects. The procedure consists of detecting
% the pixel regions and cut out the objects to separate them into
% smaller images

%% reading image with background removed
IFR=imread(imageNameFR);
ImROI=imread(imageNameROI);


%% Binarize silhouette with background removed
threshold=graythresh(IFR);
IFRB1=im2bw(IFR,threshold); 

%% Labeling connected elements
[ObjectList Ne]=bwlabel(IFRB1);

%% Calculate properties of the objects in the image
obJectProperties= regionprops(ObjectList);

%% Search for pixel areas corresponding to objects
selection=find([obJectProperties.Area]);

%% get coordinates of areas
objectCounter=0; % objects count
rectangleNumber='';
for n=1:size(selection,2)
    objectCounter=objectCounter+1;
    coordinatesToPaint=round(obJectProperties(selection(n)).BoundingBox);
    %% clipping images
    ISilhouetteROI = imcrop(IFRB1,coordinatesToPaint);
    IBackgroundR = imcrop(ImROI,coordinatesToPaint);
    %% Detection of the rectangle number     
        outputSilhouetteN=strcat(imageNameSilhouetteN, rectangleNumber, int2str(objectCounter),'.jpg');
        outputRemoved=strcat(imageNameRemoved, rectangleNumber, int2str(objectCounter),'.jpg');

    %% guarda las imagenes recortadas, tanto la ROI como la silueta de cada objeto
    imwrite(ISilhouetteROI,outputSilhouetteN,'jpg');
    imwrite(IBackgroundR,outputRemoved,'jpg');    
end % fin de ciclo

end

