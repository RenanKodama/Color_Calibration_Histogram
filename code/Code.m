 #   Universidade Tencologica Federal do Parana
 #   Renan Kodama Rodrigues 1602098
 #   Visão Computacional (Color Calibration With Histogram Matching)

 
pkg load image;   #load packages
pkg load optim;   #load packages

#ctime (time ())

image01 = imread("data/img1_patch.png");  #load images
image02 = imread("data/img2_patch.png");  #load images

figure('name','Imagem Inicial','numbertitle','off'), imshow(image01);            #apresentation of original images
figure('name','Imagem Para Comparação','numbertitle','off'), imshow(image02);    #apresentation of original images

image01_out_R = zeros(1,256);   #output channel red
image01_out_G = zeros(1,256);   #output channel green
iamge01_out_B = zeros(1,256);   #output channel blue
[size_X,size_Y,size_Z] = size(image01);       #dimensions of image
x1 = 1; y1 = 1;                               #initial point to P1
x2 = 50; y2 = 45;                             #initial point to P2
x3 = 120; y3 = 100;                           #initial point to P3
new_vetor = zeros(1,256,"uint8");             #map color 1 to 256
temp=10;                                       #initial temperature
image_final = image01;                          #create var to final iterate image 
best_image = zeros(size_X,size_Y,size_Z);       #create var to vest image
diff_red = 0;                                   #diff perl channel (Red)
diff_green = 0;                                 #diff perl channel (Green)
diff_blue = 0;                                  #diff perl channel (Blue)
best_difR = inf(1);                            #var best diference init with +inifinite Red
best_difG = inf(1);                            #var best diference init with +inifinite Green
best_difB = inf(1);                            #var best diference init with +inifinite Blue
new_dif = 0;                                  #diff in loop

while(temp > 0)
  printf("Temperatura: %d ...\n", temp);
  i=1;                                                #iterate in channels
  while (i <= 3)                                      #repeat to all channels RGB
    image01_histogram=(hist((image01(:,:,i)),256));   #histogram per channel 01
    image02_histogram=(hist((image02(:,:,i)),256));   #histogram per channel 02
    dif = D(image01_histogram,image02_histogram);     #diference between histograms
    new_dif = 0;                                #diference on loop between images
    saida = zeros(size_X,size_Y);               #output at final iteration
    
    while (new_dif <= dif)  
      #print iteration
      printf("Iniciando Iteracao... [%d,%d] [%d,%d] [%d,%d]\n",x1,y1,x2,y2,x3,y3); 
      
      #solution results for all three points
      solution = Sistema(x1,y1,x2,y2,x3,y3);  #return three points 2º function x²+x+1
      
      #create color map
      for aux= (0:255) 
        new_vetor(aux+1) = (solution(1)*(aux^2)) + (solution(2)*aux) + (solution(3));   #a b c
      endfor

      #plot (0:255,new_vetor); #plot color map
      
      for aux_i= (1:size_X)
        for aux_j= (1:size_Y)
            val_orig = (image01(aux_i,aux_j,i));
            val_new = new_vetor(val_orig+1);
            saida(aux_i,aux_j) = val_new;
        endfor
      endfor
      
      poinSorted = randi(3);      #point to sort (p1,p2,p3)
      poinSorted_aux = randi(2);  #axis (x,y)
      switch(poinSorted)
        case 1
          if ((x1 <= 80) || (y1 <= 80))  #p1 interval (1-80)
            if (poinSorted_aux == 1)
              x1+=5;  
            else      
              y1+=5;
            endif
          else
            if (poinSorted_aux == 1)
                x1 = randi(85);
            else
                y1 = randi(85);
            endif
          endif 
          
        case 2
          if ((x2 <= 165) || (y2 <= 165)) #p2 interval (1-165) 
            if (poinSorted_aux == 1)
              x2+=5;  
            else      
              y2+=5;
            endif
          else
            if (poinSorted_aux == 1)
                  x2 = randi([85,170]);
            else
                  y2 = randi([85,170]);
            endif
          endif
        case 3
          if ((x3 <= 251) || (y3 <= 251)) #p3 interval (1-251) 
            if (poinSorted_aux == 1)
              x3+=5;  
            else      
              y3+=5;
            endif
          else
            if (poinSorted_aux == 1)
                x3 = randi([170,256]);
            else
                y3 = randi([170,256]);
            endif
          endif
        otherwise
          printf("Error 0x01\n")
      endswitch
      
      new_histogram = imhist(saida);    #out iteration hitogram
      new_dif = D(new_histogram,image02_histogram);    #diff between new histogram and image suport histogram
    endwhile
    
    printf("New Channel %d...", i);
    
    #save each channel in variables
    switch(i)
      case 1
        image01_out_R = saida;
        diff_red = new_dif;
        diff_ori_red = dif;
      case 2 
        image01_out_G = saida;
        diff_green = new_dif;
        diff_ori_green = dif;
      case 3
        image01_out_B = saida;
        diff_blue = new_dif;
        diff_ori_blue = new_dif;
      otherwise
        printf("Error 0x02\n");
    endswitch
   
    saida =  zeros(size_X,size_Y);  #reset var saida
    i++;                            #incremente channel
  endwhile
  
  image_final = cat(3,image01_out_R,image01_out_G,image01_out_B);
  figure('name','Final Image Iteration','numbertitle','off'), imshow(uint8(image_final));
  
  if ((diff_red < (best_difR*1.04)) && (diff_green < (best_difG*1.04)) && (diff_blue < (best_difB*1.04)))   
    printf("\ntrocou!\n");
    best_difR = diff_red;
    best_difG = diff_green;
    best_difR = diff_blue;
    best_image = image_final;
  endif
  
  temp--;  #decrease temperature
endwhile
  
figure('name','Best Image Generate','numbertitle','off'), imshow(uint8(best_image));
printf ("EndCode \n");

#ctime (time ())



#Red = best_image(:,:,1);
#Green = best_image(:,:,2);
#Blue = best_image(:,:,3);

#[yRed, xRed] = imhist(Red);
#[yGreen, xGreen] = imhist(Green);
#[yBlue, xBlue] = imhist(Blue);

#figure('name','Best Image Histogram','numbertitle','off'), 
#hold ("on");
#figure,  plot (yRed, 256);
#figure,  plot (yGreen, 256);
#figure,  plot (yBlue, 256);
#hold ("off");


