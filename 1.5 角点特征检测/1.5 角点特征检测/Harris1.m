function [posr, posc]=Harris1(in_image,a)
% 功能：检测图像的Harris角点
% 输入：in_image－待检测的RGB图像数组
%       a－角点参数响应，取值范围为：0.04～0.06
% 输出：posr－所检测出角点的行坐标向量
%       posc－所检测出角点的列坐标向量

% 将RGB图像转化成灰度图像
in_image=rgb2gray(in_image);        
% unit8型转化为双精度double64型
ori_im=double(in_image); 
           
%%%%%%计算图像在x、y 两个方向的梯度%%%%%%
% x方向梯度算子模板
fx = [-1 0 1];                       
% x方向滤波
Ix = filter2(fx,ori_im);               
% y方向梯度算子
fy = [-1;0;1];                       
% y方向滤波
Iy = filter2(fy,ori_im);  
              
%%%%%%计算两个方向的梯度乘积%%%%%%
Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;

%%%%%%使用高斯函数对梯度乘积进行加权%%%%%%
% 产生7*7的高斯窗函数，sigma=2
h= fspecial('gaussian',[7 7],2);        
Ix2 = filter2(h,Ix2);
Iy2 = filter2(h,Iy2);
Ixy = filter2(h,Ixy);

%%%%%%计算每个像元的Harris响应值%%%%%%
[height,width]=size(ori_im);
R = zeros(height,width);                            
% 像素(i,j)处的Harris响应值
for i = 1:height
    for j = 1:width
        M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)];             
        R(i,j) = det(M)-a*(trace(M))^2;          
    end
end

%%%%%%去掉小于阈值的Harris响应值%%%%%%
Rmax=max(max(R));
%  阈值
t=0.01* Rmax;                               
for i = 1:height
for j = 1:width
if R(i,j)<t
  R(i,j) = 0;
  end
end
end

%%%%%%进行3×3邻域非极大值抑制%%%%%%      
% 进行非极大抑制，窗口大小3*3
corner_peaks=imregionalmax(R);          
countnum=sum(sum(corner_peaks));

%%%%%%显示所提取的Harris角点%%%%%% 
% posr是用于存放行坐标的向量
[posr, posc] = find(corner_peaks== 1);       
% posc是用于存放列坐标的向量
figure
imshow(in_image)
hold on
for i = 1 : length(posr)
    plot(posc(i),posr(i),'r+');
end
