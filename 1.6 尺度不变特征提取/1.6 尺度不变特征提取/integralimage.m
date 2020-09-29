function intim = integralimage(im)
% 功能：计算输入的灰度图像的积分图像
% 输入：im-灰度图像
% 输出：intim-积分图像
    if ndims(im) == 3
        error('Image must be greyscale');
    end
 %将图像矩阵的数据类型转换成双精度型，便于后续运算
    if strcmp(class(im),'uint8')  
        im = double(im);
    end
    
    intim = cumsum(cumsum(im,1),2);
