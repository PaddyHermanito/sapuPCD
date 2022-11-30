clc;clear;
I = imread('sapu.png');
I = rgb2gray(I);
I = edge(I,'Prewitt');
I = bwmorph(I,'remove');
figure;imshow(I); hold on;
J =im2bw(

%plot