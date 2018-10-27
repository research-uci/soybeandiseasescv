home          = strcat(pwd,'/');
direccion     = strcat(home,'Escritorio/pruebaTrainingTest/');
paraTest     = strcat(direccion,'paraTest/');
paraTraining     = strcat(direccion,'paraTraining/');
imageSource  = strcat(home,'Escritorio/SOURCE/');
% se toman las imagenes de paraTest y se copian a source de nuevo
imagejpg3 = dir(fullfile(paraTest,'*.jpg'));
counter = length(imagejpg3);
for aa=1 : counter
    name=imagejpg3(aa).name; % toma nombre en paraTest
    filename = strcat(paraTest,name); % se tiene su direccion desde paraTest
    copyfile(filename,imageSource); % se copia desde filename a imagesource
end

imagejpg4 = dir(fullfile(paraTraining,'*.jpg'));
counter2  = length(imagejpg4);
for bb = 1 : counter2
    name=imagejpg4(bb).name; % toma nombre en paraTraining
    filename2 = strcat(paraTraining,name); % se tiene su direccion desde paraTraining
    copyfile(filename2,imageSource);  % se copia desde filename a imagesource
end

