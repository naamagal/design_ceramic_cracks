function expandedIm = ExpandImg( image, filter )
% ExpandImage with zeroes and blur it with filter
%INPUT:
% image- original small img;
% filter - filter vector 1D to blur
%OUTPUT:
% expandedIm- result image

imageT = upsample(image, 2);
imageT = upsample(imageT.', 2);
imageT = imageT.';

% blur by filter
bluredCurMat = conv2(imageT, 2*filter, 'same');
bluredCurMat = conv2(bluredCurMat, 2*filter.', 'same');

expandedIm = bluredCurMat;

end

