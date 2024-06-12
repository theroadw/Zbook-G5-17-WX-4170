/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLYwbPoB.aml, Tue Jun 11 21:15:24 2024
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000002DE (734)
 *     Revision         0x01
 *     Checksum         0xC5
 *     OEM ID           "HP"
 *     OEM Table ID     "DGPUOFF"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 1, "HP", "DGPUOFF", 0x00001000)
{
    External (_SB_.ODGW, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.EC__.ECMX, MutexObj)
    External (_SB_.PCI0.LPCB.EC__.ECRG, IntObj)
    External (_SB_.PCI0.LPCB.EC__.TENA, FieldUnitObj)
    External (_SB_.PCI0.PEG0.PEGP, DeviceObj)
    External (_SB_.PCI0.PEG0.PEGP._OFF, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.PEG0.PEGP.MLTF, FieldUnitObj)
    External (_SB_.PCI0.PEG0.PEGP.VRID, FieldUnitObj)
    External (_SB_.SGOV, MethodObj)    // 2 Arguments
    External (POHB, FieldUnitObj)
    External (POLB, FieldUnitObj)
    External (S3HB, FieldUnitObj)
    External (S3LB, FieldUnitObj)
    External (SDTG, FieldUnitObj)

    Scope (\_SB)
    {
        Method (CWAK, 1, Serialized)
        {
            ODGW ((0xF0 | Arg0))
            POLB = (0xF0 | Arg0)
            POHB = Zero
            If ((Arg0 == 0x03))
            {
                S3LB = (0xF0 | Arg0)
                S3HB = Zero
            }

            Sleep (0x64)
            If (CondRefOf (\_SB.PCI0.PEG0.PEGP._OFF))   // On Wake Turn DGPU OFF
            {
                \_SB.PCI0.PEG0.PEGP._OFF ()
            }

            XMXX ()  // On Wake Turn Power Limiter OFF and make sure mux switch is on igpu
        }
    }

    Scope (\_SB.PCI0.PEG0.PEGP)  // Hijack RDSS (REG) method on boot
    {
        Method (RDSS, 1, Serialized)
        {
            If (\_SB.PCI0.LPCB.EC.ECRG)
            {
                Acquire (\_SB.PCI0.LPCB.EC.ECMX, 0xFFFF)
                If ((Arg0 == One))
                {
                    If ((VRID == 0x1002))
                    {
                        \_SB.PCI0.LPCB.EC.TENA = 0x03
                    }
                    ElseIf ((VRID == 0x10DE))
                    {
                        \_SB.PCI0.LPCB.EC.TENA = 0x05
                    }
                    Else
                    {
                        \_SB.PCI0.LPCB.EC.TENA = One
                    }
                }
                Else
                {
                    \_SB.PCI0.LPCB.EC.TENA = One
                }

                Release (\_SB.PCI0.LPCB.EC.ECMX)
            }

            XMXX () // Mux and power limiter
        }
    }

    Method (XMXX, 0, NotSerialized)
    {
        If (CondRefOf (\_SB.SGOV))
        {
            \_SB.SGOV (SDTG, One)  // Make sure mux switch is on igpu
        }
        
        // Turn Power Limiter OFF

        LKZ1 = Zero
        LKZ2 = 0x80000000
    }

    OperationRegion (HPZK, SystemMemory, 0xFED159A0, 0x64)
    Field (HPZK, AnyAcc, Lock, Preserve)
    {
        LKZ1,   32,  // Define Power Limiter memory regions
        LKZ2,   32
    }
}

