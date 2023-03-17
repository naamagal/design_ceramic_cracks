function watershedSegmentation(im)
WS_Seg = watershed(1-im);
WS_Borders = WS_Seg;
WS_Borders(WS_Borders ~= 0) = 1;
bright_Lbl = im;
bright_Lbl(bright_Lbl ~= 1) = 0;
bright_Lbl = bwlabel(bright_Lbl);

figure; imshow(im)
figure; imagesc(WS_Seg); colormap jet; title('watershed on Image');
figure; imagesc(double(WS_Borders).*(im(:,:,1))); colormap gray
figure; imagesc(bright_Lbl); colormap jet; title('Labeling according to resultIm')
end

