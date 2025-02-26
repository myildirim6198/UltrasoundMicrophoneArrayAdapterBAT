% Masterthesis - Muhammed Yildirim 
% Ultraschall Mikrofon-Array Adapter und digitale Audiosignalverarbeitung 
% zur Detektion und Ortung von Fledermausrufen
%
% radio button callback to process the click on the selected heterodyne
% receiver algorithm

function RadioButton2Callback(RadioH, EventData)
% RadioButton2Callback Callback function to process the checking or
%                      unchecking the heterodyne receiver radio button
%
%   
%   Input:
%   RadioH: The gui data handler
%
%   Output:
%   None
%

    handles = guidata(RadioH);
    % if radiobutton is checked
    if (handles.radioButtons(2).Value == 1)
        % uncheck frequency divider radio button automatically if its 
        % active for safety measures
        set(handles.radioButtons(1), 'Value', 0);
        % enable heterodyne receiver
        handles.toggleHeterodyneReceiver = true;
        % disable frequency divider algorithm
        handles.toggleFrequencyDivider = false;

        % enable mixer slider to change mixer frequency
        handles.mixerSlider.Enable = "on";
        % enable toggle button to listen to the audible sound
        handles.toggleButtonListenSound.Enable = "on";
    % if unchecked reset and disable all audible algorithms
    else 
        handles.toggleHeterodyneReceiver = false;
        handles.toggleFrequencyDivider = false;
        handles.mixerSlider.Enable = "off";
        handles.mixerSlider.Value = 0;
        handles.mixerFrequencyText.String = "fmixer = " + handles.mixerSlider.Value + " kHz";
        handles.toggleButtonListenSound.Enable = "off";
        handles.toggleButtonListenSound.Value = 0;
    end
end