/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLu3v42L.aml, Sat Jun 15 19:16:55 2024
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000003B4 (948)
 *     Revision         0x02
 *     Checksum         0x31
 *     OEM ID           "MUXCTL"
 *     OEM Table ID     "MUXCTL"
 *     OEM Revision     0x00003000 (12288)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 2, "MUXCTL", "MUXCTL", 0x00003000)
{
    External (_SB_.PCI0.LPCB.EC0_.ADP_, IntObj)
    External (_SB_.PCI0.LPCB.EC__.ECMX, MutexObj)
    External (_SB_.PCI0.LPCB.EC__.ECRG, IntObj)
    External (_SB_.PCI0.LPCB.EC__.TENA, FieldUnitObj)
    External (_SB_.PCI0.PEG0.PEGP, DeviceObj)
    External (_SB_.PCI0.PEG0.PEGP.NPLH, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.PEG0.PEGP.VRID, FieldUnitObj)
    External (_SB_.SGOV, MethodObj)    // 2 Arguments
    External (NDXN, FieldUnitObj)
    External (SDTG, FieldUnitObj)
    External (SUOG, FieldUnitObj)
    External (ZWAK, MethodObj)    // 1 Arguments

    Scope (\_SB.PCI0.PEG0.PEGP)
    {
        Method (RDSS, 1, Serialized)  // Hijack RDSS (REG) method on boot
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

            XMXX ()  // Mux and power limiter
        }

        Name (DEVT, Zero)  // These are Nvidia PCI calls on power change from AC to BATT
        Method (RNPL, 0, NotSerialized)  // After adding these, there were no more DGPU memory corruption yellow screens
        {
            \_SB.PCI0.PEG0.PEGP.DEVT = Zero
        }

        Method (NPD5, 0, NotSerialized)  // Nvidia PCI call on AC to BATT
        {
            If ((\_SB.PCI0.PEG0.PEGP.DEVT == One))
            {
                Notify (\_SB.PCI0.PEG0.PEGP, 0xD5) // Hardware-Specific
                NDXN = 0xD5
            }
        }

        Method (NPLU, 0, NotSerialized)  // Nvidia PCI call on AC to BATT
        {
            If (CondRefOf (\_SB.PCI0.PEG0.PEGP.NPLH))
            {
                If ((\_SB.PCI0.PEG0.PEGP.DEVT == One))
                {
                    \_SB.PCI0.PEG0.PEGP.NPLH ()
                }
            }
            ElseIf ((\_SB.PCI0.LPCB.EC0.ADP == One))
            {
                If ((\_SB.PCI0.PEG0.PEGP.DEVT == One))
                {
                    Notify (\_SB.PCI0.PEG0.PEGP, 0xD1) // Hardware-Specific
                    NDXN = 0xD1
                }
            }
            ElseIf ((\_SB.PCI0.PEG0.PEGP.DEVT == One))
            {
                Notify (\_SB.PCI0.PEG0.PEGP, 0xD4) // Hardware-Specific
                NDXN = 0xD4
            }
        }
    }

    Method (XMXX, 0, NotSerialized)
    {
        If (CondRefOf (\_SB.SGOV))
        {
            \_SB.SGOV (SUOG, Zero)  // Make sure LCD mux switch is on DGPU
        }
        
         // Turn Power Limiter OFF

        LKZ1 = Zero
        LKZ2 = 0x80000000
    }

    Method (_WAK, 1, NotSerialized)  // _WAK: Wake
    {
        Local0 = ZWAK (Arg0)
        XMXX ()  // Call Mux and power limiter
        Return (Local0)
    }

    OperationRegion (HPZK, SystemMemory, 0xFED159A0, 0x64)
    Field (HPZK, AnyAcc, Lock, Preserve)
    {
        LKZ1,   32,  // Define Power Limiter memory regions
        LKZ2,   32
    }
}

