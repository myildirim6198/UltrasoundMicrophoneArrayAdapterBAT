% Masterthesis - Muhammed Yildirim 
% Ultraschall Mikrofon-Array Adapter und digitale Audiosignalverarbeitung 
% zur Detektion und Ortung von Fledermausrufen
%
% radio button callback to process the click on the selected frequency
% divider algorithm

function RadioButton1Callback(RadioH, EventData)
% RadioButton1Callback Callback function to process the checking or
%                      unchecking the frequency divider radio button
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
    if (handles.radioButtons(1).Value == 1)
        % uncheck heterodyne receiver radio button automatically if its 
        % active for safety measures
        set(handles.radioButtons(2), 'Value', 0);
        % disable heterodyne receiver
        handles.toggleHeterodyneReceiver = false;
        % enable frequency divider
        handles.toggleFrequencyDivider = true;

        % disable mixer slider and reset any dependencies of the heterodyne
        % receiver
        handles.mixerSlider.Enable = "off";
        handles.toggleButtonListenSound.Enable = "on";
        handles.mixerSlider.Value = 0;
        handles.mixerFrequencyText.String = "fmixer = " + handles.mixerSlider.Value + " kHz";
    % if unchecked reset and disable all audible algorithms
    else 
        handles.toggleHeterodyneReceiver = false;
        handles.toggleFrequencyDivider = false;
        handles.toggleButtonListenSound.Enable = "off";
        handles.toggleButtonListenSound.Value = 0;
    end
    
end