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


