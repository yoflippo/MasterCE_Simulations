%% Converted from Vinay: tri-loc2.py

function locations = solver_murphy_3d(distances,ancloc)

locations = newton_non_linear(distances,ancloc);

%% ============================== Nested functions ==============================
    function out = newton_non_linear(r,a)
        loc = linearsystem(r,a);
        good = jtjf(loc);
        rint = loc;
        for i = 1:50
            if not(det(good.jtj)==0)
                rfinal = rint - (inv(good.jtj)*good.jtf');
            else
                rfinal = rint - (pinv(good.jtj)*good.jtf');
            end
            rdiff = abs(rfinal-rint);
            if rdiff(1)<0.0000001 && rdiff(2)<0.0000001
                out = rfinal;
                break;
            end
            good = jtjf(rfinal);
            rint = rfinal;
        end
        out = rfinal;
    end

    function out  = jtjf(loc)
        fv = fi(loc);
        se1 = 0; se2 = 0; se3=0;
        sym1 = 0; sym2 = 0; sym3 = 0;
        s4 = 0;
        s5 = 0;
        s6 = 0;
        n = length(ancloc);
        for i = 1:n
            el1x1 = (loc(1)-ancloc(i,1))^2 / normjtjf(fv,i);
            se1 = se1 + el1x1;
            
            el2x2 = (loc(2)-ancloc(i,2))^2 / normjtjf(fv,i);
            se2 = se2 + el2x2;
            
            el3x3 = (loc(3)-ancloc(i,3))^2 / normjtjf(fv,i);
            se3 = se3 + el3x3;
            
            var =   (loc(1)-ancloc(i,1))*(loc(2)-ancloc(i,2)) / normjtjf(fv,i);
            sym1 = sym1 + var;
            
            var =   (loc(1)-ancloc(i,1))*(loc(3)-ancloc(i,3)) / normjtjf(fv,i);
            sym2 = sym2 + var;
            
            var =   (loc(2)-ancloc(i,2))*(loc(3)-ancloc(i,3)) / normjtjf(fv,i);
            sym3 = sym3 + var;
        end
        out.jtj = [se1 sym1 sym2;
            sym1 se2 sym3;
            sym2 sym3 se3];
        
        
        for i = 1:n
            var = ((loc(1)-ancloc(i,1))*fv(i)) / (fv(i)+distances(i));
            s4 = s4 + var;
            
            var = (loc(2)-ancloc(i,2))*fv(i) / (fv(i)+distances(i));
            s5 = s5 + var;
            
            var = (loc(3)-ancloc(i,3))*fv(i) / (fv(i)+distances(i));
            s6 = s6 + var;
        end
        
        out.jtf = [s4 s5 s6];
    end

    function out = normjtjf(fv,i)
        out = (fv(i)+distances(i))^2;
    end

    function out = fi(loc)
        for i = 1:length(ancloc)
            out(i) = sqrt( (loc(1)-ancloc(i,1))^2 + (loc(2)-ancloc(i,2))^2 + (loc(3)-ancloc(i,3))^2) - distances(i);
            %         out(1) = sqrt((loc(1)-ancloc(1,1))^2 + (loc(2)-ancloc(1,2))^2) - distances(1);
            %         out(2) = sqrt((loc(1)-ancloc(2,1))^2 + (loc(2)-ancloc(2,2))^2) - distances(2);
            %         out(3) = sqrt((loc(1)-ancloc(3,1))^2 + (loc(2)-ancloc(3,2))^2) - distances(3);
        end
    end

    function loc = linearsystem(r,a)
        [~,c1] = size(a);
        aref = a(1,:);
        for i = 2:length(a)
            d(i-1) = ((a(i,1)-aref(1,1))^2) + ((a(i,2)-aref(1,2))^2) + ((a(i,3)-aref(1,3))^2);
            b(i-1) = 0.5 * ((r(1)^2)-(r(i)^2)) + d(i-1);
            %         d21 = ((a(2,1)-a(1,1))^2) + ((a(2,2)-a(1,2))^2);
            %         d31 = ((a(3,1)-a(1,1))^2) + ((a(3,2)-a(1,2))^2);
            %         b21 = 0.5 * ((r(1)^2)-(r(2)^2) + d21);
            %         b31 = 0.5 * ((r(1)^2)-(r(3)^2) + d31);
            ad(i-1,1:c1) = a(i,:)-aref;
        end
        A = ad; B = b;
        %         A = [a(2,:)-a(1,:); a(3,:)-a(1,:)];
        %         B = [b21 b31];
        AT = A'; BT = B';
        DE = AT*A;
        DB = AT*BT; %TODO diverges from Python version
        if det(DE) > 0
            v = inv(DE)*DB; % uses the pseudo inverse, TODO: check in murphy documentation
        else
            p = pinv(A);
            v = p*B';
        end
        loc = v + aref';
    end


end %main function
