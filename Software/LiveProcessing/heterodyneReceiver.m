% Masterthesis - Muhammed Yildirim 
% Ultraschall Mikrofon-Array Adapter und digitale Audiosignalverarbeitung 
% zur Detektion und Ortung von Fledermausrufen
%
% heterodyne receiver algorithm

function [yAudibleOut] = heterodyneReceiver(samples, shifterFrequency, Fs, bPolyArrayLP, M)
% heterodyneReceiver Function takes sample vectors to process them with the
%                    heterodyne algorithm
%
%   
%   Input:
%   samples: a vector containing audio samples
%
%   shifterFrequency: The frequency to shift the frequency spectrum by a
%                     defined quantity
%   
%   Fs: Sampling Frequency
%
%   bPolyArrayLP: A matrix containg polyphase decompositioned filter
%                 coefficients
%
%   M: Downsampling Factor
%
%   Output:
%   yAudibleOut: A vector containing the audible band after the heterodyne
%                receiver

    BW = Fs/2;
    % prepare mixer array
    nSamp = 0:length(samples)-1;
    sMixer = exp(1i*2 * pi * -shifterFrequency * nSamp/Fs);

    yInShift = samples.* sMixer;
    yShiftFFT = fft(yInShift);

    % write first half of fft into an array
    yFirstHalfFFT = yShiftFFT(1:(floor(length(yShiftFFT)/2))+1);

    % set frequency bins to zero to remove components that are shifted to the
    % upper band edge
    yFirstHalfFFT(1, floor(length(yFirstHalfFFT)/(Fs/2) * (BW-shifterFrequency)):end) = 0;
    yShiftCorrectedFFT = [yFirstHalfFFT conj(yFirstHalfFFT(end:-1:2))];

    % compute the ifft of the shifted signal
    yShifted = real(ifft(yShiftCorrectedFFT));
    

    % perform polyphase filtering
    yAudibleOut = decimationFilter(bPolyArrayLP, M, yShifted);
    % yAudibleOut = yAudibleOut * M;

end