function points = harrislaplace(img)
% 功能：提取Harris-Laplace角点
% 输入：img-输入的RGB图像
% 输出：points-检测出的角点矩阵
% 参考文献：
% ==========
% K. Mikolajczyk and C. Schmid. Scale & affine invariant interest point % detectors.
% International Journal of Computer Vision, 2004
    
% 图像参数

    img         = double(img(:,:,1));
    img_height  = size(img,1);
    img_width   = size(img,2);
 
    % 尺度参数
    sigma_begin = 1.5;
    sigma_step  = 1.2;
    sigma_nb    = 13;
    sigma_array = (sigma_step.^(0:sigma_nb-1))*sigma_begin;
 
 
    % 第一部分：提取Harris角点
    harris_pts = zeros(0,3);
    for i=1:sigma_nb
 
        % 尺度
        % 积分尺度
s_I = sigma_array(i);   
        % 微分尺度
s_D = 0.7*s_I;          
 
        
% 微分掩模
        x  = -round(3*s_D):round(3*s_D);
        dx = x .* exp(-x.*x/(2*s_D*s_D)) ./ (s_D*s_D*s_D*sqrt(2*pi));
        dy = dx';
 
        % 图像微分
        Ix = conv2(img, dx, 'same');
        Iy = conv2(img, dy, 'same');
 
        % 自相关矩阵
        g   = fspecial('gaussian',max(1,fix(6*s_I+1)), s_I);
        Ix2 = conv2(Ix.^2, g,  'same');
        Iy2 = conv2(Iy.^2, g,  'same');
        Ixy = conv2(Ix.*Iy, g, 'same');
 
        k = 0.06; cim = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2; 
       
 % 查询邻域极值
        [l,c,max_local] = findLocalMaximum(cim,3*s_I); 
        
% 设定局部邻域极值阈值
        t = 0.2*max(max_local(:));
 
        % 查找大于邻域极值阈值的点
        [l,c] = find(max_local>=t);
 
        n = size(l,1);
        harris_pts(end+1:end+n,:) = [l,c,repmat(i,[n,1])];
    end
 
 
    %%%%%%第二部分: LAPLACE变换%%%%%%
    % 计算尺度归一化Laplace算子
    laplace_snlo = zeros(img_height,img_width,sigma_nb);
    for i=1:sigma_nb
        % 尺度
s_L = sigma_array(i);   
        laplace_snlo(:,:,i) = s_L*s_L*imfilter(img,fspecial('log', floor(6*s_L+1), s_L),'replicate');
    end
% 检测每个特征点在某一尺度LoG相应是否达到最大
    n   = size(harris_pts,1);
    cpt = 0;
    points = zeros(n,3);
    for i=1:n
        l = harris_pts(i,1);
        c = harris_pts(i,2);
        s = harris_pts(i,3);
        val = laplace_snlo(l,c,s);
        if s>1 && s<sigma_nb
            if val>laplace_snlo(l,c,s-1) && val>laplace_snlo(l,c,s+1)
                cpt = cpt+1;
                points(cpt,:) = harris_pts(i,:);
            end
        elseif s==1
            if val>laplace_snlo(l,c,2)
                cpt = cpt+1;
                points(cpt,:) = harris_pts(i,:);
            end
        elseif s==sigma_nb
            if val>laplace_snlo(l,c,s-1)
                cpt = cpt+1;
                points(cpt,:) = harris_pts(i,:);
            end
        end
    end
    points(cpt+1:end,:) = [];
    
       points(:,3) = 3*sigma_array(points(:,3));
       end
