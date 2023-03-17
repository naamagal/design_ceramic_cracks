function pyr = calcPyramidBinary(imIn, KLevels)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

MIN_RES = 16;
pyr(1) = {imIn};
level = 2;
imS = imIn;
while ( level <= KLevels )
    imS = impyramid(imIn, 'reduce');
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

