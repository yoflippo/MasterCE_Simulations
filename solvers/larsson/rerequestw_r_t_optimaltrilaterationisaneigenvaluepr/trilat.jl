using LinearAlgebra

# Signal strengths instead of distance measurments.
# C = C0 - 10η * log10(d)
function trilat(s0, C, C0, η; use_eigenvector = true)
    m = 2log(10) * (C0 .- C) ./ 10η
    d2 = exp.(m)
    w = exp.(-2m)
    return trilat(s0, d2, w, use_eigenvector = use_eigenvector)
end

function trilat(s0, d2, w = 1 ./ 4d2; use_eigenvector = true)
    n = size(s0, 1)

    # Normalize weights.
    w = w / sum(w)

    # Shift center.
    t = s0 * w
    s = s0 .- t

    # Construct A, b such that (x' * x) * x + A * x + b = 0.
    ws2md2 = w .* (sum(s .^ 2, dims = 1)' - d2)
    A = 2 * (s .* w') * s' + sum(ws2md2) * I
    b = -s * ws2md2

    if !all(isfinite.(A))
        return zeros(n, 0)
    end

    F = eigen(A)
    V = F.vectors
    D = diagm(F.values)
    bb = V' * b

    # Basis = [x^2, y^2, z^2, x, y, z, 1].
    AM = [
        -D diagm(-vec(bb)) zeros(n, 1)
        zeros(n, n) -D -bb
        ones(1, n) zeros(1, n + 1)
    ]

    if use_eigenvector
        FF = eigen(AM)
        VV = FF.vectors
        DD = FF.values
        VV = VV ./ transpose(VV[end, :])
        r = V * VV[n+1:2n, :]
    else
        # Eigenvector-less solution extraction.
        DD = eigenvals(AM)
        r = zeros(n, 2n + 1)
        for k = 1:2n+1
            z = [zeros(n, n); -I]
            T = AM - DD[k] * I
            r[:, k] = transpose(transpose(T[:, 1:end-1]) \ z) * T[:, end]
        end
        r = V * r
    end

    # Perform some refinement on the roots.
    for i = 1:2n+1
        ri = r[:, i]
        if maximum(abs.(imag(ri))) > 1e-6
            continue
        end
        for k = 1:3
            res = (ri' * ri) .* ri + A * ri + b
            if norm(res) < 1e-8
                break
            end
            J = (ri' * ri) * I + 2 * (ri * ri') + A
            ri = vec(ri - J \ res)
        end
        r[:, i] = ri
    end

    # Revert translation of coordinate system.
    sols = r .+ t

    # Find best stationary point.
    cost = Inf
    R = zeros(n, 0)
    for k = 1:size(sols, 2)
        if sum(abs.(imag(sols[:, k]))) > 1e-6
            continue
        end
        rk = real(sols[:, k])
        cost_k = dot((sum((rk .- s0) .^ 2, dims = 1) - d2') .^ 2, w)
        if cost_k < cost
            cost = cost_k
            R = rk
        end
    end

    # if nargout == 3
    #     lambda = DD
    #     res = []
    #     for k = 1:2*n+1
    #         rk = r[:, k]
    #         lambdak = lambda[k]
    #         res[:, k] = [
    #             (transpose(rk) * rk) * rk + A * rk + b
    #             lambdak - transpose(rk) * rk
    #         ]
    #     end
    #     return R, sols, res
    # end
    return R
end
