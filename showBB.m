function [] = showBB(image, regions, color)
%filters Bounding boxes by their aspect ratio
%   inputs: regions     -> BB to be shown
%           image       -> base image
%   output: NONE

if nargin < 3
   	color = 'blue';
end

figure
imshow(image);
for i = 1:length(regions)
    x = regions(i).BoundingBox(:,1);
    y = regions(i).BoundingBox(:,2);
    rectangle('Position',regions(i).BoundingBox,'EdgeColor',color);
    text(x, y, num2str(regions(i).Area),'Color',color,'FontSize',14);
end