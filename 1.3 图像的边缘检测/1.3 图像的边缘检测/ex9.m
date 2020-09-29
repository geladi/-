% 读入并显示原始图像
I=imread('hehua.jpg');
grayI=rgb2gray(I);
figure,imshow(grayI)

% 利用单尺度形态学梯度进行边缘检测
se=strel('square',3);
grad=imdilate(grayI,se)-imerode(grayI,se);
figure,imshow(grad)

% 利用多尺度形态学梯度进行边缘检测
se1=strel('square',1);
se2=strel('square',3);
se3=strel('square',5);
se4=strel('square',7);
grad1=imerode((imdilate(grayI,se2)-imerode(grayI,se2)),se1);
grad2=imerode((imdilate(grayI,se3)-imerode(grayI,se3)),se2);
grad3=imerode((imdilate(grayI,se4)-imerode(grayI,se4)),se3);
multiscaleGrad=(grad1+grad2+grad3)/3;
figure,imshow(multiscaleGrad)
