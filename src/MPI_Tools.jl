module MPI_Tools

using FFTW, Optim, HDF5, PyPlot
const μ₀ = 4*π*1e-7
const ϵ₀ = 8.85e-12
mu0 = μ₀
include("MyFFT.jl")
include("THD.jl")
include("MyBisect.jl")
include("meshgrid.jl")
export meshgrid,
       FFT_1s,
       FFT_1s_to2s,
       μ₀,mu0,ϵ₀,
       mybisect,
       THD_TimeSeries


# Write your package code here.


end
