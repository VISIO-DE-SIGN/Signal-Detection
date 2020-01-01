function [index] = filter_by_area(regions,area)
%filters Bounding boxes by their aspect ratio
%   inputs: regions     -> BB to be filtered
%           area        -> minimum area
%   output: index       -> retuns the index of BBs that meet the condition

index = [];
cont = 1;

for i = 1:length(regions)
    if(regions(i).Area > area)
        index(cont) = i;
        cont = cont+1;
    end

end