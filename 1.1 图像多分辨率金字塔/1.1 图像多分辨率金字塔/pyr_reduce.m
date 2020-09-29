function [ imgout ] = pyr_reduce( img )
% 功能：计算图像的高斯金字塔
% 输入：img-灰度图像；
% 输出：imgout-分解后的金子塔图像数组

% 生成高斯核
kernelWidth = 5; 
cw = .375; 
ker1d = [.25-cw/2 .25 cw .25 .25-cw/2];
kernel = kron(ker1d,ker1d');
 
img = im2double(img);
sz = size(img);
imgout = [];
 
% 产生图像的高斯金字塔
for p = 1:size(img,3)
    img1 = img(:,:,p);
    imgFiltered = imfilter(img1,kernel,'replicate','same');
    imgout(:,:,p) = imgFiltered(1:2:sz(1),1:2:sz(2));
end
 
end
