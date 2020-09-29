function [row,col,max_local] = findLocalMaximum(val,radius)
    % 功能：查找邻域极大值 
    % 输入：
    % val -NxM 矩阵；
    % radius –邻域半径；
    % 输出：
    % row –邻域极大值的行坐标；
    % col – 邻域极大值的列坐标；
    % max_local-邻域极大值。
  
    mask  = fspecial('disk',radius)>0;
    nb    = sum(mask(:));
    highest          = ordfilt2(val, nb, mask);
    second_highest   = ordfilt2(val, nb-1, mask);
    index            = highest==val & highest~=second_highest;
    max_local        = zeros(size(val));
    max_local(index) = val(index);
    [row,col]        = find(index==1);
 
end
