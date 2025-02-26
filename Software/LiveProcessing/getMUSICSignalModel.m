% Masterthesis - Muhammed Yildirim 
% Ultraschall Mikrofon-Array Adapter und digitale Audiosignalverarbeitung 
% zur Detektion und Ortung von Fledermausrufen
%
% create Signal model for subspace based algorithms

function [YframeFFT, fpeak1] = getMUSICSignalModel(fftBuffer1, fftBuffer2, frameSz, Nframe, fvec)
% getMUSICSignalModel Creates a Signal model for subspace based algorithms 
%   
%   Input:
%   fftBuffer1: The STFT of microphone 1
%
%   fftBuffer2: The STFT of microphone 2
%   
%   frameSz: The size of a sample frame
%
%   Nframe: The number of sample frames
%
%   fvec: frequency vector for frequency search
%
%   Output:
%   YframeFFT: A Matrix containing the signal model prepared for the
%              MUSIC-Algorithm
%
%   fpeak1: The Frequency of the highest bin

        % peak search and get the spectrum with only the bin of the maximum
        [Y1BinFFT, fpeak1] = getSingleFFTBinSpectrum(fftBuffer1, frameSz*Nframe, fvec);
        [Y2BinFFT, fpeak2] = getSingleFFTBinSpectrum(fftBuffer2, frameSz*Nframe, fvec);

        % compute inverse fourier transform
        y1Bin = ifft(Y1BinFFT);
        y2Bin = ifft(Y2BinFFT);

        % compute hilbert transformation to get the analythic Signal
        y1BinHilbert = hilbert(y1Bin);
        y2BinHilbert = hilbert(y2Bin);

        % compute the stft
        Y1HilbFFT = fft(y1BinHilbert);
        Y2HilbFFT = fft(y2BinHilbert);

        % build Signal model
        YframeFFT = [Y1HilbFFT; Y2HilbFFT];
end