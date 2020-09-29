%读入图像并将其转换成灰度图像 
I=imread('tiantan.jpg');
I=rgb2gray(I);
% 生成高斯滤波器的核 
w=fspecial('gaussian',3,0.5);
size_a=size(I);

% 进行高斯滤波
g=imfilter(I,w,'conv','symmetric','same');

% 降采样 
t=g(1:2:size_a(1),1:2:size_a(2));

% 显示处理结果
imshow(I);
figure
imshow(t)