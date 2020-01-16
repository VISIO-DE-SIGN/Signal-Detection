function [index] = filter_by_area(regions,area,BB_format)
%filters Bounding boxes by their aspect ratio
%   inputs: regions     -> BB to be filtered
%           area []     -> minimum and maximm area
%   output: index       -> retuns the index of BBs that meet the condition

if nargin < 3
    BB_format = false;
end

index = [];
cont = 1;

min_area = area(1);
max_area = area(2);

if BB_format
    for i = 1:length(regions)
        area = regions(i).width * regions(i).height;
        if(area >= min_area && area <= max_area)
            index(cont) = i;
            cont = cont+1;
        end
    end
else
    for i = 1:length(regions)
        if(regions(i).Area >= min_area && regions(i).Area <= max_area)
            index(cont) = i;
            cont = cont+1;
        end

    end
end