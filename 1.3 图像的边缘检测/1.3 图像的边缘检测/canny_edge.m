function e=canny_edge(a,sigma)
%功能：实现Canny算子边缘检测
%输入：a- m×m的灰度图像
%     sigma-标准差
%输出：e-检测出的边缘
[m,n]=size(a);
a=double(a);
rr=2:m-1;cc=2:n-1;
%%%%%%%初始化边缘矩阵%%%%%%
e=repmat(logical(uint8(0)),m,n);
%设定高斯函数消失门限
GaussianDieOff=-0001; 
%用于计算边缘门限
PercentOfPixelsNotEdge=-7 
%设置两个门限的比例
ThresholdRatio=-4; 
%%%%%%首先设计高斯滤波器和它的微分%%%%%%
%设定滤波器宽度
pw=1:30;
%计算方差
ssq=sigma*sigma;
%计算滤波子宽度
width=max(find(exp(-(pw.*pw)/(2*sigma*sigma))>GaussianDieOff));
t=(-width:width);
len=2*width+1;
%对每个像素左右各半位置的值进行平均
t3=[t-.5;t;t+.5];
%一维高斯滤波器
gau=sum(exp(-(t3.*t3)/(2*ssq))).'/(6*pi*ssq);
%高斯滤波器的微分
dgau=(-t.*exp(-(t.*t)/(2*ssq))/ssq);
ra=size(a,1);
ca=size(a,2);
ay=255*a;ax=255*a';
%利用高斯函数滤除噪声和用高斯算子的一阶微分对图像滤波合并为一个算子
h=conv(gau,dgau);
%产生x方向滤波
ax=conv2(ax,h,'same').';
%产生y方向滤波
ay=conv2(ay,h,'same').';
%计算滤波结果的幅度
mag=sqrt((ax.*ax)+(ay.*ay));
magmax=max(mag(:));
if magmax>0
   %对滤波幅度进行归一化
 mag=mag/magmax;
end
%%%%%%下面根据滤波幅度的概率密度计算滤波门限%%%%%%
%计算滤波结果的幅度的直方图
[counts,x]=imhist(mag,64);
%通过设定非边缘点的比例来确定高门限

highThresh=min(find(cumsum(counts)>PercentOfPixelsNotEdge*m*n))/64;
%设置低门限为高门限乘以比例因子
lowThresh=ThresholdRatio*highThresh;
thresh=[lowThresh highThresh];
%%%%%%下面进行非极大抑制%%%%%%
%%%%%%大于高门限的点归于强边缘图像%%%%%%
%%%%%%小于低门限的点归于弱门限图像%%%%%%
idxStrong=[];
for dir=1:4
    idxLocalMax=cannyFindLocalMaxima(dir,ax,ay,mag);
    idxWeak=idxLocalMax(mag(idxLocalMax)>lowThresh);
    e(idxWeak)=1;
    idxStrong=[idxStrong;idxWeak(mag(idxWeak)>highThresh)];
end
rstrong=rem(idxStrong-1,m)+1;
cstrong=floor((idxStrong-1)/m)+1;
%通过形态学算子将两幅图像的边缘进行连接
e=bwselect(e,cstrong,rstrong,8);
%对提取的边缘利用形态学算子细化
e=bwmorph(e,'thin',1);
