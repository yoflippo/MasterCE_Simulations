function d = dis(posa,posb)
[ra,ca] = size(posa);
[rb,cb] = size(posb);

if ra == rb && ca == cb % input has same size
        d = sqrt(sum((posb-posa).^2));
else
    for r1 = 1:ra % different size
        for r2 = 1:rb
            d(r1,r2) = sqrt((posb(r2,1)-posa(r1,1)).^2+(posb(r2,2)-posa(r1,2)).^2);
        end
    end
end

end