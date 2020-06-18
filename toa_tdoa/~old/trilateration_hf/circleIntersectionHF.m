function [is1, is2] = circleIntersectionHF(A,B,ra,rb)
D = norm(B-A);
Sa = (ra^2 - rb^2 + D^2) / (2*D);
AM = Sa*((B-A)/D);

if (ra^2-Sa^2) < 0
    is1 = [NaN; NaN]; is2 = is1;
    return;
end

q = sqrt(ra^2-Sa^2);
 
AB = B-A;
MS1 = [-AB(2); AB(1)];
MS2 = [AB(2); -AB(1)];

is1 = A + AM + (MS1/norm(MS1))*q ;
is2 = A + AM + (MS2/norm(MS2))*q ;