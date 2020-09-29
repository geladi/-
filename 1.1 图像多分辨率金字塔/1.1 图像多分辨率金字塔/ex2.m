% 调用金子塔类
hgausspymd = video.Pyramid;
% 设定金字塔分解的层数为2
hgausspymd.PyramidLevel = 2;
% 读入图像
x = imread('qingdao.jpg');
% 执行金字塔分解
y = step(video.Pyramid, x);
% 显示结果
figure, imshow(x); title('原始图像');
x1=mat2gray(double(y));
figure, imshow(x1);
title('Decomposed Image');