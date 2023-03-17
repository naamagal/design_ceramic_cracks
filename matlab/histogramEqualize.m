function [imEq, histOrig, histEq] = histogramEqualize(imOrig)
% HistogramEqualize function performs histogram equalization of a given grayscale or RGB image
% INPUT:
% imOrig - is the input grayscale or RGB double image with values in [0; 1]
% OUTPUT:
% imEq - is the equalized image. Grayscale or RGB double image with values in [0; 1]
% histOrig - is a 256 bin histogram of the original image (256x1 vector).
% histEq - is a 256 bin histogram of the equalized image (256x1 vector).

% display the input image;
figure;
imshow(imOrig);

%validate input and in case of RGB, take only the Y channel
dim = numel(size(imOrig));
% I assumed that if I have 3-D matrix it is RGB and not anything else!
% I can't check here the colorType because I don't have the imFile..
if dim == 3 % truecolor
    imYIQOrig = rgb2ntsc(imOrig);
    imOrigT = imYIQOrig(:,:,1);
else
    if dim ==2
        imOrigT = imOrig;
    else
        error('Error, this function support only RGB or B/W images');
    end
end

% imOrig dimantions
[m,n] = size(imOrigT);

% convert image to vector
imOrigT = imOrigT(:);
histOrig = imhist(imOrigT,256);
%figure; plot(histOrig);
%cum = cumsum(histOrig);
%figure; plot(cum);
%start = cum(1);
%range = cum(256) - start;
%histOrig = round(((cum - start)./range)*255);

noneZeroElements = find(histOrig);
startIdx = noneZeroElements(1);
endIdx = noneZeroElements(end);
range = endIdx - startIdx;
% linear strech
% OUTVAL = (INVAL - INLO) * ((OUTUP-OUTLO)/(INUP-INLO)) + OUTLO
imLinear = (imOrigT.*255-startIdx+1)/range;
%figure; imshow(reshape(imLinear,m,n));
histLinear = imhist(imLinear,256);
%figure; plot(histLinear);
cum = cumsum(histLinear);
%figure; plot(cum);
histEqT = round(((cum - cum(1))./(cum(256)-cum(1)))*255);
imAfterHist = histEqT(round(imLinear*255)+1);

% correct the image by the new values from the histogram
%imAfterHist = histEq(round(imOrigT*255)+1);
imAfterHist = reshape(imAfterHist, m, n);
histEq = imhist(imAfterHist);

% for RGB pic - convert back from YIQ to RGB
% while only the Y-ch (first, for intensity) changed by the hist
if dim == 3 % truecolor
    imYIQ_1ch = imAfterHist/255;
    imYIQ_allch = imYIQOrig;
    imYIQ_allch(:,:,1) = imYIQ_1ch;
    imEq = ntsc2rgb(imYIQ_allch);
else
    if dim ==2 % 'grayscale'
        imEq = imAfterHist/255;   
    end
end


%display the equalized output image
figure;
imshow(imEq);

end