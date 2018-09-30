function dis = D(u,v)
  dis = 0;
  [x,y] = size(u);
  
  for i= (1:x)
    dis = dis + (u(x) - v(x))^2;
  endfor
endfunction