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
    BB1 = BBs(i);
    c1 = [BB1.x+BB1.width/2, BB1.y+BB1.height/2];
    r1 = sqrt(BB1.width^2/4 + BB1.height^2/4);
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
        BB2 = BBs(j);
        c2 = [BB2.x+BB2.width/2, BB2.y+BB2.height/2];
        r2 = sqrt(BB2.width^2/4 + BB2.height^2/4);
        dist = sqrt((c1(1)-c2(1))^2 + (c1(2)-c2(2))^2);
        if dist < r1 + r2 + margin
            count = count + 1;
            %get min x
            if BB1.x < BB2.x
                minX = BB1.x;
            else 
                minX = BB2.x;
            end
            
            %get max x
            if BB1.x+BB1.width > BB2.x+BB2.width
                maxX = BB1.x+BB1.width;
            else 
                maxX = BB2.x+BB2.width;
            end
            
            %get min y
            if BB1.y < BB2.y
                minY = BB1.y;
            else 
                minY = BB2.y;
            end
            
            %get max y
            if BB1.y+BB1.height > BB2.y+BB2.height
                maxY = BB1.y+BB1.height;
            else 
                maxY = BB2.y+BB2.height;
            end
            %new BB
            newBB.x = minX;
            newBB.y = minY;
            newBB.width = maxX - minX;
            newBB.height = maxY - minY;
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
        non_merged_BBs = [non_merged_BBs; BBs(i)];
    end
end
final_BBs = [final_BBs; non_merged_BBs];
end

