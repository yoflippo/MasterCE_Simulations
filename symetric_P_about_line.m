function S = symetric_P_about_line(P,m,n)

if isnan(P)
    S = P;
    return;
end

% line of symmetry: y = m*x + n;
Md = zeros(1,2); % Middle point between given point and its symmetric
Md(1) = (P(1) + m*P(2) - m*n)/(m^2 + 1);
Md(2) = m*Md(1) + n;
S = 2*Md - P; % symmetric point of P about given line