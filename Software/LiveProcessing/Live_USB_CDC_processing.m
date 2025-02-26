% Masterthesis - Muhammed Yildirim 
% Ultraschall Mikrofon-Array-Adapter und digitale Audiosignalverarbeitung 
% zur Detektion und Ortung von Fledermausrufen
%
% Software for live processing of Ultrasound signals

clear all;
close all;
clc;

stm32device = serialport("COM5", 115200);
% app.Connection = stm32device;

% expected usb frame size from the interface
usbFrameSize = 2048;

% sampling frequency and period
% real Fs 176.215 kHz
% Fs = 176.4e3;
% T = 1/Fs;

Fs = 160e3;
T = 1/Fs;

% plot parameters and frame parameters
Nframe = 10;
frameSz = 1024;

% fft frequency vector
fvec = Fs/(Nframe*frameSz)*(0:(Nframe*frameSz)-1);
% time vector
t = 0:T:(Nframe*frameSz)/Fs-1/Fs;

% refresh cycle
refreshCycle = Nframe;
% create buffer for saving samples
plotBuffer = zeros(2, frameSz*refreshCycle);
fftBuffer1 = zeros(1, frameSz*refreshCycle);
fftBuffer2 = zeros(1, frameSz*refreshCycle);

% prepare plots

% fft plot
forgettingFactor = 0.1;
handles.figure = figure('Name','Live Plot of Ultrasound');
% handles.figure.Position = [1000 820 560 420];
subplot(3,2,2);
fftplot = plot(fvec/1000, fftBuffer1);
xlim([0 (Fs/2)/1000]);
xlabel('frequency (kHz)');
ylabel('Amplitude level (dB)');
title('Live FFT plot');
grid on;

% time plot
subplot(3,2,1);

timePlot = plot(t, plotBuffer(1,:));
ylim([-1.5 1.5]);
xlabel('time (s)');
ylabel('Amplitude');
title('Live time plot');
grid on;

% spectogram plot
subplot(3,2,3);
plotSpectrogram = imagesc([], [], []);
ylim([0 (Fs/2)/1000]);
axis xy;
colormap jet;
colorbar;
title('Live sonagram');
xlabel('time (s)');
ylabel('frequency (kHz)');

% MUSIC pseudo spectrum plot
thetaSteps = 0.5;
theta = (-90:thetaSteps:90); % angle vector
JMusicPS = zeros(length(theta), 1);
JMusic = zeros(length(theta), 1);
Nmic = 2;
Nsource = 1;

subplot(3,2,4);
pMUSICplot = plot(theta, JMusicPS);
xlabel('Estimated Angle [°]');
ylabel('Power spectrum (dB)');
title('Live MUSIC pseudo spectrum');
grid on;

% fft plot of the audible signal
subplot(3,2,5);
M = 4;
FsM = Fs/M;
fvecM = (Fs/M)/((Nframe*frameSz)/M)*(0:((Nframe*frameSz)/M)-1);
plotBufferM = zeros(1, (frameSz*refreshCycle)/M);
audiblePlot = plot(fvecM/1000, plotBufferM);
xlim([0 ((Fs/M)/2)/1000]);
xlabel('frequency (kHz)');
ylabel('Amplitude level (dB)');
title('Audible Frequency Range');
grid on;

% load polyphase filter coefficients
load polyphaseBP160k.mat;
bPolyArrayBP = bPolyArray;
load polyphaseLP160k.mat;
bPolyArrayLP = bPolyArray;

% load polyphaseBP.mat;
% bPolyArrayBP = bPolyArray;
% load polyphaseLP.mat;
% bPolyArrayLP = bPolyArray;

% load optional highpass filter
load firHPcoefficients.mat
bFIRoptHP = bFIRHP;

% define ui elements
handles.toggleFrequencyDivider = false;
handles.toggleHeterodyneReceiver = false;
handles.mixerFrequency = 0;
handles.mixerFrequencyString = "fmixer = " + handles.mixerFrequency + " kHz";
handles.audioRecorderArrayRAW = [];
handles.audioRecorderArrayAudible = [];

