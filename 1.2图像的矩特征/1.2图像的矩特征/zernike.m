function        [A_nm,zmlist,cidx,V_nm]        = zernike(img,n,m)
% 功能：计算输入图像的Zernike矩
% 输入：img-灰度图像
%       n-阶数
% 输出：V_nm-n阶的Zernike多项式，定义为在极坐标系中p，theta的函数
%       cidx-表示虚部值
%       A_nm-Zernike矩

if nargin>0
if nargin==1
        n=0;
end
d=size(img);                        
img=double(img);
% 取步长
xstep=2/(d(1)-1); 
ystep=2/(d(2)-1);
% 画方格
[x,y]=meshgrid(-1:xstep:1,-1:ystep:1); 
circle1= x.^2 + y.^2; 
% 提取符合circle1<=1的数
inside=find(circle1<=1); 
% 构造size（d）*size(d)的矩阵
mask=zeros(d);
% 构造size(inside)*size(inside)的全为1的矩阵赋值给mask（inside）
mask(inside)=ones(size(inside)); 
% 计算图像的复数表示
[cimg,cidx]=clipimg(img,mask); 
% 计算Z的实部和虚部
z=clipimg(x+i*y,mask); 
% 计算复数的模，sqrt(x,y),z=x+iy
p=0.9*abs(z);   ;
% 计算复数z的辐角值（tanz）
theta=angle(z); 
c=1;
for order=1:length(n)
        n1=n(order);
           if nargin<3
                m=zpossible(n1);                
        end
        for r=1:length(m)
  V_nmt=zpoly(n1,m(r),p,theta); 
 % conj是求复数的共轭
zprod=cimg.*conj(V_nmt); 
 % (n1+1)/π*∑∑(zprod); 对于图像而言求和代替了求积分
A_nm(c)=(n1+1)*sum(sum(zprod))/pi; 
                zmlist(c,1:2)=[n1 m(r)]; 
                if nargout==4
                        V_nm(:,c)=V_nmt;
                end
                c=c+1;
        end
end
else
end

%%%%%子函数%%%%%
function [cimg,cindex,dim]=clipimg(img,mask)
%功能：计算复数的实部和虚部
dim=size(img);  
cindex=find(mask~=0);
cimg=img(cindex); 
return;

%%%%%子函数%%%%%
function  [m]=zpossible(n)
% 功能：判断n是偶数还是奇数，是偶数时，m取0,2,4,6等,否则取奇数赋值m
if iseven(n)
        m=0:2:n;
else
        m=1:2:n;
end
return;

%%%%%子函数%%%%%
function        [V_nm,mag,phase]=zpoly(n,m,p,theta)
%功能：计算Zernike矩多项式
R_nm=zeros(size(p)); % 产生size(p)*size(p)的零矩阵赋给R_nm
a=(n+abs(m))/2;
b=(n-abs(m))/2;
total=b;
for s=0:total
        num=((-1)^s)*fac(n-s)*(p.^(n-2*s)); % (-1).-1*(n-s)!r.^(n-2*s)
        den=fac(s)*fac(a-s)*fac(b-s); % s!*(a-s)!*(b-s)!
        R_nm=R_nm + num/den; % R_nm是一个实数值的径向多项式
end
mag=R_nm; % 赋值
phase=m*theta; 
V_nm=mag.*exp(i*phase); % V_nm为n阶的Zernike多项式，定义为在极坐标系中p，theta的函数
return;

%%%%%子函数%%%%%
function [factorial]=fac(n)
%功能：求n的阶乘
maxno=max(max(n));
zerosi=find(n<=0); %取n小于等于0的数
n(zerosi)=ones(size(zerosi));
factorial=n;
findex=n;
for i=maxno:-1:2
        cand=find(findex>2);
        candidates=findex(cand);
        findex(cand)=candidates-1;
        factorial(cand)=factorial(cand).*findex(cand);
end
return;

function [verdict]=iseven(candy)
verdict=zeros(size(candy));
isint=find(isint(candy)==1);
divided2=candy(isint)/2;
evens=(divided2==floor(divided2));
verdict(isint)=evens;
return;

function [verdict]=isint(candy)
verdict        = double(round(candy))==candy;
return;
