function [imMedium, grayChannel] = getGrayChannel(im)
%getGrayscale get the grayscale channel from the image
%   @param im - image in greyscale or RGB format
%
%   @returns imMedium - if the image was RGB, then the image converted to YIQ
%                                           if it was grayscale then it returns the image itself.
%   @returns grayChannel - the gray channel of the image

    if nargin ~= 1
        error('Invalid amount of arguments')
    end

    %if it's RGB convert to YIQ and return the respective channel
    colors = size(im, 3);
    if colors == 3
        imMedium = transformRGB2YIQ(im);
        grayChannel = imMedium(:, :, 1);
    else if colors == 1
        imMedium = im;
        grayChannel = im;
    end

end

