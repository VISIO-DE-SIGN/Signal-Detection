function [BBs] = region2BB(regions)
%converts regions to Bounding boxes
%   inputs: regions     -> regions to be converted
%   output: BBs         -> Bounding boxes as structs

BBs = [];
for i=1:length(blue_regions)
    BB = regions(i).BoundingBox;
    bb.x = BB(1);
    bb.y = BB(2);
    bb.width = BB(3);
    bb.height = BB(4);
    BBs = [BBs; bb];
end
end

