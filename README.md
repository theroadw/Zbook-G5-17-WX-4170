# HP ZBOOK 17 G5 - AMD WX-4170

# Specs
- CPU: Mobile HexaCore Intel Core i7-8750H, 2200 MHz
- Motherboard Hewlett-Packard HP ZBook 17 G5
- Motherboard Chipset: Intel Cannon Lake
- iGPU: Intel(R) UHD Graphics 630
- dGPU: AMD WX-4170
- Audio Adapter: Connexant CX-8400
- Thunderbolt 3 Titan Ridge 4C 2018
- WiFi: Intel(R) Dual Band Wireless-AC 9560 Jefferson Peak
- Ethernet: Intel(R) Ethernet Connection I219-LM
- RTS525A Realtek Express SDCard Reader

# Working
- [x] AMD WX-4170 DGPU 4GB VRAM
- [x] UHD630 with 1536MB VRAM
- [x] CPU, GPU and WX-4170 Power Managment
- [x] Brightness controls
- [x] Thunderbolt3 / USB type C data and video @4K
- [x] HDMI and Mini-DVI video @4K
- [x] USB type A ports (2.0 & 3.0)
- [x] Native NVRAM
- [x] Audio - internal mic, speakers, headphone jack (+sense)  and HDMI on all video outputs
- [x] Intel Bluetooth, able to toggle on/off
- [x] I2C ALPS trackpad w/2 button support and 5 finger gestures
- [x] PS2 keyboard w/SSDT Brightness/Volume keys re-mapping
- [x] Battery management
- [x] WiFi up to 300mb/s
- [x] Fan Sensors (left and right)
- [x] Webcam
- [x] SD Card Reader
- [x] Gigabit Ethernet
- [x] Sleep
- [x] Full DRM on all displays with WX-4170

## BIOS settings

Disable secure boot

Set Graphics to Hybrid mode

## Patching DRM

Use iMac20,2 SMBios for full DRM while WX card is active

2 GPU Modes, you can choose UMA config (turns DGPU off, use with unsupported Nvidia DGPU or to save power) or Hybrid+Mux which is the new mode that has everything that Discrete mode plus IGPU for compute and Intel quicksync.. 

** WX-4170 GPU now works in Catalina/Big Sur/Monterey/Ventura thanks to @EdwardGeo!! 
** - Will need to flash the included rom to your card.

I use SSDT-xNVME.aml to completely disable my windows NVME drive that is not compatible with OSX and causes kernel panics if mounted read/write and also randomly at boot. I find it's more reliable than just not mounting the volume editing fstab. It needs to be enabled in the ACPI section in config.plist and adjusted to your non-compatible NVME drive path.

ACPI DMAC and DMAR tables have been updated in OC-VTD version to allow AppleVTD to load and have better Thunderbolt 3 support for devices like Apple's thunderbolt to ethernet adapter and (not tested yet) some audio interfaces.
** Bios VT-d option needs to be enabled for this feature.

For Thunderbolt 3 with most current HP firmware flashed, there's a Bios glitch that doesn't allow us to select "No Security" as an option. To fix it, you need to switch Thunderbolt to "Legacy Mode" in Bios/Advanced/Ports. then reboot, then go back to Bios/Advanced/Ports and under Thunderbolt security the option -No Security- appears, select it and reboot.
Now go back to Bios Setup again, and in Bios/Advanced/Ports/Thunderbolt, switch the "Legacy" option back to "Native+Low power"
You now have working TB3 ports with hot plug across all OS's

PolarisZBook_WX4170 is custom plist kext to inject power play tables and device properties to the AMD Video driver for better power management.
# You will need to read and follow the dortania guides to understand what you need to add to these files to be able to use them.


