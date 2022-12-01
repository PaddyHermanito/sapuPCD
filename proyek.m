clc;clear;
I = imread('sapu.png');
I = rgb2gray(I);
I = edge(I,'Prewitt');
I = bwmorph(I,'remove');
figure;imshow(I); hold on;

[akumulator, theta, rho] = hough(I);
puncak = houghpeaks(akumulator, 9,'Threshold',25);
garis2nya= houghlines(I, theta, rho, puncak,'MinLength',100);

max_len = 0;
for k = 1:length(garis2nya)
   xy = [garis2nya(k).point1; garis2nya(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','cyan');

   len = norm(garis2nya(k).point1 - garis2nya(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
      plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');
      plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
      plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
   end
end



