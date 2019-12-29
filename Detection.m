% Signal detection

%%
% Charging image
dataset_path = getenv('Dataset_path');
image = strcat(dataset_path, "\camera00\00\image.000060.jp2");  %191 %60 %4766
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