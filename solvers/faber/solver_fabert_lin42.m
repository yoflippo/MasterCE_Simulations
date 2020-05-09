function location = solver_fabert_lin4(distances,anchorloc)

%% Create some help variables
[N,~] = size(anchorloc);
sumXp2 = anchorCoordinatesSumSquared(1,anchorloc);
sumYp2 = anchorCoordinatesSumSquared(2,anchorloc);
sumXp = anchorCoordinatesSum(1,anchorloc);
sumYp = anchorCoordinatesSum(2,anchorloc);
ai_w = (2*sumXp / N); 
bi_w = (2*sumYp / N); 
di_w = ((-sumXp2-sumYp2) / N); 


%% Calculate location
f = [ones(1,N) 0 0 0]; %constraints
A = createMatrixA();
b = zeros(size(A,1),1);
for i = 1:N
    b(2*i-1,1) = -di(i);
    b(2*i,1) = di(i);
end    
Aeq = [];
beq = [];
ub = [];
lb = ones(size(A,2),1)*-Inf;
lb(end) = 0;

[loc,fval,exitflag,output] = linprog(f',A,b,Aeq,beq,lb,ub);% Ax<b
location = loc(end-2:end);


%% ============================== Nested functions ==============================
    function a = createMatrixA()
        cnt = 1;
        for n = 1:N
            padding = zeros(1,N); 
            padding(n)=-1;
            idxr = 1:(3+N);
            a(cnt,idxr) = [padding ai(n) bi(n) ci(n)];
            cnt = cnt + 1;
            a(cnt,idxr) = [padding  -ai(n) -bi(n) -ci(n)];
            cnt = cnt + 1;
        end
    end

    function result = ai(i)
        result = (ai_w - 2*anchorloc(i,1));
    end

    function result = bi(i)
        result = (bi_w - 2*anchorloc(i,2));
    end

    function result = ci(i)
        result = 1/(N);
    end

    function result = di(i)
        result = ((di_w + (anchorloc(i,1)^2 + anchorloc(i,2)^2))) - distances(i)^2;
    end

    function result = anchorCoordinatesSumSquared(dim,anchorloc)
        result = sum(anchorloc(:,dim).^2);
    end

    function result = anchorCoordinatesSum(dim,anchorloc)
        result = sum(anchorloc(:,dim));
    end

end %main function