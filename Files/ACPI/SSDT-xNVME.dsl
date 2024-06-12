/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLg1ymzA.aml, Tue Jun 11 21:26:08 2024
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000008B (139)
 *     Revision         0x02
 *     Checksum         0x23
 *     OEM ID           "hack"
 *     OEM Table ID     "xNVME"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "xNVME", 0x00000000)
{
    External (_SB_.PCI0.RP09, DeviceObj) // Device Path to turn off internal not compatible NVME drive
    
    Scope (_SB.PCI0.RP09)
    {
        OperationRegion (DE01, PCI_Config, 0x50, One)
        Field (DE01, AnyAcc, NoLock, Preserve)
        {
                ,   1, 
                ,   3, 
            DDDD,   1
        }
    }

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.PCI0.RP09.DDDD = One  
        }
    }
}

