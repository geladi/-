function g = gaussian_filter( sigma)
 
% 功能：生成一维高斯滤波器
% 输入：
% sigma – 高斯滤波器的标准差
% 输出：
% g – 高斯滤波器

   sample = 7.0/2.0;

n = 2*round(sample * sigma)+1;
 
x=1:n;
x=x-ceil(n/2);
 
g = exp(-(x.^2)/(2*sigma^2))/(sigma*sqrt(2*pi));
