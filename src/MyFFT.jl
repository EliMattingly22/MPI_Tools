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


function known_aliasing(Data::Vector,fs,f_unwrap::Union{Float64,Vector};FreqBuf::Int = 1,oversamp::Int=1)

freqs, ftData = FFT_1s(Data,fs=fs)
L = length(Data)
L_1s = length(ftData)
T = 1/fs
T_vec =0:T:((length(Data)-1)*T)
df = fs/L

MaxFreq = maximum(f_unwrap)
ScaleFac = Int(ceil(MaxFreq/(fs/2)))*oversamp
new_fs = ScaleFac*fs
new_L = ScaleFac*L
new_L_1s = Int(round(new_L/2))

newFreqs = fftfreq(ScaleFac*L,new_fs)[1:new_L_1s]
NewSpectra = Complex.(zeros(length(newFreqs)))
NewSpectra[1:L_1s] = ftData[:]


for i in 1:length(f_unwrap)
    AliasedFreq = calcAlias(fs,f_unwrap[i]) #the freq. the frequency has aliased to
    AliasedIndex = Int(round(AliasedFreq/df)) #the index of the aliased frequency
if AliasedIndex==0
    AliasedIndex=1
end
    NewIndex = Int(round(f_unwrap[i]/df)) #The new (corrected) index

    IndexDistFromEdge = [AliasedIndex, length(AliasedFreq)-AliasedIndex, NewIndex,new_L_1s-NewIndex]
    if minimum(abs.(IndexDistFromEdge))<FreqBuf
        FreqBuf = minimum(abs.(IndexDistFromEdge))
    end
    StartInd_Alias = AliasedIndex-FreqBuf
    StopInd_Alias = AliasedIndex+FreqBuf
    StartInd_New = NewIndex-FreqBuf
    StopInd_New = NewIndex+FreqBuf

    NewSpectra[StartInd_New:StopInd_New] = ftData[StartInd_Alias:StopInd_Alias]
    NewSpectra[StartInd_Alias:StopInd_Alias] = zeros(length(StartInd_Alias:StopInd_Alias))

    println("Actual freq: $(f_unwrap[i]). Aliased to: $(AliasedFreq)")

end
figure(1)
subplot(211)
plot(freqs,abs.(ftData),"g")
stem(newFreqs,abs.(NewSpectra))

subplot(212)
FullSpectraNew = FFT_1s_to2s(NewSpectra)
NewTimeDomain = ifft(FullSpectraNew.*length(FullSpectraNew))
T_vec_new =0:T/ScaleFac:((length(NewTimeDomain)-1)*T/ScaleFac)
# figure(2)
plot(T_vec,Data,"r")
plot(T_vec_new,NewTimeDomain,"g")
return FullSpectraNew,NewTimeDomain,T_vec_new

end


function calcAlias(fs,f)
    #fs is the sampling rate
    #df is the df in the DFT
    #f is the actual waveform frequency

    Nyqu = fs/2

    Wraps = Int(floor(f / Nyqu)) #numer of full wraparounds
    WrapDist = f % Nyqu # how far past the last wrap it will be

    if ( Wraps % 2 )==0#if it is even, the wrap will be "backwards"
        return AliasedFreq = WrapDist
    else
        return AliasedFreq = Nyqu-WrapDist
    end
end


function FFT_1s_to2s(ftData)
    return cat(ftData[:],conj.(reverse(ftData[2:end]))[:],dims=1)
end
