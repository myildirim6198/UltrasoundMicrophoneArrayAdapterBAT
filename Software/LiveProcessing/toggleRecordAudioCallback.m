% Masterthesis - Muhammed Yildirim 
% Ultraschall Mikrofon-Array Adapter und digitale Audiosignalverarbeitung 
% zur Detektion und Ortung von Fledermausrufen
%
% callback to process record audio toggle button

function toggleRecordAudioCallback(toggleRecH, EventData)
% toggleRecordAudioCallback Callback function to start / stop recording
%                           an audio signal
%
%   
%   Input:
%   toggleRecH: The gui data handler
%
%   Output:
%   None
%

    handles = guidata(toggleRecH);

    % if the toggle button is clicked change toggle button name to stop
    % recording
    if(handles.toggleButtonRecordAudio.Value == 1)
        handles.toggleButtonRecordAudio.String = "Stop Recording";
    % if toggle button is clicked and value is zero stop recording by
    % creating wav-files
    elseif(handles.toggleButtonRecordAudio.Value == 0)
        Fs = 176.4e3;
        T = 1/Fs;
        % T = 6e-6;
        % Fs = ceil(1/T);
        M = 4;
        FsM = ceil(Fs/M);
    
        filenameRAW = "BatAudioRAW" + string(datetime('now','TimeZone','local','Format','d_MMM_y_HH_mm_ss'))+ ".wav";
        audiowrite(filenameRAW, handles.audioRecorderArrayRAW, Fs);
        % if an audible algorithm is active save the audible sound as well
        % in a wav-file
        if ((handles.radioButtons(1).Value == 1) || (handles.radioButtons(2).Value == 1))
            filenameAud = "BatAudioAudible" +string(datetime('now','TimeZone','local','Format','d_MMM_y_HH_mm_ss'))+ ".wav";
            audiowrite(filenameAud, handles.audioRecorderArrayAudible, FsM);
        end
        handles.toggleButtonRecordAudio.String = "Start Recording";
    end
end