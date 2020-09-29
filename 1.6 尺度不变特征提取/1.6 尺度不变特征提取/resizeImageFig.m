function resizeImageFig(h, sz, frac)
% function resizeImageFig(h, sz, frac)
% 功能：根据句柄重获图像的大小
%  sz = 图像尺寸.
%  frac (默认值= 1).
 
if (nargin <3)
 frac = 1;
end
 
pos = get(h, 'Position');
set(h, 'Units', 'pixels', 'Position', ...
       [pos(1), pos(2)+pos(4)-frac*sz(1), ...
        frac*sz(2), frac*sz(1)]);
set(gca,'Position', [0 0 1 1], 'Visible', 'off');
