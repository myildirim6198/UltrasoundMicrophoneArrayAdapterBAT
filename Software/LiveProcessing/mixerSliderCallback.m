% Masterthesis - Muhammed Yildirim 
% Ultraschall Mikrofon-Array Adapter und digitale Audiosignalverarbeitung 
% zur Detektion und Ortung von Fledermausrufen
%
% Callback function to change the text under the slider for mixer frequency
% representation and get the configured mixer frequency

function mixerSliderCallback(mixSliderH, EventData)
% mixerSliderCallback Callback function to set the text under the
%                     slider and to get the new configured mixer
%                     frequency
%
%   
%   Input:
%   mixSliderH: the gui data handler
%
%   Output:
%   None
%

    handles = guidata(mixSliderH);

    handles.mixerFrequency = handles.mixerSlider.Value;
    handles.mixerFrequencyText.String = "fmixer = " + handles.mixerSlider.Value + " kHz";
end