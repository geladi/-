function idxLocalMax=cannyFindLocalMaxima(direction,ix,iy,mag)
%功能：实现非极大抑制功能
%输入：direction-4个方向
%      ix-图像在x方向滤波结果
%      iy-图像在y方向滤波结果
%      mag-滤波幅度

[m,n,o]=size(mag);
%根据梯度幅度确定各点梯度的方向，并找出四个方向可能存在的边缘点的坐标。
switch direction
    case 1
        idx=find((iy<=0&ix>-iy)|(iy>=0&ix<-iy));
    case 2
        idx=find((ix>0&-iy>=ix)|(ix<0&-iy<=ix));
    case 3
        idx=find((ix<=0&ix>iy)|(ix>=0&ix<-iy));
    case 4
        idx=find((iy<0&ix<=iy)|(iy>0&ix>=iy));
end
%去除图像边界以外点
if~isempty(idx)
    v=mod(idx,m);
    extIdx=find(v==1|v==0|idx<=m|idx>(n-1)*m);
    idx(extIdx)=[];
end
%求出可能的边界点的滤波值
ixv=ix(idx);
iyv=iy(idx);
gradmag=mag(idx);
%计算4个方向的梯度幅度
switch direction
    case 1
        d=abs(iyv./ixv);
        gradmag1=mag(idx+m).*(i-d)+mag(idx+m-1).*d;
        gradmag2=mag(idx-m).*(i-d)+mag(idx-m+1).*d;
    case 2
         d=abs(ixv./iyv);
        gradmag1=mag(idx+1).*(i-d)+mag(idx+m-1).*d;
        gradmag2=mag(idx-1).*(i-d)+mag(idx-m+1).*d;
    case 3
        d=abs(ixv./iyv);
        gradmag1=mag(idx-1).*(i-d)+mag(idx-m-1).*d;
        gradmag2=mag(idx+1).*(i-d)+mag(idx+m+1).*d;
    case 4
        d=abs(iyv./ixv);
        gradmag1=mag(idx-m).*(i-d)+mag(idx-m-1).*d;
        gradmag2=mag(idx+m).*(i-d)+mag(idx+m+1).*d;
end
%进行非极大抑制
idxLocalMax=idx(gradmag>=gradmag1&gradmag>=gradmag2);
