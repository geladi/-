function hh = display_keypoints( pos, scale, orient, varargin )
 
% 功能：在原始图像上显示特征点
% 输入:
% pos – 特征点的位置矩阵.
% scale –特征点的尺度矩阵.
% orient –特征点的主方向向量.
% 输出:
% hh-返回向量的线句柄.

hold on;
 
alpha = 0.33; 
beta = 0.33; 
autoscale = 1.5; 
plotarrows = 1; 
sym = '';
 
filled = 0;
ls = '-';
ms = '';
col = '';
 
varin = nargin - 3;
 
while (varin > 0) & isstr(varargin{varin}),
   vv = varargin{varin};
   if ~isempty(vv) & strcmp(lower(vv(1)),'f')
      filled = 1;
      nin = nin-1;
   else
      [l,c,m,msg] = colstyle(vv);
      if ~isempty(msg), 
         error(sprintf('Unknown option "%s".',vv));
      end
      if ~isempty(l), ls = l; end
      if ~isempty(c), col = c; end
      if ~isempty(m), ms = m; plotarrows = 0; end
      if isequal(m,'.'), ms = ''; end % Don't plot '.'
      varin = varin-1;
   end
end
 
if varin > 0
   autoscale = varargin{varin};
end
   
x = pos(:,1);
y = pos(:,2);
u = scale.*cos(orient);
v = scale.*sin(orient);
 
if prod(size(u))==1, u = u(ones(size(x))); end
if prod(size(v))==1, v = v(ones(size(u))); end
 
if autoscale,
  u = u*autoscale; v = v*autoscale;
end
 
ax = newplot;
next = lower(get(ax,'NextPlot'));
hold_state = ishold;
 
x = x(:).'; y = y(:).';
u = u(:).'; v = v(:).';
uu = [x;x+u;repmat(NaN,size(u))];
vv = [y;y+v;repmat(NaN,size(u))];
 
h1 = plot(uu(:),vv(:),[col ls]);
 
if plotarrows,
  hu = [x+u-alpha*(u+beta*(v+eps));x+u; ...
        x+u-alpha*(u-beta*(v+eps));repmat(NaN,size(u))];
  hv = [y+v-alpha*(v-beta*(u+eps));y+v; ...
        y+v-alpha*(v+beta*(u+eps));repmat(NaN,size(v))];
  hold on
  h2 = plot(hu(:),hv(:),[col ls]);
else
  h2 = [];
end
 
if ~isempty(ms), 
  hu = x; hv = y;
  hold on
  h3 = plot(hu(:),hv(:),[col ms]);
  if filled, set(h3,'markerfacecolor',get(h1,'color')); end
else
  h3 = [];
end
 
if ~hold_state, hold off, view(2); set(ax,'NextPlot',next); end
 
if nargout>0, hh = [h1;h2;h3]; end
