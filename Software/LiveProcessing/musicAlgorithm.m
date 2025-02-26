% Masterthesis - Muhammed Yildirim 
% Ultraschall Mikrofon-Array Adapter und digitale Audiosignalverarbeitung 
% zur Detektion und Ortung von Fledermausrufen
%
% MUSIC-Algorithm computation

function JMusic = musicAlgorithm(YSTFT, frameSz, Nmic, Nsource, fpeak, thetaSteps)
% musicAlgorithm Function to compute the MUSIC-Pseudospectrum
%
%   
%   Input:
%   YSTFT: The signal model for a subspace based algorithm
%
%   frameSz: Size of the sample frame
%   
%   Nmic: Number of microphones
%
%   Nsource: Number of sources to find
%
%   fpeak: The frequency peak to steer on to
%
%   thetaSteps: the step size of the theta function
%
%   Output:
%   JMusic: The music pseudo spectrum
%

    c = 347;
    micDist = 0.0034;
    theta = -90:thetaSteps:90;

    % calculate the covariance matrix Ry
    Ry = (YSTFT*YSTFT')/(frameSz);

    % eigenmode and eigenvector decomposition of Ry
    [B,V] = eig(Ry);

    % get the noise subspace
    Bn = B(:, 1:Nmic-Nsource); 

    % compute signal subspace by calculatiung the steering matrix
    SM = exp(-1i*2*pi*micDist*sin(theta/180*pi)/(c/fpeak) .* [0:Nmic-1]');

    % compute MUSIC pseudo spectrum
    JMusic = diag(SM'*Bn*Bn'*SM);
end