function [index] = filter_by_aspRatio(regions,ratio,tolerance,BB_format)
%filters Bounding boxes by their aspect ratio
%   inputs: regions     -> BB to be filtered
%           ratio       -> defined aspect ratio
%           tolerance   -> variance allowed of the ratio in percentage
%   output: index       -> retuns the index of BBs that meet the condition

index = [];
cont = 1;

for i = 1:length(regions)
    if BB_format
        width = regions.width;
        height = regions.height;
    else
        BB = regions(i).BoundingBox;
        width = BB(:,3);
        height = BB(:,4);
    end
    
    if(width/height > ratio - tolerance && width/height < ratio + tolerance)
        index(cont) = i;
        cont = cont+1;
    end

end

