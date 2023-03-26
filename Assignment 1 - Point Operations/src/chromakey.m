im = imread("./media/cat.jpg");
imhsv = rgb2hsv(im);
im_spacebg = imread("./media/spacebg.jpg");


imwrite(im, "./out/6.cat.jpg")
imwrite(im_spacebg, "./out/6.spacebg.jpg")
im = (double(im)./255);
im_spacebg = (double(im_spacebg)./255);


% Lets the user select a pixel in the image to key out.
figure()
imshow(im);
coords = int32(ginput(1));
px_hsv = imhsv(coords(2), coords(1), 1:3);


%  Each channel may deviate of these amounts from the selected pixel.
hue_deviation = 0.05;
saturation_deviation = 0.1; % += 10% saturation
brightness_deviation = 0.4; % += 40% darker/lighter

% Creates the mask for each pixel whose channels are within the deviations
mask = ~((imhsv(:,:,1) > px_hsv(1) - hue_deviation) & (imhsv(:,:,1) < px_hsv(1) + hue_deviation) & ...
       (imhsv(:,:,2) > px_hsv(2) - saturation_deviation) & (imhsv(:,:,2) < px_hsv(2) + saturation_deviation) & ...
       (imhsv(:,:,3) > px_hsv(3) - brightness_deviation) & (imhsv(:,:,3) < px_hsv(3) + brightness_deviation));

im_mask = comp(ones(size(im)),mask,zeros(size(im)));
im_comp = comp(im,mask,im_spacebg);

imshow([im, im_mask, im_comp], []);
title("Original image, mask and composited image")
saveas(gcf,'out/6.image_mask_comp.png')

imwrite(uint8(255.*im_mask), "./out/6.mask.jpg");
imwrite(uint8(255.*im_comp), "./out/6.comp.jpg");


function res = comp(a,mask,b)
    % Masks image 'a' on top of image 'b'
    res = a.*mask + b.*(~mask);
end