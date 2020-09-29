function [pars, type]= pnmReadHeader(fid)
% 功能：读入并解析一个pnm 格式图像的头文件
 
pars = -1;
type = 'Unknown';
 
TheLine = fgetl(fid);
szLine = size(TheLine);
endLine = szLine(2);
 
if (endLine < 2)
  fprintf(1, ['Unrecognized PNM file type\n']);
  pars = -1;
  return;
end
 
type = TheLine(1:2);
ok = 0;
if (type(1) == 'P')
   if (type(2) == '1' | type(2) == '2' | ...
       type(2) == '3' | type(2) == '4' | ...
       type(2) == '5' | type(2) == '6' | ...
       type(2) == 'B' | type(2) == 'L')
     ok = 1;
   else
     fprintf(1, ['Unrecognized PNM file type: ' type '\n']);
   end
end
if (type(1) == 'F')      
   if (type(2) == 'P' | type(2) == 'U')
     ok = 1;
   else
     fprintf(1, ['Unrecognized PNM file type: ' type '\n']);
   end
end
  
if ~ok
   pars = -1;
   return;
end
 
current = 3; 
parIndex=1;  
while(parIndex < 4) 
  while (current > endLine)
    TheLine = fgetl(fid);
    if (TheLine == -1)
      fprintf(1, 'Unexpected EOF\n');
      pars = -1;
      return;
    end
    szLine = size(TheLine);
    endLine = szLine(2);
    current = 1;
  end
  
  [token, count, errmsg, nextindex] = ...
       sscanf(TheLine(current:endLine),'%s',1);
  nextindex = nextindex+current-1;
  
  if (count==0)
    if (nextindex > endLine) 
     current = nextindex;
    else 
     pars = -1;
     fprintf(1, 'Unexpected EOF\n');
     return;
    end
  else 
  
   if token(1) == '#'
    current = endLine+1;
   else
    [pars(parIndex), count, errmsg, nextindex] = ...
       sscanf(TheLine(current: endLine), '%d', 1);
    if ~(count==1)
      fprintf(1,'Confused reading pgm header\n');
      pars=-1;
      return;
    end
    parIndex = parIndex+1;
    current = current+nextindex-1;
   end
 
  end
end
