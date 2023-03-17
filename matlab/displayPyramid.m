function displayPyramid(pyr,levels)
% Present the result of render- a matrix with images in all levels of the
% pyramid

rendedIm = renderPyramid(pyr,levels);
figure; imshow(rendedIm);

end

