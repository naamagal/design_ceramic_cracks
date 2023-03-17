%BlueScript
im = imread('images\blue1.jpg');
im = im(1:end,1:end,3);
im = (double(im)./255);
imshow(im);

[pyr, filter] = GaussianPyramid(im, 4, 3);
pyrLastIdx = 2; %size(pyr,1); % check levels

%local work: patch by patch
pyrIm = pyr{pyrLastIdx}; % = im
[R,C] = size(pyrIm);
imVar = var(pyrIm(:));
%pyrIm(1,:) =1; pyrIm(end,:) =1; pyrIm(:,1) =1; pyrIm(:,end) =1;
newImPyr = ones(R,C);
newImQuantized = ones(size(im));
jump = 20;
for r = 1:jump:R-1
    for c = 1:jump:C-1
        Sr = r+1;
        Er =min( r+jump,R);
        Sc = c+1;
        Ec = min(c+jump,C);
        %imS = im( Sr:Er, Sc:Ec); % no need anymore!
        imSPyr = pyrIm( Sr:Er, Sc:Ec);
        % check patch variance for the "line strength"
        PatchVar = var(imSPyr(:));
        varRatio = PatchVar/imVar;
        imSPyr = imSPyr.^(1+varRatio);
        newImPyr(Sr:Er, Sc:Ec) = imSPyr;
        
        % quantization, better to do it regarding to the variance of the patch..?
         [imQuant, ~] = quantizeImage(imQuantTmp, 2, 4);
         
         %make it as a binary image 0/1
        %darkVal = min(min(imQuant));
        brightVal = max(max(imQuant));
        imQuant = (imQuant == brightVal);
        imQuant = double(imQuant);
        
        newImQuantized( Sr:Er, Sc:Ec) = imQuant;
    end    
end

figure; imshow(newImQuantized);
%figure; imshow(newImPyr);
imwrite(newImQuantized, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\matlab\images\Blue1Tile2ndPyrQuantBinary.jpg');
%imwrite(newImPyr, 'C:\Users\Naama\Documents\Academy\Hebrew University\Lab- Ceramics Cracks\matlab\images\tileAmitNoBinary.jpg');