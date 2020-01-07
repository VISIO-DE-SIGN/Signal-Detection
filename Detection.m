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
% show red and blue areas
figure
imshow(blue);
title('Blue areas');

figure
imshow(red);
title('Red areas');

%%
% Getting regions 
caract_red = regionprops(red,'all');
caract_blue = regionprops(blue,'all');

%%
% Filtering regions

goodBBindex_red = filter_by_area(caract_red, 10);
goodBBindex_blue = filter_by_area(caract_blue, 10);

red_regions = caract_red(goodBBindex_red);
blue_regions = caract_blue(goodBBindex_blue);
%showBB(I,blue_regions,'blue',true,false);

BBs_blue = region2BB(blue_regions);
BBs_red = region2BB(red_regions);

BBs_all = [BBs_blue;BBs_red];

diferent = false;
last_BBs = BBs_all;
while 1
    mergedBB = mergeBBs(last_BBs,1);
    if length(last_BBs) == length(mergedBB)
        break
    end
    last_BBs = mergedBB;
end
% show merged
%{
for i=1:length(mergedBB)
    rect = [mergedBB(i).x, mergedBB(i).y, mergedBB(i).width, mergedBB(i).height];
    rectangle('Position',rect,'EdgeColor','green');
end
%}

goodBBindex_all = filter_by_aspRatio(mergedBB,1,0.5, true);
good_BBs = mergedBB(goodBBindex_all);
goodBBindex_all = filter_by_area(good_BBs, 100,true);
good_BBs = good_BBs(goodBBindex_all);

%%
% Showing regions that follow some criteria
showBB(I,good_BBs,'blue',true,true);

%%
% saving those regions as new images
% they will be passed to the clasification neural net.

% preallocation for 100x100 resolution images
sign = uint8(zeros(100,100,3,length(good_BBs)));

for i = 1:length(good_BBs)
    x = good_BBs(i).x;
    y = good_BBs(i).y;
    w = good_BBs(i).width;
    h = good_BBs(i).height;
    signal = I(y:y+h,x:x+w,:);
    sign(:,:,:,i) = imresize(signal,[100,100]);
end

%%
% Show traffic signs detected

for i = 1:length(good_BBs)
    figure
    imshow(sign(:,:,:,i))
end
