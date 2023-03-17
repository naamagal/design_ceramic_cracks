function [imQuant, error] = quantizeImage(imOrig, nQuant, nIter)
%quantizeImage - quantize the gray channel of the image
%
%   @param imOrig - The original image.
%   @param nQuant - Number of colors in the quantized image
%   @param nIter - How many computing operations to run
%
%   @returns imQuant - image with qunatized gray channel
%   @returns error - 

    if nargin ~= 3
        disp('Invalid amount of arguments')
    end

    [yiqIm, channel] = getGrayChannel(imOrig);
    
    nColors = 256;
    
    % Compute histogram
    channel = round(channel * 255) + 1;
    histOrig = imhist(uint8(channel), nColors)';

    % Linearly distribute the points across the range
    partition = firstPartition(histOrig, nColors, nQuant);

    colors = computeColors(histOrig, partition);
    
    error = zeros(nIter, 1);
    for i = 1:nIter
        [partition, converge] = computePartition(colors, partition);
        
        % Convergence
        if converge
            i = i-1;
            break
        end
        
        colors = computeColors(histOrig, partition);
        
        error(i) = calculateError(histOrig, partition, colors);
    end
    
    % Normalize the error
    error = error(1:i) / max(error);
    
    colors = round(colors);
    
    indexes = zeros(1, nColors);
    % lut(z_i:z_i+1) = partition(q(i))
    indexes(partition(1:end-1)) = 1;
    indexes = cumsum(indexes);
    
    lut = colors(indexes);

    quantChannel = double(lut(channel)) / 255;
    quantHist = imhist(quantChannel)';
    
    % Save the gray channel to the image
    imQuant = setGrayChannel(yiqIm, quantChannel);
end

function error = calculateError(hist, partition, colors)
%function calculateError - calculate error given partition and quantized
%colors
%
%   @param hist - histogram of the image
%   @param partition - partition 
%
%   @return error - the error in the current loop
    error = 0;

    nQuant = size(colors, 2);

    % Sum on every color, didn't find a way to vectorize this
    for i=1:nQuant
        % Follow the formula gives in class (diff) ^ 2 * hist(x)
        x= partition(i) : partition(i+1);
        h = hist(x) ;
        colorDiff = x - colors(i);
        colorDiff = colorDiff .* colorDiff;
        error = error + colorDiff * h';
    end
    error = sqrt(error);
end

function optColors = computeColors(hist, partition)
%computeColors - compute the optimal quantized colors, for a given partition
%   hist - The histogram of channel
%   partition - A monotonically increasing vector with range 1-nColors
    x = zeros(size(hist, 2));
    x = [partition(1):partition(end)] - 1;
    
    % Compute optimal colors with the function given in class
    numerator = cumsum(x.*hist);
    denominator = cumsum(hist);
    
    numerator = [0 numerator(partition(2:end))];
    denominator = [0 denominator(partition(2:end))];
    
    numerator = diff(numerator);
    denominator = diff(denominator);
    
    optColors = numerator ./ denominator;
    
end

function [partition, converge] = computePartition(colors, origPartition)
%computePartition - compute optimal partition given quantized colors
%   hist - the histogram
%   colors - the quantized colors
    % The partition is just the average of adjesant elements
    partition =round( [origPartition(1) conv(colors, [0.5, 0.5], 'valid') origPartition(end)]);
    converge = origPartition == partition;
   % partition = partition(partition~=0)
end

function partition = firstPartition(hist, nColors, nQuant)
%firstPartition - Compute the first partition, where each section has
%approximately the same amount of pixels.
%
%@param hist - Histogram of the image
%@param nColors - Number of colors in the image
%@param nQuant - Number of quantized colors
%
%@returns partition - the partition
    csum = cumsum(hist);
    average = csum(end) / nQuant;

    partition = 1:nColors;
    % This finds the indexes where the average multiplier changes
    indexes = logical([0 diff(floor(csum / average))]);
    partition = partition(indexes);
    partition = [1 partition(1:end-1) nColors];
end