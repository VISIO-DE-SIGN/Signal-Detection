function [diff] = getBlobImage(image)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[res_v, res_h] = size(image);

diff = zeros(res_v,res_h);
for i = 1:res_v
    for j = 1:res_h
        cum = 0;
        for m = i-1:i+1
            if m-1 < 1 || m+1 > res_v
                continue
            end
            for n = j-1:j+1
                if n-1 < 1 || n+1 > res_h
                    continue
                end
                dif = abs(double(image(i,j)) - double(image(m,n)));
                cum = cum + dif;
            end
        end
        diff(i,j) = cum;
    end
end

%normalizamos la imagen
diff = diff / max(diff,[],'all');

end

