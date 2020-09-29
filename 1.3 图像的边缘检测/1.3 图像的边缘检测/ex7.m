% 输入图像，并将其转化成灰度图像
I=imread('qipan.jpg');
I=rgb2gray(I);
% 构造卷积核
F=[-1 0 0 -1 -1
     1 1 1 0 0];
% 进行卷积运算
A=conv2(double(I),double(F));
% 转换成8位无符号整型并显示
A=uint8(A);
imshow(A)
