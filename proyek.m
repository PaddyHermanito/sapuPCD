clc;clear;

% INPUT
% ---------------------
% I = imread('sapuBerdiri.png');
% I = imread('sapuRebah.png');
I = imread('sapuRebah1.png');
% I = imread('sapuRebah4.png');
% I = imread('sendok.jpg');

% % Gagal
% I = imread('sapuRebah2.png');
% --------------

figure;imshow(I);
Iasli = I;

% CONTRAST
% ---------------------
I = imadjust(I,[0.2 0.6]);
figure;imshow(I);

% SIZING
% ---------------------
[panjang, lebar, z] = size(I);
if (panjang > lebar)
    terpanjang = panjang;
else    
    terpanjang = lebar;
end
minimalpnjg = double(terpanjang/10);
pnjgMedFilt = int32(terpanjang/150);

% PROCESS
% ---------------------
I = rgb2gray(I);
I = imbinarize(I);
I = imcomplement(I);
Idou = im2double(I);

I = medfilt2(I, [pnjgMedFilt pnjgMedFilt]);
% I = imfill(I, 'holes');
figure;imshow(I); hold on;

[akumulator, theta, rho] = hough(I);
puncak = houghpeaks(akumulator, 9,'Threshold',15);
garis2nya= houghlines(I, theta, rho, puncak,'MinLength',minimalpnjg);

max_len = 0;
for k = 1:length(garis2nya)
   xy = [garis2nya(k).point1; garis2nya(k).point2];

   len = norm(garis2nya(k).point1 - garis2nya(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
      plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');
      plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
      plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
   end
end

% PROCESS
% ---------------------
% % bawah
bawahX = xy_long(2,1);
bawahY = xy_long(2,2);
    garisBawah1 = bawahY - int32(terpanjang*(0.05));
    plot(bawahX,garisBawah1,'x','LineWidth',2,'Color','red');
    % Ke kiri
    copyXi = bawahX;
    while Idou(copyXi, garisBawah1) == 0
        copyXi = copyXi - 1;
    end
    plot(copyXi,garisBawah1,'x','LineWidth',2,'Color','cyan');
    
    % Ke kanan
    copyXa = bawahX;
    while Idou(copyXa, garisBawah1) == 0
        copyXa = copyXa + 1;
    end
    plot(copyXa,garisBawah1,'x','LineWidth',2,'Color','cyan');  

    garisBawah2 = bawahY - int32(terpanjang*0.1);
    plot(bawahX,garisBawah2,'x','LineWidth',2,'Color','red');
    % Ke kiri
    copyXi2 = bawahX;
    while Idou(copyXi2, garisBawah2) == 0
        copyXi2 = copyXi2 - 1;
    end
    plot(copyXi2,garisBawah2,'x','LineWidth',2,'Color','cyan');
    
    % Ke kanan
    copyXa = bawahX;
    while Idou(copyXa, garisBawah2) == 0
        copyXa = copyXa + 1;
    end
    plot(copyXa,garisBawah2,'x','LineWidth',2,'Color','cyan');  
    




% for i = 1:3
%     garisBawah1 = bawahY - int32(terpanjang*(0.05)*i);
%     plot(bawahX,garisBawah1,'x','LineWidth',2,'Color','red');
%     % Ke kiri
%     copyXi = bawahX;
%     while Idou(copyXi, garisBawah1) == 0
%         copyXi = copyXi - 1;
%     end
%     plot(copyXi,garisBawah1,'x','LineWidth',2,'Color','cyan');
%     
%     % Ke kanan
%     copyXa = bawahX;
%     while Idou(copyXa, garisBawah1) == 0
%         copyXa = copyXa + 1;
%     end
%     plot(copyXa,garisBawah1,'x','LineWidth',2,'Color','cyan');   
% end

% % atas
% bawahX = xy_long(1,1);
% bawahY = xy_long(1,2);
% for i = 1:3
%     garisBawah1 = bawahY + int32(terpanjang*(0.05)*i);
%     plot(bawahX,garisBawah1,'x','LineWidth',2,'Color','red');
%     % Ke kiri
%     copyXi = bawahX;
%     while Idou(copyXi, garisBawah1) == 0
%         copyXi = copyXi - 1;
%     end
%     plot(copyXi,garisBawah1,'x','LineWidth',2,'Color','cyan');
%     
%     % Ke kanan
%     copyXa = bawahX;
%     while Idou(copyXa, garisBawah1) == 0
%         copyXa = copyXa + 1;
%     end
%     plot(copyXa,garisBawah1,'x','LineWidth',2,'Color','cyan');   
% end










