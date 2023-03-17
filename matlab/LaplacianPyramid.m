function [pyr, filter] = LaplacianPyramid(im, maxLevels, filterSize)
% Create Laplacian pyramid of a given image
%   INPUT:
% im - a grayscale image with double values in [0,1]
% maxLevels - the maximal number of levels in the resulting pyramid
% filterSize - the size of the Gaussian filter 
%   OUTPUT:
% pyr is the resulting Laplacian pyramid as a column cell array with maximum of maxLevels cells of grayscale images
% filter is 1D-row of size filterSize used for the pyramid construction, normalized

% Calculate Gaussian Pyramid
[Gpyr, filter] = GaussianPyramid(im, maxLevels, filterSize);

numOfLevels = size(Gpyr,1);
pyr =  cell(numOfLevels,1);
pyr(numOfLevels) = Gpyr(numOfLevels);

pyrIdx = numOfLevels-1;
while( pyrIdx > 0 )
    prevGMat = Gpyr {pyrIdx+1};
    curGMat = Gpyr {pyrIdx};
    
    % expand prev Gausian
    expandedIm = ExpandImg( prevGMat, filter );
    
    % reduce from prev Gaussian the expanded and blured current Gaussian
    curLapMat = curGMat - expandedIm;
    pyr(pyrIdx) = {curLapMat};
    pyrIdx = pyrIdx -1;
end
end

