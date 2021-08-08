function FFT_1s(TimeDomain::Vector;fs=1, Window ="Hanning",PlotOn=false)
    ## This function takes in a time domain vector, optional sampling rate "fs," and optional Hanning window
L = length(TimeDomain)
if Window=="Hanning"
    CorFac = 2
    Window = WindowHanning(L)
elseif Window=="none"
    CorFac = 1
else
    error("Window not recognized")

end
WindowedData = TimeDomain .* Window
if L%2==1
    EndIndex = Int(round(L/2))
else
    EndIndex = Int(round(L/2))
end
FTData_1s = fft(WindowedData)[1:EndIndex]
FTData_1s = FTData_1s ./ L #Corrects for vector length
freqs = fftfreq(L,fs)[1:EndIndex]

if PlotOn
    plot(fftfreq(L),abs.(fft(WindowedData))./L)
    plot(freqs,abs.(FTData_1s),"ro")
end

return freqs,FTData_1s
end


function WindowHanning(N)
    return 0.5 .- 0.5 .* cos.(2 .* pi .* collect(0:(N-1)) ./ (N-1))
end
