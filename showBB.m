function [] = showBB(image, regions, color, hold, BB_format)
%filters Bounding boxes by their aspect ratio
%   inputs: regions     -> BB to be shown
%           image       -> base image
%   output: NONE

if nargin < 3
   	color = 'blue';
    BB_format = false;
end

if (hold)
    figure
    imshow(image);
end

if BB_format
    for i = 1:length(regions)
        x = regions(i).x;
        y = regions(i).y;
        w = regions(i).width;
        h = regions(i).height;
        bb = [x,y,w,h];
        area = w*h;
        rectangle('Position',bb,'EdgeColor',color);
        text(x, y, num2str(area),'Color',color,'FontSize',12);
    end
else
    for i = 1:length(regions)
        x = regions(i).BoundingBox(:,1);
        y = regions(i).BoundingBox(:,2);
        rectangle('Position',regions(i).BoundingBox,'EdgeColor',color);
        text(x, y, num2str(regions(i).Area),'Color',color,'FontSize',14);
    end
end
