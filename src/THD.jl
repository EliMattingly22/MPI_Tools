function THD_TimeSeries(TimeDataIn::Vector;MaxHarmonics=10, PlotOn=true)
    #TimeDataIn is the data in question
    #This method has no defined sampling rate, so it is assumed to be normalized by Frequency

    FFTFreqs, FT_1s_Mag = FFT_1s(TimeDataIn) #take FT of time domain

    return THD_Core(FT_1s_Mag,FFTFreqs;PlotOn=PlotOn,Normalized=true)
end

function THD_TimeSeries(TimeDataIn::Vector,fs;MaxHarmonics=10, PlotOn=true,Normalized=false)

    #TimeDataIn is the data in question
    #fs is the sampling rate in Hz


    FFTFreqs, FT_1s_Mag = FFT_1s(TimeDataIn,fs) #take FT of time domain
    return THD_Core(FT_1s_Mag,FFTFreqs;PlotOn=PlotOn,Normalized=Normalized)
end


function THD_Core(FT_1s_Mag,FFTFreqs;PlotOn=true, Normalized=true)


    FundamentalMag, FundamentalIndex = findmax(FT_1s_Mag)

    NumHarmonics = Int(floor(length(FT_1s_Mag)/FundamentalIndex))
    HarmonicArray = [FundamentalIndex FundamentalMag]


    for n in 1:NumHarmonics-1
        Harm_index=FundamentalIndex .+ n*(FundamentalIndex-1)

        HarmonicArray = [HarmonicArray;[Harm_index  FT_1s_Mag[Harm_index]]]
        if n==MaxHarmonics
            break
        end
    end



    THD = sqrt(sum(HarmonicArray[2:end,2].^2))/HarmonicArray[1,2]
    THD_dB = 20*log10(THD)
    if PlotOn
        semilogy(FFTFreqs,FT_1s_Mag)
        semilogy(FFTFreqs[Int.(HarmonicArray[:,1])],HarmonicArray[:,2],"ro")
        title("THD = $THD_dB dB")
        if Normalize
            xlabel("Normalized Frequency (cycles/sample)")
        else
            xlabel("Frequency (Hz)")
        end
        ylabel("Amplitude")
    end
    return THD
end
