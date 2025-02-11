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

% forever loop, edit conditions in order to safely exit
while true
    % tic;
    % read usb data
    sampleFrame = read(stm32device, usbFrameSize, "int32");
    % normalize to float values
    sampleFrameTransp = sampleFrame * (1/2147483648);

    % split main sample frame into 2 channels to reconstruct the two
    % independent signals
    channel_1 = sampleFrameTransp(1:2:end);
    channel_2 = sampleFrameTransp(2:2:end);

    % insert code, algorithms here...

end
clearvars('stm32device');