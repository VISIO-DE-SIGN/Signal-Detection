% Signal detection

%%
% Charging image
dataset_path = getenv('Dataset_path');
image = strcat(dataset_path, "\camera00\00\image.000092.jp2");
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
% Showing regions bigger than 10 pixels
imshow(I)
for i = 1:length(caract_red)
    if(caract_red(i).Area>10)
        rectangle('Position',caract_red(i).BoundingBox,'EdgeColor','r')
    end
end
for i = 1:length(caract_blue)
    if(caract_blue(i).Area>10)
        rectangle('Position',caract_blue(i).BoundingBox,'EdgeColor','b')
    end
end

%%
% saving those regions as new images
% they will be passed to the clasification neural net.

% preallocation for 100x100 resolution images
num_red = length(caract_red);
num_blue = length(caract_blue);
sign = uint8(zeros(100,100,3,num_red+num_blue));

for i = 1:num_red
    x = caract_red(i).BoundingBox(1);
    y = caract_red(i).BoundingBox(2);
    w = caract_red(i).BoundingBox(3);
    h = caract_red(i).BoundingBox(4);
    signal = I(y:y+h,x:x+w,:);
    sign(:,:,:,i) = imresize(signal,[100,100]);
end

for i = 1:num_blue
    x = caract_blue(i).BoundingBox(1);
    y = caract_blue(i).BoundingBox(2);
    w = caract_blue(i).BoundingBox(3);
    h = caract_blue(i).BoundingBox(4);
    sign(length(caract_red) + i) = I(y:y+h,x:x+w,:);
end

%%
% Show traffic signs detected

for i = 1:length(sign)
    figure
    imshow(sign(:,:,:,i))
end
