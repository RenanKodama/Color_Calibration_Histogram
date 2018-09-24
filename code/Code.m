 #   Universidade Tencologica Federal do Parana
 #   Renan Kodama Rodrigues 1602098
 #   Visão Computacional (Color calibration with Histogram Matching)

#load packages
pkg load image;
pkg load optim;

#load images
image01 = imread("data/img1_patch.png");
image02 = imread("data/img2_patch.png");

#apresentation of original images
#figure('name','Image01','numbertitle','off'), imshow(image01);
#figure('name','Image02','numbertitle','off'), imshow(image02);

image01_out_R = zeros(1,256,"uint8");   #output channel red
image01_out_G = zeros(1,256,"uint8");   #output channel green
iamge01_out_B = zeros(1,256,"uint8");   #output channel blue
i=1;                                          #iterate in channels
[size_X,size_Y,size_Z] = size(image01);       #dimensions of image
array_images = zeros(size_X,size_Y,size_Z);   #variable to store channels

while i <= 3                                        #repeat to all channels RGB
  image01_histogram=(hist((image01(:,:,i)),256));   #histogram per channel 01
  image02_histogram=(hist((image02(:,:,i)),256));   #histogram per channel 01
  dif = D(image01_histogram,image02_histogram);     #diferenca de histogramas
  
  new_dif = 0;
  new_vetor= zeros(1,256,"uint8");
  saida =  zeros(size_X,size_Y,"uint8");
  
  #while (new_dif < (dif*0.50))   #diferença de 20%
    printf("Iniciando Iteracao...\n");
   
    #pontos escolhidos aleatóriamente p1, p2 e p3
    x1 = 0;
    y1 = 0; 
    
    x2 = 50;
    y2 = 20;

    x3 = 250;
    y3 = 100;  
    
    solution = Sistema(x1,y1,x2,y2,x3,y3);  #return three points 2º function x²+x+1
    
    for aux= (0:255) 
      new_vetor(aux+1) = (solution(1)*(aux^2)) + (solution(2)*aux) + (solution(3));   #a b c
    endfor
    
    #plot (0:255,new_vetor);
    
    for aux_i= (1:size_X)
      for aux_j= (1:size_Y)
          val_orig = (image01(aux_i,aux_j,i));
          val_new = new_vetor(val_orig+1);
          saida(aux_i,aux_j) = val_new;
      endfor
    endfor
  
    new_histogram = imhist(saida);
    new_dif = D(new_histogram,image02_histogram);
    
    switch(i)
      case 1
        image01_out_R = saida;
      case 2 
        image01_out_G = saida;
      case 3
        image01_out_B = saida;
      otherwise
        printf("Error!");
     endswitch
   #endwhile
   
  array_images(:,:,i) = saida;
  figure, imshow(uint8(saida));
  saida =  zeros(size_X,size_Y,"uint8");
  
  i++;
endwhile
  
image_final = cat(3,image01_out_R,image01_out_G,image01_out_B);  
figure, imshow(uint8(image_final));

printf ("EndCode");
  

#equalizaçao das imagens por canal
#final01 = histeq(image01(:,:,1),256);


