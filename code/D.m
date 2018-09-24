function dis = D(u,v)
  dis = 0;
  [x,y] = size(u);
  
  for i= (1:x)
    for j= (1:y)
         dis = dis + (u(x,y) - v(x,y))^2;
    endfor
  endfor
endfunction