function [ pyr ] = genPyr( img, type, level )
%   功能： 产生图像的高斯金字塔或拉普拉斯金字塔
%   输入：img-灰度图像；
%         type-变换的类型：'gauss' or 'laplace'；
%         level-分解层数
%   输出：PYR-1*LEVEL 元胞数组

pyr = cell(1,level);
pyr{1} = im2double(img);
%%%%%%图像的金字塔化%%%%%%

%计算图像的高斯金字塔
for p = 2:level
    pyr{p} = pyr_reduce(pyr{p-1});
end
if strcmp(type,'gauss'), return; end
 
% 调整图像尺寸
for p = level-1:-1:1
    osz = size(pyr{p+1})*2-1;
    pyr{p} = pyr{p}(1:osz(1),1:osz(2),:);
end

% 计算图像的拉普拉斯金字塔
for p = 1:level-1
    pyr{p} = pyr{p}-pyr_expand(pyr{p+1});
end
 
end
