function points = gilles(im,o_radius)
    % 功能：提取Gilles斑点
    % 输入：
    %      im –输入的图像
    %      o_radius -斑点检测半径（可选）
    % 输出：
    %      points -检测出的斑点
    %
    % 参考文献：
    % S. Gilles, Robust Description and Matching of Images. PhD thesis,
    % Oxford University, Ph.D. thesis, Oxford University, 1988.
   
    im = im(:,:,1);
 
    % 变量
    if nargin==1
        radius = 10;
    else
        radius = o_radius;
end
% 建立掩模(mask)区域
    mask = fspecial('disk',radius)>0;
 
    % 计算掩模区域的局部熵值
    loc_ent = entropyfilt(im,mask);
 
    % 寻找局部最值
    [l,c,tmp] = findLocalMaximum(loc_ent,radius);
 
    % 超过阈值的斑点确定为所要提取的斑点
    [l,c]     = find(tmp>0.95*max(tmp(:)));
    points    = [l,c,repmat(radius,[size(l,1),1])];
 
end
