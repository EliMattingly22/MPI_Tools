# This is to facilitate conversion of MATLAB codes to Julia, if needed.



@doc """
meshgrid is similar to MATLAB's function. It takes in a range, vector, matrix or similar
and makes an array of those values.
In the case of a cartesian grid, it would like an 'X' and 'Y' vectors and make a matrix filled with
the X and Y coordinates:
julia> X = 0:3
julia> Y = 0:3
julia> XX,YY = meshgrid(X,Y)
julia> XX
4×4 Array{Int64,2}:
 0  0  0  0
 1  1  1  1
 2  2  2  2
 3  3  3  3
 julia> YY
 4×4 Array{Int64,2}:
 0  1  2  3
 0  1  2  3
 0  1  2  3
 0  1  2  3

 If a single vector/range is inputted, for example X = 0:3 , it will output interpret it as meshgrid(X,X)

"""-> function meshgrid(xs, ys)
    [xs[i] for i in 1:length(xs), j in 1:length(ys), k in 1:length(ys)], [ys[j] for i in 1:length(xs), j in 1:length(ys)]
end

function meshgrid(xs;dims=3)
    if dims==3
        meshgrid(xs, xs,xs)
    elseif dims==2
        meshgrid(xs, xs)
    end

end

function meshgrid(xs,ys,zs)
    return ([xs[i] for i in 1:length(xs), j in 1:length(ys), k in 1:length(zs)],
    [ys[j] for i in 1:length(xs), j in 1:length(ys), k in 1:length(zs)],
    [zs[k] for i in 1:length(xs), j in 1:length(ys), k in 1:length(zs)])

end
