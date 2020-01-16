% Signal detection
clear
close all

debug_mode = true;

%%
% Charging image in memory
dataset_path = getenv('Dataset_path');
image = strcat(dataset_path, "\camera00\00\image.000060.jp2");
I = imread(image);
good_BBs = Detection(I,debug_mode);

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