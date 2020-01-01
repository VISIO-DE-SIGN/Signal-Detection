% Signal detection
clear
%%
% Charging image
dataset_path = getenv('Dataset_path');
image = strcat(dataset_path, "\camera00\00\image.000134.jp2");
I = imread(image);

%%
% Only blue and red pixels
B = I(:,:,3) - I(:,:,1) - I(:,:,2);
R = I(:,:,1) - I(:,:,2) - I(:,:,3);

%%
% Binarizing image
blue = imbinarize(B,'adaptive');
red = imbinarize(R,'adaptive');

%%
% recorte de franja de 2 pixeles
blue = blue(3:end-2,3:end-2);
red = red(3:end-2,3:end-2);

%%
% Getting regions 
caract_red = regionprops(red,'all');
caract_blue = regionprops(blue,'all');

%%
% Filtering regions
goodBBindex_red = filter_by_area(caract_red, 100);
goodBBindex_blue = filter_by_area(caract_blue, 100);

red_regions = caract_red(goodBBindex_red);
blue_regions = caract_blue(goodBBindex_blue);

goodBBindex_red = filter_by_aspRatio(red_regions,1,0.5);
goodBBindex_blue = filter_by_aspRatio(blue_regions,1,0.5);

red_regions = red_regions(goodBBindex_red);
blue_regions = blue_regions(goodBBindex_blue);


%%
% Showing regions that follow some criteria
showBB(I,red_regions,'red',true);
showBB(I,blue_regions,'blue',false);

%%
% saving those regions as new images
% they will be passed to the clasification neural net.

% preallocation for 100x100 resolution images
num_red = length(red_regions);
num_blue = length(blue_regions);
sign = uint8(zeros(100,100,3,num_red+num_blue));

for i = 1:num_red
    x = red_regions(i).BoundingBox(1);
    y = red_regions(i).BoundingBox(2);
    w = red_regions(i).BoundingBox(3);
    h = red_regions(i).BoundingBox(4);
    signal = I(y:y+h,x:x+w,:);
    sign(:,:,:,i) = imresize(signal,[100,100]);
end

for i = 1:num_blue
    x = blue_regions(i).BoundingBox(1);
    y = blue_regions(i).BoundingBox(2);
    w = blue_regions(i).BoundingBox(3);
    h = blue_regions(i).BoundingBox(4);
    signal = I(y:y+h,x:x+w,:);
    sign(:,:,:,num_red+i) = imresize(signal,[100,100]);
end

%%
% Show traffic signs detected

for i = 1:num_red+num_blue
    figure
    imshow(sign(:,:,:,i))
end
