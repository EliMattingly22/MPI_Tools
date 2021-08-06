using FFTW
using PyPlot

function THD_TimeSeries(TimeDataIn::Vector;MaxHarmonics=10)

    FTData = fft(TimeDataIn) #take FT of time domain
    FT_1s_Mag = abs.(FTData)[1:Int(round(length(FTData)/2))] #only consider 1sided mag

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
        semilogy(FT_1s_Mag)
        semilogy(HarmonicArray[:,1].-1,HarmonicArray[:,2],"ro")
        title("THD = $THD_dB dB")
    end

    return THD
end

function THD_TimeSeries(TimeDataIn::Vector,fs;MaxHarmonics=10, PlotOn=true)

    #TimeDataIn is the data in question
    #fs is the sampling rate in Hz

    FTData = fft(TimeDataIn) #take FT of time domain
    FFTFreqs = fftfreq(length(FTData),fs)
    FFTFreqs = FFTFreqs[1:Int(round(length(FTData)/2))] #Only look at 1 sided
    FT_1s_Mag = abs.(FTData)[1:Int(round(length(FTData)/2))] #only consider 1sided mag

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
    end
    return THD
end
