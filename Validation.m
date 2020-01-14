% Processing images for validation
clear

%Set dataset path
dataset_path = getenv('Dataset_path');

%%
% list of image names
folder = strcat(dataset_path, "\camera00\00");
im_names = dir(folder);
im_names = im_names(4:end);
im_names = struct2table(im_names);
im_names = im_names.name;
im_names = cell2mat(im_names);

%%
% Opening anotations
file = open('anotations.mat');
anotations = file.anotations;
clearvars file

n_good = 0;
n_bad = 0;
n_missed = 0;

%n_imagenes = length(im_names);
n_imagenes = 50;

for i = 1:n_imagenes
    disp(i);
    
    % Charging image
    im_path = strcat(dataset_path, "\camera00\00\" ,im_names(i,:));
    I = imread(im_path);
    BBs = Detection(I);
    
    
    im_name = strcat("00/", im_names(i,:));
    gnd_truth = anotations(anotations.image_name == im_name, :);
    [n_signs,ans] = size(gnd_truth);
    [n_BBs,ans] = size(BBs);
    
    %IoU
    iou_threshold = 0.5;
    good_detection = [];
    iou = [];
    for j = 1:n_signs
        sign_detected = false;
        for k = 1:n_BBs
            xi1 = max([gnd_truth(j,2).x1, BBs(k,1)]);
            yi1 = max([gnd_truth(j,3).y1, BBs(k,2)]);
            xi2 = min([gnd_truth(j,4).x2, BBs(k,1)+BBs(k,3)]);
            yi2 = min([gnd_truth(j,5).y2, BBs(k,2)+BBs(k,4)]);
            %comprobacion solape
            if (xi2 < xi1 || yi2 < yi1)
                continue
            end
            inter_area = (xi2 - xi1)*(yi2 - yi1);
            
            box1_area = (gnd_truth(j,5).y2 - gnd_truth(j,3).y1)*(gnd_truth(j,4).x2- gnd_truth(j,2).x1);
            box2_area = BBs(k,3) * BBs(k,4);
            union_area = (box1_area + box2_area) - inter_area;
            
            IoU = inter_area / union_area;
            iou = [iou, IoU];
            if IoU > iou_threshold
                good_detection = [good_detection,k];
                sign_detected = true;
            end
        end
        
        %Si la señal no se ha detectado se apunta
        if sign_detected == false
            n_missed = n_missed +1;
        end
        
    end
    
    n_good = n_good + length(good_detection);
    n_bad = n_bad + n_BBs - n_good;
    
end

n_repetidas = n_good + n_missed - n_imagenes;


