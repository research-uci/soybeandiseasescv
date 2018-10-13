function [hue,sat,int] = rgb_to_hsi(ima)

rChan = double(ima(:,:,1));
gChan = double(ima(:,:,2));
bChan = double(ima(:,:,3));
[length,width,~] = size(ima);
sat = zeros(length,width);
hue = sat;
int =(rChan + gChan + bChan)/300;
   for x = 1:size(ima,1)
      for y = 1:size(ima,2)
        sat(x,y) = 1 - (3/(rChan(x,y) + gChan(x,y) + bChan(x,y)))*min([rChan(x,y),gChan(x,y),bChan(x,y)]);
        hue(x,y) = acos((0.5*(2*rChan(x,y)-gChan(x,y)-bChan(x,y)))/sqrt((rChan(x,y)-gChan(x,y))^2 + (rChan(x,y)-bChan(x,y))*(gChan(x,y)-bChan(x,y))));
        if (bChan(x,y) > gChan(x,y))
            hue(x,y) = 360 -hue(x,y);
        end
      end
   end

hsi = cat(3,hue,sat,int);


end
