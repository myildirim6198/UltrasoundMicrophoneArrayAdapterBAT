% Masterthesis - Muhammed Yildirim 
% Ultraschall Mikrofon-Array Adapter und digitale Audiosignalverarbeitung 
% zur Detektion und Ortung von Fledermausrufen
%
% polyphase decimation filter

function [yPolyOut] = decimationFilter(bPolyCoeff, M, samples)
% decimationFilter  performs a decimation filtering of an input signal with
%                   given polyphase decompositioned coefficients and
%                   downsampling factor
%   
%   Input:
%   bPolyCoeff: a M x Ncoeff matrix of polyphase decompositioned coefficients 
%               (M downsampling and N coeeficient per branch)
%   
%   M: downsampling factor
%
%   Samples: input sample array 1xN
%
%   Output:
%   yPolyOut: A 1xN Matrix containing the decimation filtered samples

    % create an array with length M: first column needs to match with first sample
    % for toeplitz matrix
    delayShifter = [samples(1,1) zeros(1, M-1)];
    samplesWZeros = [samples zeros(1, M-1)];

    % perform toeplitz matrix to perform delay shifting per branch
    delayedSampleMatrix = toeplitz(delayShifter, samplesWZeros);

    % downsampling by removing each M sample
    decimatedSampleMatrix = delayedSampleMatrix(:, 1:M:end-M);

    % apply fir-filtering per branch / matrix row
    decimationFilteredArray = cell2mat(arrayfun(@(i) filter(bPolyCoeff(i, :), ...
        1, decimatedSampleMatrix(i, :)), 1:size(decimatedSampleMatrix, 1), ...
        'UniformOutput', false)');

    % accumulate polyphase filtered samples from each branch
    yPolyOut = sum(decimationFilteredArray, 1);
    
    % correct amplitude after decimation
    % yPolyOut = yPolyOut * M;

end