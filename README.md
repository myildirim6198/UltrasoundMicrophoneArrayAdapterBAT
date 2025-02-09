# Ultrasound Microphone Array Adapter for recording and locating microbats

This project was developed as a final thesis project. This device is intended to be connected to end devices such as PCs, laptops and Smartphones over USB-C

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

An ultrasound emitter that transmits frequencies between 30 kHz to 40 kHz was used to test the devices capabilities. Used sampling frequency is 160 kHz.

![test](https://github.com/myildirim6198/UltrasoundMicrophoneArrayAdapterBAT/blob/main/Images/GUI_40deg_freqDivid.png?raw=true)

Example picture of the ultrasound adapter being recognized by a smartphone

![test](https://github.com/myildirim6198/UltrasoundMicrophoneArrayAdapterBAT/blob/main/Images/imagePhoneUAdapter.jpg?raw=true)

Firmware code included, softwarecode a barebone loopback project is only included. Implemented algorithms not included. To improve the accuracey of localisation it is recommended to relocate the connector adapters on the PCB bottom side or bridge the through hole pads between middle and near the microphones with solder for each channel seperately. the outer trough hole pads are for inputs for the usage of a function generator.

I make no guarantees as to device funtionality. Please review the components, schematics carefully before production.

