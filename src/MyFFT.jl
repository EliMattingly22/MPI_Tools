function FFT_1s(TimeDomain::Vector;fs=1, Window ="Hanning")
    ## This function takes in a time domain vector, optional sampling rate "fs," and optional Hanning window
if Window=="Hanning"
    CorFac = 2
    Window = WindowHanning(length(TimeDomain))
elseif Window=="none"
    CorFac = 1
else
    error("Window not recognized")

end
WindowedData = TimeDomain .* Window

FTData_1s = fft(WindowedData)[1:Int(round(length(TimeDomain)/2))+1]
FTData_1s = FTData_1s ./ length(TimeDomain) #Corrects for vector length
freqs = fftfreq(length(WindowedData))[1:Int(round(length(TimeDomain)/2))+1]


return freqs,FTData_1s
end


function WindowHanning(N)
    return 0.5 .- 0.5 .* cos.(2 .* pi .* collect(0:(N-1)) ./ (N-1))
end
