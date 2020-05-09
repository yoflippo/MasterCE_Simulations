function [is1, is2] = circleIntersection(A,B,ra,rb)

% A = [0 0]; %# center of the first circle
% B = [1 0]; %# center of the second circle
% ra = 0.7; %# radius of the SECOND circle
% rb = 0.9; %# radius of the FIRST circle
c = norm(A-B); %# distance between circles

cosAlpha = (rb^2+c^2-ra^2)/(2*rb*c);

u_AB = (B - A)/c; %# unit vector from first to second center
pu_AB = [u_AB(2), -u_AB(1)]; %# perpendicular vector to unit vector

%# use the cosine of alpha to calculate the length of the
%# vector along and perpendicular to AB that leads to the
%# intersection point
is1 = A + u_AB * (rb*cosAlpha) + pu_AB * (rb*sqrt(1-cosAlpha^2));
is2 = A + u_AB * (rb*cosAlpha) - pu_AB * (rb*sqrt(1-cosAlpha^2));

end