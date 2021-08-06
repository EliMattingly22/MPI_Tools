module MPI_Tools

include("MyFFT.jl")
include("THD.jl")
include("MyBisect.jl")



# Write your package code here.
function Test(A,B)
  plot(A,B)
end

end
