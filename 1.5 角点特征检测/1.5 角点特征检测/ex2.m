%%%%%%读入图像并显示%%%%%%
I=imread('hua.jpg');
%将RGB图像转换成灰度图像
I=rgb2gray(I);         
 subplot(1,3,1);
 imshow(I);
 title('输入图像');

%%%%%%生成角点度量矩阵并进行调整%%%%%%
%生成角点度量矩阵
C = cornermetric(I,'Harris');       
C_adjusted = imadjust(C);
subplot(1,3,2);
imshow(C_adjusted);
title('角点矩阵');

%%%%%%寻找并显示Harris角点%%%%%%
corner_peaks = imregionalmax(C);
corner_idx = find(corner_peaks == true);
[r g b] = deal(I);
r(corner_idx) = 255;
g(corner_idx) = 255;
b(corner_idx) = 0;
RGB = cat(3,r,g,b);
subplot(1,3,3);
imshow(RGB);
title('检测出的Harris角点');
