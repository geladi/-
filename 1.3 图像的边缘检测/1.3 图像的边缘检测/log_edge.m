function e=log_edge(a, sigma)
%功能：实现LoG算子提取边缘点
%输入：a-灰度图像
%      sigma-滤波器参数
%输出：e-边缘图像

%产生同样大小的边缘图像e，初始化为0.
[m,n]=size(a);
e=repmat(logical(uint8(0)),m,n);
rr=2:m-1;cc=2:n-1;
%选择点数为奇数的滤波器的尺寸fsize>6*sigma;
fsize=ceil(sigma*3)*2+1;
%产生LoG滤波器
op=fspecial('log',fsize,sigma);
%将LoG滤波器的均值变为0.
op=op-sum(op(:))/prod(size(op));
%利用LoG算子对图像滤波
% filter2二维数字滤波器
b=filter2(op,a);
%设置过零检测的门限
%寻找滤波后的过零点，+-和-+表示水平方向从左到右和从右到左过零
%[+-]'和[-+]'表示垂直方向从上到下和从下到上过零
%这里我们选择边缘点为值为负的点
thresh=.75*mean2(abs(b(rr,cc)));
%[- +]的情况
[rx,cx]=find(b(rr,cc)<0&b(rr,cc+1)>0&abs(b(rr,cc)-b(rr,cc+1))>thresh) 
e((rx+1)+cx*m)=1;
%[- +]的情况
[rx,cx]=find(b(rr,cc-1)>0&b(rr,cc)<0&abs(b(rr,cc-1)-b(rr,cc))>thresh) 
e((rx+1)+cx*m)=1;
%[- +]的情况
[rx,cx]=find(b(rr,cc)<0&b(rr+1,cc)>0&abs(b(rr,cc)-b(rr+1,cc))>thresh) 
e((rx+1)+cx*m)=1;
%[- +]的情况
[rx,cx]=find(b(rr-1,cc)>0&b(rr,cc)<0&abs(b(rr-1,cc)-b(rr,cc))>thresh) 
e((rx+1)+cx*m)=1;
%某些情况下LoG滤波结果可能正好为0，下面考虑这种情况：
 %寻找滤波后的过零
%+0-和-0+表示水平方向从左到右和从右到左过零
%[+0-]'和[-0+]'表示垂直方向从上到下和从下到上过零
%边缘正好位于滤波值为零点上
[rz,cz]=find(b(rr,cc)==0);
if~isempty(rz)
%零点的线性坐标
zero=(rz+1)+cz*m;   
%[-0+]的情况
zz=find(b(zero-1)<0&b(zero+1)>0&abs(b(zero-1)-b(zero+1))>2*thresh);
e(zero(zz))=1;
%[+0-]'的情况
zz=find(b(zero-1)>0&b(zero+1)<0&abs(b(zero-1)-b(zero+1))>2*thresh);
e(zero(zz))=1;
%[-0+]的情况
zz=find(b(zero-m)<0&b(zero+m)>0&abs(b(zero-1)-b(zero+1))>2*thresh);
e(zero(zz))=1;
%[+0-]'的情况
zz=find(b(zero-m)>0&b(zero+m)<0&abs(b(zero-1)-b(zero+1))>2*thresh);
e(zero(zz))=1;
end
