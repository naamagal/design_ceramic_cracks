%script

im = imread('images\NewTiles\sun2.jpg'); % 'images\tileNaama.jpg');
im = im(1:end,1:end,1:3);
im = rgb2gray(im);
im = (double(im)./255);

% pyr{1} = original image
%pyr{"end-index"} = smallest image and the most "smoothed"..
[pyr, filter] = GaussianPyramid(im, 4, 3);
pyrLastIdx = 2; %size(pyr,1); % check levels

%local work: patch by patch
[R,C] = size(im);
newImPyr = ones(R,C);
newImQuantized = ones(R-1,C-1);
jump = 60;

for r = 1:jump:R-1
    for c = 1:jump:C-1
        Sr = r;
        Er =min( r+jump-1,R);
        Sc = c;
        Ec = min(c+jump-1,C);
        imS = im( Sr:Er, Sc:Ec);
        
        patchMean = mean(imS(:));
        if patchMean < 0.8 % strong lines
            sr = ceil(Sr/4);
            er = ceil(Er/4);
            sc = ceil(Sc/4);
            ec = ceil(Ec/4);
            [imQuantTmp, ~] = quantizeImage(pyr{3}(sr:er,sc:ec), 2, 4);
            brightVal = max(max(imQuantTmp));
            imQuantTmp = (imQuantTmp >= brightVal);
            imQuantTmp = double(imQuantTmp);
            imExp = ExpandImg (imQuantTmp,filter);
            imExp = ExpandImg (imExp,filter);
        else if patchMean >= 0.8 && patchMean < 0.9% medium lines
            sr = ceil(Sr/2);
            er = ceil(Er/2);
            sc = ceil(Sc/2);
            ec = ceil(Ec/2);
            [imQuantTmp, ~] = quantizeImage(pyr{2}(sr:er,sc:ec), 2, 4);
            brightVal = max(max(imQuantTmp));
            imQuantTmp = (imQuantTmp >= brightVal);
            imQuantTmp = double(imQuantTmp);
            imExp = ExpandImg (imQuantTmp,filter);
            else if patchMean >= 0.9 % weak lines
                imExp = imS;
                end
            end
        end
        imExp = imExp(1:min(R-r,60), 1:min(C-c,60));
        % quantization, better to do it regarding to the variance of the patch..?
         [imQuant, ~] = quantizeImage(imExp, 2, 4);
         %make it as a binary image 0/1
        brightVal = max(max(imQuant));
        imQuant = (imQuant == brightVal);
        imQuant = double(imQuant);
        
        newImQuantized( Sr:min(Er,R-1), Sc:min(Ec,C-1)) = imQuant;
    end    
end

figure; imshow(newImQuantized);
%figure; imshow(newImPyr);
imwrite(newImQuantized, 'C:\Users\Naama\Documents\Academy\Lab- Ceramics Cracks\matlab\images\NewTiles\sun2_2ndPyrQuantBinary2Steps.jpg');
%imwrite(newImPyr, 'C:\Users\Naama\Documents\Academy\Hebrew University\Lab- Ceramics Cracks\matlab\images\tileAmitNoBinary.jpg');

% probability, should be for each patch separately, and that unify it all!
% maxDiffMean = max(max(mean(imS(1:100,1:100))), max(mean(imS(1:100,1:100)')')) -  min(min(mean(imS(1:100,1:100))), min(mean(imS(1:100,1:100)')'));
%don't works very well.. I added the factor of 2..
%imSS = imS(1:100,1:100) > mean(mean(imS(1:100,1:100))) - maxDiffMean/2;
%max(var(imS(1:100,1:100)')')
%max(var(imS(1:100,1:100)))
%min(var(imS(1:100,1:100)))
%mean(mean(imS(1:100,1:100)))