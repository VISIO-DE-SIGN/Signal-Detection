function [BBs_table] = Detection(image,debug_mode)

% Trafic Sign detection from image
I = image;

%%
% Only blue and red pixels
B = I(:,:,3) - I(:,:,1) - I(:,:,2);
R = I(:,:,1) - I(:,:,2) - I(:,:,3);

%%
%Adjust dinamic range
%{
B = B / max(B(:)) * 255;
R = R / max(R(:)) * 255;
%}

%%
% Binarizing image
blue = imbinarize(B,'adaptive');
red = imbinarize(R,'adaptive');

%%
% recorte de franja de 2 pixeles
blue = blue(3:end-2,3:end-2);
red = red(3:end-2,3:end-2);

%%
% Find circles
[centers_r, radii_r, metric_r] = imfindcircles(red,[10 50]);
[centers_b, radii_b, metric_b] = imfindcircles(blue,[10 50]);

% Selecting circles with a greater metric than threshold
metric_threshold = 0.6;

centersB_ok = centers_b(metric_b > metric_threshold,:);
radiiB_ok = radii_b(metric_b > metric_threshold);

centersR_ok = centers_r(metric_r > metric_threshold,:);
radiiR_ok = radii_r(metric_r > metric_threshold);

%%
% show red and blue areas (and respective circles)
if debug_mode
    figure
    imshow(blue);
    title('Blue areas');
    viscircles(centers_b, radii_b,'EdgeColor','b');

    figure
    imshow(red);
    title('Red areas');
    viscircles(centers_r, radii_r,'EdgeColor','r');
end

%%
% Getting regions 
caract_red = regionprops(red,'all');
caract_blue = regionprops(blue,'all');

%%
% Filtering regions

goodBBindex_red = filter_by_area(caract_red, [10 inf]);
goodBBindex_blue = filter_by_area(caract_blue, [10 inf]);

red_regions = caract_red(goodBBindex_red);
blue_regions = caract_blue(goodBBindex_blue);
%showBB(I,red_regions,'red',true,false);
%showBB(I,blue_regions,'blue',true,false);
%goodBBindex_red = filter_by_aspRatio(red_regions,1,0.5, false);
%red_regions = red_regions(goodBBindex_red);

BBs_blue = region2BB(blue_regions);
BBs_red = region2BB(red_regions);

BBs_all = [BBs_blue;BBs_red];

diferent = false;
last_BBs = BBs_all;
while 1
    mergedBB = mergeBBs(last_BBs,1);
    if length(last_BBs) == length(mergedBB)
        break
    end
    last_BBs = mergedBB;
end

% show merged
%{
for i=1:length(mergedBB)
    rect = [mergedBB(i).x, mergedBB(i).y, mergedBB(i).width, mergedBB(i).height];
    rectangle('Position',rect,'EdgeColor','green');
end
%}

goodBBindex_all = filter_by_aspRatio(mergedBB,1,0.5, true);
good_BBs = mergedBB(goodBBindex_all);
goodBBindex_all = filter_by_area(good_BBs, [1000 20000],true);
good_BBs = good_BBs(goodBBindex_all);

%%
% Showing regions that follow some criteria
if debug_mode
    showBB(I,good_BBs,'blue',true,true);
end

BBs_table = good_BBs;


end