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
    viscircles(centersB_ok, radiiB_ok,'EdgeColor','b');

    figure
    imshow(red);
    title('Red areas');
    viscircles(centersR_ok, radiiR_ok,'EdgeColor','r');
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
% Include circle regions
BB_cir = [];
for i = 1:length(radiiB_ok)
    bb.x = centersB_ok(i,1) - radiiB_ok(i);
    bb.y = centersB_ok(i,2) - radiiB_ok(i);
    bb.width = radiiB_ok(i) * 2;
    bb.height = radiiB_ok(i) * 2;
    BB_cir = [BB_cir ; bb];
end

for i = 1:length(radiiR_ok)
    bb.x = centersR_ok(i,1) - radiiR_ok(i);
    bb.y = centersR_ok(i,2) - radiiR_ok(i);
    bb.width = radiiR_ok(i) * 2;
    bb.height = radiiR_ok(i) * 2;
    BB_cir = [BB_cir ; bb];
end

good_BBs = [good_BBs; BB_cir];

%%
%IoU of circle regions
%{
BBs = good_BBs;
[n_cir,ans] = size(BB_cir);
[n_BBs,ans] = size(BBs);

iou_threshold = 0.7;
good_detection = [];
iou = [];
for j = 1:n_cir
    for k = 1:n_BBs
        xi1 = max([BB_cir(k).x, BBs(k).x]);
        yi1 = max([BB_cir(k).y, BBs(k).y]);
        xi2 = min([BB_cir(k).x+BB_cir(k).width, BBs(k).x+BBs(k).width]);
        yi2 = min([BB_cir(k).y+BB_cir(k).height, BBs(k).y+BBs(k).height]);
        %comprobacion solape
        if (xi2 < xi1 || yi2 < yi1)
            continue
        end
        inter_area = (xi2 - xi1)*(yi2 - yi1);
            
        box1_area = BB_cir(k).width * BB_cir(k).height;
        box2_area = BBs(k).width * BBs(k).height;
        union_area = (box1_area + box2_area) - inter_area;
            
        IoU = inter_area / union_area;
        iou = [iou, IoU];
        if IoU > iou_threshold
            good_detection = [good_detection,k];
        end        
    end
end
%}


%%
% Showing regions that follow some criteria

if debug_mode
    showBB(I,good_BBs,'blue',true,true);
end

BBs_table = good_BBs;

end