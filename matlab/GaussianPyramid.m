function [pyr, filter] = GaussianPyramid(im, maxLevels, filterSize)
% Creates Gaussian Pyramid of a given image
%   INPUT:
% im - a grayscale image with double values in [0,1]
% maxLevels - the maximal number of levels in the resulting pyramid
% filterSize - the size of the Gaussian filter 
%   OUTPUT:
% pyr - is the resulting pyramid as a column cell array with maximum of maxLevels cells of grayscale images
% filter - is 1D-row of size filterSize used for the pyramid construction, normalized

MIN_RES = 16;
im = double(im);

% assume filterSize is odd
filter = binomialFilter1D(filterSize);

pyr(1) = {im};

level = 2;
imS = im;
while ( level <= maxLevels )
    %Blur
    imS = conv2(imS, filter, 'same');
    imS = conv2(imS, filter', 'same');
    % take only second pixel
    imS = imS(1:2:end,1:2:end);
    
    [m,n] = size(imS);
    % check minimal resolution
    if( min(m,n) < MIN_RES)
        break;
    end
    
    %update pyramid of G
    pyr(level) = {imS};
    level = level +1;
end

pyr = pyr';
end

