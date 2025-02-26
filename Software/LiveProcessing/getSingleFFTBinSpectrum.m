% Masterthesis - Muhammed Yildirim 
% Ultraschall Mikrofon-Array Adapter und digitale Audiosignalverarbeitung 
% zur Detektion und Ortung von Fledermausrufen
%
% fft peak search and getting the frequency peak

function [YFFTSingleBin, fpeak] = getSingleFFTBinSpectrum(YFFT, frameSize, frequencyVector)
% getSingleFFTBinSpectrum Function does a peak search and set any other 
%                     frequency bin to zero 
%
%   
%   Input:
%   YFFT: The STFT of a microphone signal frame
%
%   frameSize: Size of the sample frame
%   
%   frequencyVector: frequency vector for frequency search
%
%   Output:
%   YFFTSingleBin: A matrix containing the frequency band with the single
%                  highest frequency bin
%
%   fpeak: The Frequency of the highest bin

    YhalfFFT = YFFT(1, 1:(frameSize)/2+1);
    [Ypeak, idxPeak] = max(YhalfFFT);
    fpeak = frequencyVector(idxPeak);

    YhalfNew = [zeros(1, idxPeak-1) YhalfFFT(idxPeak) zeros(1, (frameSize/2-idxPeak+1))];
    YFFTSingleBin = [YhalfNew conj(YhalfNew(end-1:-1:2))];
end