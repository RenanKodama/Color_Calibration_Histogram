#Universidade Tencologica Federal do Parana
#Renan Kodama Rodrigues 1602098
#Visão Computacional (Color calibration with Histogram Matching)

pkg load image;

#load image
image01 = imread("data/img1_patch.png");
image02 = imread("data/img2_patch.png");

#figure('name','Image01','numbertitle','off'), imshow(image01);
#figure('name','Image02','numbertitle','off'), imshow(image02);

image01_R=(hist((image01(:,:,1)),256));
image01_G=(hist((image01(:,:,2)),256));
image01_B=(hist((image01(:,:,3)),256));

#figure('name','Image01_R','numbertitle','off'), imshow(image01_R);

image02_R=(hist((image02(:,:,1)),256));
image02_G=(hist((image02(:,:,2)),256));
image02_B=(hist((image02(:,:,3)),256));

#figure, plot(image01_R);
#figure, plot(image02_R);

#equalizaçao das imagens por canal
final01 = histeq(image01(:,:,1),256);
figure('name','Final01','numbertitle','off'), imshow(final01);