% radio buttons to switch between audible modes
handles.radioButtons(1) = uicontrol('Style', 'radiobutton', ...
                                    'Callback', @RadioButton1Callback, ...
                                    'Units',    'normalized', ...
                                    'Position', [0.55 0.16 0.25 0.048], ...
                                    'String',   'Frequency Divider', ...
                                    'Value',    0);

handles.radioButtons(2) = uicontrol('Style', 'radiobutton', ...
                                    'Callback', @RadioButton2Callback, ...
                                    'Units',    'normalized', ...
                                    'Position', [0.55 0.21 0.25 0.048], ...
                                    'String',   'Heterodyne Receiver', ...
                                    'Value',    0);

% slider to change mixer frequency when heterodyne-mode is selected
handles.mixerSlider = uicontrol('Style', 'slider', ...
                                'Callback', @mixerSliderCallback, ...
                                'Units', 'normalized', ...
                                'Position',[0.55 0.1 0.4 0.048], ...
                                'Min', 0, ...
                                'Max', 80, ...
                                'Enable','off');

% text to show the current set mixer frequency
handles.mixerFrequencyText = uicontrol('Style', 'text', ...
                                       'String', handles.mixerFrequencyString, ...
                                       'Units', 'normalized', ...
                                       'Position', [0.67 0.03 0.1875 0.048]);

% toggle button for listening to sound
handles.toggleButtonListenSound = uicontrol('Style','togglebutton', ...
                                            'String', "Listen to Bat", ...
                                            'Units', 'normalized', ...
                                            'Position', [0.793 0.258 0.165 0.048],...
                                            'Enable','off');

% toggle button for recording audio
handles.toggleButtonRecordAudio = uicontrol('Style','togglebutton', ...
                                            'Callback', @toggleRecordAudioCallback, ...
                                            'String', "Start Recording", ...
                                            'Units', 'normalized', ...
                                            'Position', [0.793 0.21 0.165 0.048]);


handles.checkboxHPFilter = uicontrol('Style','checkbox', ...
                                            'String', "HP Filter", ...
                                            'Units', 'normalized', ...
                                            'Position', [0.55 0.26 0.12 0.048]);

timeEstimator = 0;
elapsedtimeCycle = 100;
elapsedTimeCntr = 0;

