function [index] = filter_by_area(regions,min_area,BB_format)
%filters Bounding boxes by their aspect ratio
%   inputs: regions     -> BB to be filtered
%           min_area    -> minimum area
%   output: index       -> retuns the index of BBs that meet the condition

index = [];
cont = 1;

if BB_format
    for i = 1:length(regions)
        area = regions(i).width * regions(i).height;
        if(area >= min_area)
            index(cont) = i;
            cont = cont+1;
        end
    end
else
    for i = 1:length(regions)
        if(regions(i).Area >= min_area)
            index(cont) = i;
            cont = cont+1;
        end

    end
end