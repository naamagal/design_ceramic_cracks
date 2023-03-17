%QuantWithPatchesAndPyramid
im = imread('C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate3\plate3.jpg'); %('images\blue1.jpg'); %tileNaama
im = im(1:end,1:end,3); % 1:3
%im = rgb2gray(im);
im = (double(im)./255);
%imshow(im);

% pyr{1} = original image
%pyr{"end-index"} = smallest image and the most "smoothed"..
[pyr, filter] = GaussianPyramid(im, 3, 3);
pyrLastIdx = 2; %size(pyr,1); % check levels

%local work: patch by patch
pyrIm = pyr{pyrLastIdx}; % = im
[R,C] = size(pyrIm);
imVar = var(pyrIm(:));
%pyrIm(1,:) =1; pyrIm(end,:) =1; pyrIm(:,1) =1; pyrIm(:,end) =1;
newImPyr = ones(R,C);
newImQuantized = ones(floor(size(im)./pyrLastIdx));
% jump=4*x <-> pyrLevel=1  %%  jump=2*x <-> pyrLevel=2   %%    jump=x <-> pyrLevel=3 
jump = 40*pyrLastIdx;
for r = 1:jump:R-1
    for c = 1:jump:C-8
        Sr = r+1;
        Er =min( r+jump,R);
        Sc = c+1;
        Ec = min(c+jump,C);
        %imS = im( Sr:Er, Sc:Ec); % no need anymore!
        imSPyr = pyrIm( Sr:Er, Sc:Ec);
        %imshow(imSPyr);
        % check patch variance for the "line strength"
        PatchVar = var(imSPyr(:));
        varRatio = PatchVar/imVar;
        %imSPyr = imSPyr.^(1+(varRatio));
        newImPyr(Sr:Er, Sc:Ec) = imSPyr;
        
        % quantization, better to do it regarding to the variance of the patch..?
         [imQuant, ~] = quantizeImage(imSPyr, 2, 5); % 2 = binary, 5 = num of rounds
         
         %make it as a binary image 0/1
        %darkVal = min(min(imQuant));
        brightVal = max(max(imQuant));
        imQuant = (imQuant == brightVal);
        imQuant = double(imQuant);
        
        newImQuantized( Sr:Er, Sc:Ec) = imQuant;
    end    
end

imwrite(newImQuantized, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate3\Res\plate3_2ndPyr_40j_QuantBinOnly2.jpg');

se1 = strel('disk',5); %9
se2 =  [0 1 1 1 0; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1;0 1 1 1 0]; %5
%se =  [0 1 1 0; 1 1 1 1; 1 1 1 1;0 1 1 0]; %4
se3 =  [0 1 0; 1 1 1;0 1 0]; %3

% openBW = imopen(newImQuantized,se1);
% closeBW = imclose(newImQuantized,se1);
% opencloseBW = imclose(openBW,se1);
% closeopenBW = imopen(closeBW,se1);
% imwrite(openBW, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate2\Res\plate2_open_9ker_1stPyr_15j_QuantBinOnly.jpg');
% imwrite(closeBW, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate2\Res\plate2_close_9ker_1stPyr_15j_QuantBinOnly.jpg');
% imwrite(opencloseBW, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate2\Res\plate2_open-close_9ker_1stPyr_15j_QuantBinOnly.jpg');
% imwrite(closeopenBW, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate2\Res\plate2_close-open_9ker_1stPyr_15j_QuantBinOnly.jpg');

% openBW = imopen(newImQuantized,se2);
% closeBW = imclose(newImQuantized,se2);
% opencloseBW = imclose(openBW,se2);
% closeopenBW = imopen(closeBW,se2);
% imwrite(openBW, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate2\Res\plate2_open_5ker_1stdPyr_15j_QuantBinOnly.jpg');
% imwrite(closeBW, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate2\Res\plate2_close_5ker_1stPyr_15j_QuantBinOnly.jpg');
% imwrite(opencloseBW, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate2\Res\plate2_open-close_5ker_1stPyr_15j_QuantBinOnly.jpg');
% imwrite(closeopenBW, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate2\Res\plate2_close-open_5ker_1stPyr_15j_QuantBinOnly.jpg');

openBW = imopen(newImQuantized,se3);
closeBW = imclose(newImQuantized,se3);
opencloseBW = imclose(openBW,se3);
closeopenBW = imopen(closeBW,se3);
imwrite(openBW, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate3\Res\plate3_2ndPyr_open_3ker_40j_QuantBinOnly2.jpg');
imwrite(closeBW, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate3\Res\plate3_2ndPyr_close_3ker_40j_QuantBinOnly2.jpg');
imwrite(opencloseBW, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate3\Res\plate3_2ndPyr_open-close_3ker_40j_QuantBinOnly2.jpg');
imwrite(closeopenBW, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\Images\plate3\Res\plate3_2ndPyr_close-open_3ker_40j_QuantBinOnly2.jpg');
