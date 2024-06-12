/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLHl3fQR.aml, Tue Jun 11 21:28:13 2024
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000083E (2110)
 *     Revision         0x02
 *     Checksum         0x75
 *     OEM ID           "CORP"
 *     OEM Table ID     "ZBOK"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "CORP", "ZBOK", 0x00000000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.B0D4, DeviceObj)
    External (_SB_.PCI0.GFX0.PNLF, DeviceObj)
    External (_SB_.PCI0.I2C0, DeviceObj)
    External (_SB_.PCI0.I2C1, DeviceObj)
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.LPCB.HPET, DeviceObj)
    External (_SB_.PCI0.LPCB.PS2K, DeviceObj)
    External (_SB_.PCI0.SBUS.BUS0, DeviceObj)
    External (_SB_.PR00, ProcessorObj)
    External (DSPM, FieldUnitObj)
    External (HPTE, FieldUnitObj)
    External (SSD0, FieldUnitObj)
    External (SSD1, FieldUnitObj)
    External (SSH0, FieldUnitObj)
    External (SSH1, FieldUnitObj)
    External (SSL0, FieldUnitObj)
    External (SSL1, FieldUnitObj)
    External (STAS, IntObj)
    External (USWE, FieldUnitObj)
    External (XPRW, MethodObj)    // 2 Arguments