guidata(handles.figure, handles);
cycleCounter = 0;
% forever loop until plot window is closed
while ishandle(handles.figure)
    % tic;
    % read usb data
    sampleFrame = read(stm32device, usbFrameSize, "int32");
    % normalize to float values
    sampleFrameTransp = sampleFrame * (1/2147483648);

    % split main sample frame into 2 channels to reconstruct the two
    % independent signals
    channel_1 = sampleFrameTransp(1:2:end);
    channel_2 = sampleFrameTransp(2:2:end);

    % write samples into a big plot buffer
    plotBuffer(1, (cycleCounter*frameSz)+1:(cycleCounter+1)*frameSz) = channel_1;
    plotBuffer(2, (cycleCounter*frameSz)+1:(cycleCounter+1)*frameSz) = channel_2;

    % plot / processing data after every "refreshCycle"th cycle
    cycleCounter = cycleCounter + 1;
    if (cycleCounter == refreshCycle)
        % prepare frequency domain plot

        % calculate stfts with forgetting factor applied on previous stft
        % is fir highpass-filter selected?
        if(handles.checkboxHPFilter.Value == 0)
            windowFFT1 = fft(plotBuffer(1, :))/length(plotBuffer(1, :));
            windowFFT2 = fft(plotBuffer(2, :))/length(plotBuffer(2, :));
            fftBuffer1 = (forgettingFactor * fftBuffer1) + windowFFT1;
            fftBuffer2 = (forgettingFactor * fftBuffer2) + windowFFT2;
            % fftBuffer1 = (forgettingFactor * fftBuffer1) + fft(blackman(length(plotBuffer(1,:)))'.*plotBuffer(1,:));
            % fftBuffer2 = (forgettingFactor * fftBuffer2) + fft(blackman(length(plotBuffer(2,:)))'.*plotBuffer(2,:));
        elseif(handles.checkboxHPFilter.Value == 1)
            plotBuffer(1,:) = filter(bFIRoptHP, 1, plotBuffer(1,:));
            plotBuffer(2,:) = filter(bFIRoptHP, 1, plotBuffer(2,:));
            fftBuffer1 = (forgettingFactor * fftBuffer1) + fft(plotBuffer(1,:))/length(plotBuffer(1, :));
            fftBuffer2 = (forgettingFactor * fftBuffer2) + fft(plotBuffer(2,:))/length(plotBuffer(2, :));

            % fftBuffer1 = (forgettingFactor * fftBuffer1) + fft(blackman(length(plotBuffer(1,:)))'.*filteredFrame1);
            % fftBuffer2 = (forgettingFactor * fftBuffer2) + fft(blackman(length(plotBuffer(2,:)))'.*filteredFrame2);
        end

        % prepare sonagram plot
        [sSona, fSona, tSona] = stft(plotBuffer(1,:), Fs,FFTLength=(frameSz*Nframe));

        % audible bat algorithms
        if (handles.radioButtons(1).Value == 1)
            % frequency divider
            yAudibleOut = decimationFilter(bPolyArrayBP, M, plotBuffer(1,:));
            plotBufferM = (forgettingFactor * plotBufferM) + fft(yAudibleOut);
        elseif (handles.radioButtons(2).Value == 1)
            % heterodyne receiver
            shifterFrequency = handles.mixerSlider.Value * 1e3;
            yAudibleOut = heterodyneReceiver(plotBuffer(1,:), shifterFrequency, Fs, bPolyArrayLP, M);
            plotBufferM = (forgettingFactor * plotBufferM) + fft(yAudibleOut);
        else
            % if no audible algorithm is selected set frames to zero for
            % fft
            plotBufferM = fft(zeros(1, (frameSz*refreshCycle)/M));
        end

        % if listen mode and audible algorithm is toggled and selected
        % convert a signal array to a sound to listen to
        if(handles.toggleButtonListenSound.Value == 1)
            sound(yAudibleOut, FsM);
        end

        % if recording is selected write new frames into a dynamic buffer
        if(handles.toggleButtonRecordAudio.Value == 1)
            handles.audioRecorderArrayRAW = [handles.audioRecorderArrayRAW plotBuffer(1,:)];
            if ((handles.radioButtons(1).Value == 1) || (handles.radioButtons(2).Value == 1))
                handles.audioRecorderArrayAudible = [handles.audioRecorderArrayAudible yAudibleOut];
            end
            guidata(gcf, handles);
        % if recording isnt selected reset recording buffer
        elseif(handles.toggleButtonRecordAudio.Value == 0)
            handles.audioRecorderArrayRAW = [];
            handles.audioRecorderArrayAudible = [];
            guidata(gcf, handles)
        end

        % Calculate the MUSIC-Pseudospectrum
        % peak search, get single fft bin spectrum and build signal model
        [YframeFFT, fpeak] = getMUSICSignalModel(fftBuffer1, fftBuffer2, frameSz, Nframe, fvec);
        JMusic = musicAlgorithm(YframeFFT, frameSz*Nframe, Nmic, Nsource, fpeak, thetaSteps);
        JMusicPS = (forgettingFactor * JMusicPS) + 1./JMusic;

        % plot results
        set(fftplot, 'YData', db(abs(fftBuffer1)));
        set(timePlot, 'YData', plotBuffer(1,:));
        set(plotSpectrogram, 'XData', tSona, 'YData', fSona/1000, 'CData', abs(sSona));
        set(pMUSICplot, 'YData', 10*log10(abs(JMusicPS)));
        set(audiblePlot, 'YData', db(abs(plotBufferM)));
        % toc
        % timeEstimator = timeEstimator + toc;
        % elapsedTimeCntr = elapsedTimeCntr + 1;
        % if(elapsedTimeCntr >= elapsedtimeCycle)
        %     avrgTime = timeEstimator/elapsedtimeCycle;
        %     disp(num2str(avrgTime));
        %     timeEstimator = 0;
        %     elapsedTimeCntr = 0;
        % end

        drawnow;
        % toc
        cycleCounter = 0;
        
    end

end
clearvars('stm32device');