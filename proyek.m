clc;clear;

%% INPUT
% ---------------------
% % Sapu
I = imread('sapuRebah1.png');
% I = imread('sapuRebah4.png');

% % Bukan Sapu
% I = imread('tongkat.jpg');
% I = imread('tongkatEkstrim.jpg');
% I = imread('sendok.jpg');
% I = imread('pemandangan.jpg');
% I = imread('cikrak.jpg');

% % Gagal
% I = imread('sapuRebah2.png');
% I = imread('sapuBerdiri.png');
% I = imread('sapuRebah.png');
% --------------

figure;imshow(I);
Iasli = I;

% CONTRAST
% ---------------------
I = imadjust(I,[0.2 0.6]);
% figure;imshow(I);

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

%% Cari Garis terpanjang
% ---------------------
I = rgb2gray(I);
I = imbinarize(I);
I = imcomplement(I);
% Idou = Iasli;
% Idou = imadjust(Idou,[0.2 0.6]);

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

%% Atas
atasX = xy_long(1,1);
atasY = xy_long(1,2);
atasMinX = (atasX-(max_len/7));
atasMinY = (atasY-(max_len/7));
if atasMinX <= 1
    atasMinX = 1;
end
if atasMinY <= 1
    atasMinY = 1;
end
IcropAtas = imcrop(Iasli, [atasMinX atasMinY terpanjang/4 terpanjang/4]);

% figure;imshow(IcropAtas);
% IcropAtas = imadjust(IcropAtas,[0.1 1]);
% IcropAtas = rgb2gray(IcropAtas);
% IcropAtas = imbinarize(IcropAtas);
% IcropAtas = imcomplement(IcropAtas);
% 
% [panjangATAS, lebarATAS, zATAS] = size(IcropAtas);
% if (panjangATAS > lebarATAS)
%     terpanjangATAS = panjangATAS;
% else    
%     terpanjangATAS = lebarATAS;
% end
% minimalpnjgATAS = double(terpanjangATAS/10);
% pnjgMedFiltATAS = int32(terpanjangATAS/50);
% 
% IcropAtas = medfilt2(IcropAtas, [pnjgMedFiltATAS pnjgMedFiltATAS]);
% figure;imshow(IcropAtas);

% deteksiAtas = bwskel(IcropAtas);
% figure;imshow(deteksiAtas);

%% Bawah
bawahX = xy_long(2,1);
bawahY = xy_long(2,2);
bawahMinX = (bawahX-(max_len/7));
bawahMinY = (bawahY-(max_len/7));
if bawahMinX <= 1
    bawahMinX = 1;
end
if bawahMinY <= 1
    bawahMinY = 1;
end
IcropBawah = imcrop(Iasli, [bawahMinX bawahMinY terpanjang/4 terpanjang/4]);

% figure;imshow(IcropBawah);
% IcropBawah = imadjust(IcropBawah,[0.1 1]);
% IcropBawah = rgb2gray(IcropBawah);
% IcropBawah = imbinarize(IcropBawah);
% IcropBawah = imcomplement(IcropBawah);
% 
% [panjangBAWAH, lebarBAWAH, zBAWAH] = size(IcropBawah);
% if (panjangBAWAH > lebarBAWAH)
%     terpanjangBAWAH = panjangBAWAH;
% else    
%     terpanjangBAWAH = lebarBAWAH;
% end
% minimalpnjgBAWAH = double(terpanjangBAWAH/10);
% pnjgMedFiltBAWAH = int32(terpanjangBAWAH/50);

% IcropBawah = medfilt2(IcropBawah, [pnjgMedFiltBAWAH pnjgMedFiltBAWAH]);
% figure;imshow(IcropBawah);

% deteksiBawah = bwskel(IcropBawah);
% figure;imshow(deteksiBawah);

figure;
subplot(1,2,1), imshow(IcropAtas)
subplot(1,2,2), imshow(IcropBawah)

%% Deteksi
[Ax, Ay, Az] = size(IcropAtas);
[Bx, By, Bz] = size(IcropBawah);

ukurX = Ax;
ukurY = Ay;
if (Ax > Bx)
    ukurX = Bx;
end
if (Ay > By)
    ukurY = By;
end
targetSize = [ukurX ukurY];

rAtas = centerCropWindow2d(size(IcropAtas),targetSize);
Iatas = imcrop(IcropAtas, rAtas);

rBawah = centerCropWindow2d(size(IcropBawah),targetSize);
Ibawah = imcrop(IcropBawah, rBawah);

[ssimval,ssimmap] = ssim(Iatas,Ibawah);
figure;
imshow(ssimmap,[]);
% title(num2str(ssimval));

mirip = ssimval;
if (mirip < 0.3)
    title("Sapu : "+mirip);
else
    title("Bukan Sapu : "+mirip);
end




















% % bawah
% bawahX = xy_long(2,1);
% bawahY = xy_long(2,2);
%     garisBawah1 = bawahY - int32(terpanjang*(0.05));
%     plot(bawahX,garisBawah1,'x','LineWidth',2,'Color','red');
    % Ke kiri
%     copyXi = bawahX;
%     while (abs(Idou(copyXi, garisBawah1) - Idou(copyXi-1, garisBawah1)) < 15)
%         copyXi = copyXi - 1;
%     end
%     plot(copyXi,garisBawah1,'x','LineWidth',2,'Color','cyan');
    
    % Ke kanan
%     copyXa = bawahX;
%     while (abs(Idou(copyXa, garisBawah1) - Idou(copyXa+1, garisBawah1)) < 15)
%         copyXa = copyXa + 1;
%     end
%     plot(copyXa,garisBawah1,'x','LineWidth',2,'Color','cyan');
% 
%     garisBawah2 = bawahY - int32(terpanjang*0.1);
%     plot(bawahX,garisBawah2,'x','LineWidth',2,'Color','red');
%     % Ke kiri
%     copyXi2 = bawahX;
%     while Idou(copyXi2, garisBawah2) == 0
%         copyXi2 = copyXi2 - 1;
%     end
%     plot(copyXi2,garisBawah2,'x','LineWidth',2,'Color','cyan');
%     
%     % Ke kanan
%     copyXa = bawahX;
%     while Idou(copyXa, garisBawah2) == 0
%         copyXa = copyXa + 1;
%     end
%     plot(copyXa,garisBawah2,'x','LineWidth',2,'Color','cyan');  
    




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










