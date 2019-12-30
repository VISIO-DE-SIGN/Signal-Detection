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
% Showing regions that follow some criteria
imshow(I);
goodBBindex_red = [];
cont = 1;
for i = 1:length(caract_red)
	BB = caract_red(i).BoundingBox;
	width = BB(:,3);
	height = BB(:,4);
    if((caract_red(i).Area >= 100) && (abs(height - width)/height) < 0.4)
        rectangle('Position',caract_red(i).BoundingBox,'EdgeColor','r');
		text(caract_red(i).BoundingBox(:,1),caract_red(i).BoundingBox(:,2),num2str(caract_red(i).Area),'Color','red',...
		'FontSize',14);
        goodBBindex_red(cont) = i;
        cont = cont+1;
    end
end

goodBBindex_blue = [];
cont = 1;
for i = 1:length(caract_blue)
	BB = caract_blue(i).BoundingBox;
	width = BB(:,3);
	height = BB(:,4);
    if((caract_blue(i).Area >= 100) && (abs(height - width)/height) < 0.4)
        rectangle('Position',caract_blue(i).BoundingBox,'EdgeColor','b');
		text(caract_blue(i).BoundingBox(:,1),caract_blue(i).BoundingBox(:,2),num2str(caract_blue(i).Area),'Color','blue',...
		'FontSize',14);
        goodBBindex_blue(cont) = i;
        cont = cont+1;
    end
end

%%
% saving those regions as new images
% they will be passed to the clasification neural net.

% preallocation for 100x100 resolution images
num_red = length(goodBBindex_red);
num_blue = length(goodBBindex_blue);
sign = uint8(zeros(100,100,3,num_red+num_blue));

for i = 1:num_red
    x = caract_red(goodBBindex_red(i)).BoundingBox(1);
    y = caract_red(goodBBindex_red(i)).BoundingBox(2);
    w = caract_red(goodBBindex_red(i)).BoundingBox(3);
    h = caract_red(goodBBindex_red(i)).BoundingBox(4);
    signal = I(y:y+h,x:x+w,:);
    sign(:,:,:,i) = imresize(signal,[100,100]);
end

for i = 1:num_blue
    x = caract_blue(goodBBindex_blue(i)).BoundingBox(1);
    y = caract_blue(goodBBindex_blue(i)).BoundingBox(2);
    w = caract_blue(goodBBindex_blue(i)).BoundingBox(3);
    h = caract_blue(goodBBindex_blue(i)).BoundingBox(4);
    signal = I(y:y+h,x:x+w,:);
    sign(:,:,:,num_red+i) = imresize(signal,[100,100]);
end

%%
% Show traffic signs detected

for i = 1:num_red+num_blue
    figure
    imshow(sign(:,:,:,i))
end
