function imOut = setGrayChannel(yiqIm, grayChannel)
%getGrayscale set the grayscale channel of the image
%
%   @param imMedium - medium returned by getGrayChannel (either YIQ or
%                                              grayscale)
%   @param grayChannel - Gray channel to set
%
%   @returns imOut - image with the gray channel set

    if nargin ~= 2
        error('Invalid amount of arguments')
    end

    %if it's RGB convert to YIQ and return the respective channel
    colors = size(yiqIm, 3);
    if colors == 3
        yiqIm(:, :, 1) = grayChannel;
        imOut = transformYIQ2RGB(yiqIm);
    elseif colors == 1
        imOut = grayChannel;
    end

end

