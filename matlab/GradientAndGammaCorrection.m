%Gradient Image + gamma correction

im = imread('C:\Users\Naama\Documents\Academy\Hebrew University\Lab- Ceramics Cracks\Images\cracksOrigSmall.tif'); % 'images\tileNaama.jpg');
im = im(1:end,1:end,1:3);
im = rgb2gray(im);
im = (double(im)./255);

filter = 0.5*[1,0,-1];
im2 = im;

im2 = conv2(im2, filter, 'same');
im2 = conv2(im2, filter', 'same');
im2 = abs(im2);

im03 = im2.^0.3;
im04 = im2.^0.4;
im05 = im2.^0.5;
im06 = im2.^0.6;
im07 = im2.^0.7;

%%
% im03 = 1-im03;
% im04 = 1-im04;
% im05 = 1-im05;
% im06 = 1-im06;
% im07 = 1-im07;

%% normal area: (500:1000,500:1000)
% problematic area: 
figure; imshow(im03);
figure; imshow(im04);
figure; imshow(im05);
figure; imshow(im06);
figure; imshow(im07);

%maybe prequantization???

%pyramid
imForPyr=im05;
[pyr, filter] = GaussianPyramid(imForPyr, 4, 3);
pyrLastIdx = 2;

%quantization
[imQuant, ~] = quantizeImage(pyr{pyrLastIdx}, 2, 4);
brightVal = max(max(imQuant));
imQuant = (imQuant >= brightVal);
imQuant = double(imQuant);

figure; imshow(imQuant);
%return to original image size
%for r = 1:pyrLastIdx
%    imExp = ExpandImg (imQuant,filter);
%    imQuant = imExp;
%end
%threshold? quantization again..?


