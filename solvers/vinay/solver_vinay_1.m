%% Converted from Vinay: tri-loc2.py

function locations = solver_vinay_1(distances,ancloc)

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
                rfinal = rint - (pinv(good.jtj)*good.jtf);
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
        s1 = 0; s2 = s1; s3 = s1; s4 = s1; s5 = s1;
        for i = 1:3
            el1x1 = (loc(1)-ancloc(i,1))^2 / normjtjf(fv,i);
            s1 = s1 + el1x1;
        end
        
        for i = 1:3
            el2x2 = (loc(2)-ancloc(i,2))^2 / normjtjf(fv,i);
            s2 = s2 + el2x2;
        end
        
        for i = 1:3
            var = (loc(1)-ancloc(i,1))*(loc(2)-ancloc(i,2)) / normjtjf(fv,i);
            s3 = s3 + var;
        end
        out.jtj = [s1 s3; s3 s2];
        
        for i = 1:3
            var = ((loc(1)-ancloc(i,1))*fv(i)) / (fv(i)+distances(i));
            s4 = s4 + var;
        end
        
        for i = 1:3
            var = (loc(2)-ancloc(i,2))*fv(i) / (fv(i)+distances(i));
            s5 = s5 + var;
        end
        
        out.jtf = [s4 s5];
    end

    function out = normjtjf(fv,i)
        out = (fv(i)+distances(i))^2;
    end

    function out = fi(loc)
        out(1) = sqrt((loc(1)-ancloc(1,1))^2 + (loc(2)-ancloc(1,2))^2) - distances(1);
        out(2) = sqrt((loc(1)-ancloc(2,1))^2 + (loc(2)-ancloc(2,2))^2) - distances(2);
        out(3) = sqrt((loc(1)-ancloc(3,1))^2 + (loc(2)-ancloc(3,2))^2) - distances(3);
    end

    function loc = linearsystem(r,a) %only use the first 3 anchors just as Vinay did
        d21 = ((a(2,1)-a(1,1))^2) + ((a(2,2)-a(1,2))^2);
        d31 = ((a(3,1)-a(1,1))^2) + ((a(3,2)-a(1,2))^2);
        b21 = 0.5 * ((r(1)^2)-(r(2)^2) + d21);
        b31 = 0.5 * ((r(1)^2)-(r(3)^2) + d31);
        A = [a(2,:)-a(1,:); a(3,:)-a(1,:)];
        B = [b21 b31];
        AT = A'; BT = B';
        DE = AT*A;
        DB = AT*BT; %TODO diverges from Python version
        if det(DE) > 0
            v = inv(DE)*DB; % uses the pseudo inverse, TODO: check in murphy documentation
        else
            p = pinv(A);
            v = p*B';
        end
        loc = v + a(1,:)';
    end


end %main function
