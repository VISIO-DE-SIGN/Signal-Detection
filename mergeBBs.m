function [final_BBs] = mergeBBs(BBs,margin)
%Merges Bounding boxes that are near to each other.
%   inputs: BBs         -> BB to analize
%           margin      -> max distance between separated regions

%   output: final_regions -> the final BBs
final_BBs = [];
joined = [];
nJoin = 0;
count = 0;
for i = 1:length(BBs)
    %Comprueba que i no se ha unido ya
    k = find(joined==i,1);
    if isempty(k)==0
        continue;
    end
    %Obtencion de centro y radio
    BB1 = BBs(i,:);
    c1 = [BB1(1)+BB1(3)/2, BB1(2)+BB1(4)/2];
    r1 = sqrt(BB1(3)^2/4 + BB1(4)^2/4);
    %viscircles(c1,r1);
    for j = i:length(BBs)
        if (j == i)
            continue;
        end
        %Comprueba que j no se ha unido ya
        k = find(joined==j,1);
        if isempty(k)==0
            continue;
        end
        BB2 = BBs(j,:);
        c2 = [BB2(1)+BB2(3)/2, BB2(2)+BB2(4)/2];
        r2 = sqrt(BB2(3)^2/4 + BB2(4)^2/4);
        dist = sqrt((c1(1)-c2(1))^2 + (c1(2)-c2(2))^2);
        if dist < r1 + r2 + margin
            count = count + 1;
            %get min x
            if BB1(1) < BB2(1)
                minX = BB1(1);
            else 
                minX = BB2(1);
            end
            
            %get max x
            if BB1(1)+BB1(3) > BB2(1)+BB2(3)
                maxX = BB1(1)+BB1(3);
            else 
                maxX = BB2(1)+BB2(3);
            end
            
            %get min y
            if BB1(2) < BB2(2)
                minY = BB1(2);
            else 
                minY = BB2(2);
            end
            
            %get max y
            if BB1(2)+BB1(4) > BB2(2)+BB2(4)
                maxY = BB1(2)+BB1(4);
            else 
                maxY = BB2(2)+BB2(4);
            end
            %new BB
            widthX = maxX - minX;
            widthY = maxY - minY;
            newBB = [minX, minY, widthX, widthY];
            final_BBs = [final_BBs;newBB];
            %%{
            nJoin = nJoin + 2;
            %verifica si i se ha unido ya
            k = find(joined==i,1);
            if isempty(k)
                joined = [joined,i];
            end
            %verifica si j se ha unido ya
            k = find(joined==j,1);
            if isempty(k)
                joined = [joined,j];
            end
            %}
            %rectangle('Position',newBB,'EdgeColor','green');
            
        end
    end
    
end

%not merged list
non_merged_BBs = [];
for i = 1:length(BBs)
    k = find(joined==i,1);
    if isempty(k)
        non_merged_BBs = [non_merged_BBs; BBs(i,:)];
    end
end
final_BBs = [final_BBs; non_merged_BBs];
end