// All Extra devices needed


    Method (PMPM, 4, NotSerialized)
    {
        If ((Arg2 == Zero))
        {
            Return (Buffer (One)
            {
                 0x03                                             // .
            })
        }

        Return (Package (0x02)
        {
            "plugin-type", // CPU Plugin type one
            One
        })
    }

    Scope (\_SB.PR00)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            Return (PMPM (Arg0, Arg1, Arg2, Arg3))
        }
    }

    Scope (_SB.PCI0.LPCB.HPET) // Adjust HPET device
    {
        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            If (_OSI ("Darwin"))
            {
                HPTE = Zero
                STAS = 0x04
            }
        }
    }

    Scope (_SB.PCI0.LPCB)
    {
        Device (PMCR) // Add HPET device

        {
            Name (_HID, EisaId ("APP9876"))  // _HID: Hardware ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0B)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0xFE020000,         // Address Base
                    0x00010000,         // Address Length
                    )
            })
        }

        Device (RTC0)  // Adjust RTC device to avoid Bios error on reboot
        {
            Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0070,             // Range Minimum
                    0x0070,             // Range Maximum
                    0x01,               // Alignment
                    0x02,               // Length
                    )
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }

        Device (DMAC) // Add DMAC device
        {
            Name (_HID, EisaId ("PNP0200") /* PC-class DMA Controller */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0000,             // Range Minimum
                    0x0000,             // Range Maximum
                    0x01,               // Alignment
                    0x20,               // Length
                    )
                IO (Decode16,
                    0x0081,             // Range Minimum
                    0x0081,             // Range Maximum
                    0x01,               // Alignment
                    0x11,               // Length
                    )
                IO (Decode16,
                    0x0093,             // Range Minimum
                    0x0093,             // Range Maximum
                    0x01,               // Alignment
                    0x0D,               // Length
                    )
                IO (Decode16,
                    0x00C0,             // Range Minimum
                    0x00C0,             // Range Maximum
                    0x01,               // Alignment
                    0x20,               // Length
                    )
                DMA (Compatibility, NotBusMaster, Transfer8_16, )
                    {4}
            })
        }
    }

    Scope (\_SB.PCI0)
    {
        Device (MCHC)  // Add devices
        {
            Name (_ADR, Zero)  // _ADR: Address
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }

        Device (THRM)
        {
            Name (_ADR, 0x00120000)  // _ADR: Address
        }

        Device (SRAM)
        {
            Name (_ADR, 0x00140002)  // _ADR: Address
        }
    }

    Device (\_SB.PCI0.SBUS.BUS0)  // Add diagsvault DVL0 device
    {
        Name (_CID, "smbus")  // _CID: Compatible ID
        Name (_ADR, Zero)  // _ADR: Address
        Device (DVL0)
        {
            Name (_ADR, 0x57)  // _ADR: Address
            Name (_CID, "diagsvault")  // _CID: Compatible ID
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If (!Arg2)
                {
                    Return (Buffer (One)
                    {
                         0x57                                             // W
                    })
                }

                Return (Package (0x02)
                {
                    "address", 
                    0x57
                })
            }
        }

        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
        }
    }

    Method (GPRW, 2, NotSerialized) // Adjust Method GPRW for better sleep
    {
        If ((0x6D == Arg0))
        {
            Return (Package (0x02)
            {
                0x6D, 
                Zero
            })
        }

        If ((0x0D == Arg0))
        {
            Return (Package (0x02)
            {
                0x0D, 
                Zero
            })
        }

        Return (XPRW (Arg0, Arg1))
    }

    Method (UPRW, 2, NotSerialized) // Adjust Method UPRW for better sleep
    {
        If ((0x6D == Arg0))
        {
            Return (Package (0x02)
            {
                0x6D, 
                Zero
            })
        }

        If ((0x0D == Arg0))
        {
            Return (Package (0x02)
            {
                0x0D, 
                Zero
            })
        }

        Return (XPRW (Arg0, Arg1))
    }

    Scope (\_SB.PCI0.LPCB.PS2K) // adjust keyboard and map function keys
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If (!Arg2)
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x04)
            {
                "RM,oem-id", 
                "HPQOEM", 
                "RM,oem-table-id", 
                "ProBook-87"
            })
        }

        Name (RMCF, Package (0x02)
        {
            "Keyboard", 
            Package (0x08)
            {
                "Function Keys Special", 
                Package (0x18)
                {
                    Package (0x00){}, 
                    "e05f=3b", 
                    "e06e=3c", 
                    "e012=3d", 
                    "e017=3e", 
                    "e00a=3f", 
                    "e009=40", 
                    "e020=e020", 
                    "e010=e010", 
                    "e022=e022", 
                    "e019=e019", 
                    "e078=e022", 
                    "3a=e05b", 
                    "6b=65", 
                    "3d=e012", 
                    "3e=e017", 
                    "3f=e020", 
                    "40=e02e", 
                    "41=e030", 
                    "42=e02e", 
                    "43=e030", 
                    "44=e010", 
                    "57=e022", 
                    "58=e019"
                }, 

                "Function Keys Standard", 
                Package (0x10)
                {
                    Package (0x00){}, 
                    "e05f=e05f", 
                    "e06e=e06e", 
                    "e02e=e02e", 
                    "e030=e030", 
                    "e009=e009", 
                    "e012=e012", 
                    "e017=e017", 
                    "e033=e033", 
                    "3d=3d", 
                    "3e=3e", 
                    "40=40", 
                    "41=41", 
                    "42=42", 
                    "43=43", 
                    "44=44"
                }, 

                "Custom ADB Map", 
                Package (0x05)
                {
                    Package (0x00){}, 
                    "46=4d", 
                    "e045=34", 
                    "e052=42", 
                    "e046=92"
                }, 

                "Swap command and option", 
                ">y"
            }
        })
    }

    Device (_SB.PCI0.GFX0.PNLF) // Add PNLF device for LCD power
    {
        Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
        Name (_CID, "backlight")  // _CID: Compatible ID
        Name (_UID, 0x13)  // _UID: Unique ID
        Name (_STA, 0x0B)  // _STA: Status
    }

    Method (XOSI, 1, NotSerialized) // Add XOSI
    {
        If (_OSI ("Darwin"))
        {
            Local0 = Package (0x10)
                {
                    "Windows", 
                    "Windows 2001", 
                    "Windows 2001 SP2", 
                    "Windows 2006", 
                    "Windows 2006 SP1", 
                    "Windows 2009", 
                    "Windows 2012", 
                    "Windows 2013", 
                    "Windows 2015", 
                    "Windows 2016", 
                    "Windows 2017", 
                    "Windows 2017.2", 
                    "Windows 2018", 
                    "Windows 2018.2", 
                    "Windows 2019", 
                    "Windows 2020"
                }
            Return ((Ones != Match (Local0, MEQ, Arg0, MTR, Zero, Zero)))
        }
        Else
        {
            Return (_OSI (Arg0))
        }
    }

    Scope (\_SB)
    {
        Device (USBX) // Add USB power
        {
            Name (_ADR, Zero)  // _ADR: Address
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                Return (Package (0x08)
                {
                    "kUSBSleepPowerSupply", 
                    0x13EC, 
                    "kUSBSleepPortCurrentLimit", 
                    0x0834, 
                    "kUSBWakePowerSupply", 
                    0x13EC, 
                    "kUSBWakePortCurrentLimit", 
                    0x0834
                })
            }
        }
    }

    Scope (_SB.PCI0)
    {
        Device (XSPI) // Hide device XSPI
        {
            Name (_ADR, 0x001F0005)  // _ADR: Address
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                Return (Package (0x02)
                {
                    "pci-device-hidden", 
                    Buffer (0x08)
                    {
                         0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   // ........
                    }
                })
            }
        }
    }
    
    Scope (\)  // Fix trackpad device
    {
        Method (PKG4, 3, Serialized)
        {
            Name (PKG, Package (0x03)
            {
                Zero, 
                Zero, 
                Zero
            })
            PKG [Zero] = Arg0
            PKG [One] = Arg1
            PKG [0x02] = Arg2
            Return (PKG) /* \PKG4.PKG_ */
        }
    }

    Scope (_SB.PCI0.I2C0)
    {
        Method (SSCN, 0, NotSerialized)
        {
            Return (PKG4 (SSH0, SSL0, SSD0))
        }

        Method (FMCN, 0, NotSerialized)
        {
            Name (PKG, Package (0x03)
            {
                0x0101, 
                0x012C, 
                0x62
            })
            Return (PKG) /* \_SB_.PCI0.I2C0.FMCN.PKG_ */
        }
    }

    Scope (_SB.PCI0.I2C1)
    {
        Method (SSCN, 0, NotSerialized)
        {
            Return (PKG4 (SSH1, SSL1, SSD1))
        }

        Method (FMCN, 0, NotSerialized)
        {
            Name (PKG, Package (0x03)
            {
                0x0101, 
                0x012C, 
                0x62
            })
            Return (PKG) /* \_SB_.PCI0.I2C1.FMCN.PKG_ */
        }
    }

    Method (DTGP, 5, NotSerialized) // Add Method DTPG for old patches
    {
        If ((Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b") /* Unknown UUID */))
        {
            If ((Arg1 == One))
            {
                If ((Arg2 == Zero))
                {
                    Arg4 = Buffer (One)
                        {
                             0x03                                             // .
                        }
                    Return (One)
                }

                If ((Arg2 == One))
                {
                    Return (One)
                }
            }
        }

        Arg4 = Buffer (One)
            {
                 0x00                                             // .
            }
        Return (Zero)
    }
}

