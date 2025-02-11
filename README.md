# Ultrasound Microphone Array Adapter for recording and locating microbats

This project was developed as a final thesis project. This device records real-time Ultrasound of microbats that is inaudible to the human ears and makes those audible through usage of signal processing algorithms. Additionaly through using digital signal processing algorithms the device is capable of estimating the Direction of arrival of the recorded microbat calls based on a microphone array with two MEMS-Microphones. This device is intended to be connected to end devices such as PCs, laptops and Smartphones over USB-C. The signal processing is done on the end device.

# Hardware features

- MCU: STM32F730R8T6 with an ARM cortex M7 up to 216 MHz core clock
- Digital Connections: 1x USB-C Fullspeed up to 12 MBit/s, 1x USB-C up to 480 MBit/s (not tested) (connect one port at a time only!)
- Debug: Serial-Wire-Debug
- ADC: PCM1820 2 Channel Audio-ADC up to 192 kHz sampling Frequency
- Pre-amplifier stage: 21 dB
- Adjustable second amplifier stage: up to 40 dB
- Microphones: 2x KNOWLES SPU0410LR5H-QB MEMS-Microphones 3.4 mm gap to each other

# Applications:

- Microphone Arrays
- Ultrasound
- Bat detection and localisation

# Absolute Maximum Ratings

- Supply Voltage: +5V0 to +5V5 (recommended: +5V0) USB feeded

# Manufacturing Information

- Length = 50mm, Width = 50mm, Thickness = 1.6 mm
- Layers = 8
- Min. Via Hole diameter = 0.3 mm
- Via-Type: Epoxy Filled and Capped
- Impedance Control: JLC08161H-2116
- Surface Finish: ENIG
- Material Type: FR-4 TG155

# Progress

- Schematic design: complete
- Layouting: complete
- Manufacturing & assembly: complete
- Bring-Up: complete, all components tested except for USB-HS interface
- Firmware: complete, DMA-Based recording of ultrasound audio
- Software: complete, end-devices can process the recorded ultrasound audio samples frame based

# Examples

3D-representation of the Adapter

![test](https://github.com/myildirim6198/UltrasoundMicrophoneArrayAdapterBAT/blob/main/Images/UAdapterImage.png?raw=true)

An ultrasound emitter that transmits frequencies between 30 kHz to 40 kHz was used to test the devices capabilities. Used sampling frequency is 160 kHz. For the localization the MUSIC-Algorithm was used. Used digital signal processing algorihtms to make the microbat calls audible are heterodyne receiver (direct frequency mixing) and frequency dividers by using FIR polyphase decimation filters

![test](https://github.com/myildirim6198/UltrasoundMicrophoneArrayAdapterBAT/blob/main/Images/GUI_40deg_freqDivid.png?raw=true)

Example picture of the ultrasound adapter being recognized by a smartphone

![test](https://github.com/myildirim6198/UltrasoundMicrophoneArrayAdapterBAT/blob/main/Images/imagePhoneUAdapter.jpg?raw=true)

- Firmware code: included
- Softwarecode: A barebone loopback project in MATLAB/GNU Octave is included. Implemented signal processing algorithms not included. The barebone program reads a data frame of 2 x 1024 frames of left and right micropohne samples through the USB-serial bus. 

To improve the accuracy of localisation it is recommended to relocate the connector adapters on the PCB to the bottom side or bridge the through hole pads between middle and near the microphones with solder for each channel seperately. The outer trough hole pads are for inputs for the usage of a function generator.

I make no guarantees as to device funtionality. Please review the components, schematics carefully before production.

