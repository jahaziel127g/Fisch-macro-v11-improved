#SingleInstance Force
SetKeyDelay, -1
SetMouseDelay, -1
SetBatchLines, -1
SetTitleMatchMode, 2

CoordMode, Tooltip, Relative
CoordMode, Pixel, Relative
CoordMode, Mouse, Relative

; ===================== ROD CONFIGURATION =====================
; Choose a rod type: "Standard", "Advanced", or "Custom"
RodType := "Standard"  

; Set rod-specific parameters
if (RodType = "Standard")
{
    RodCastDuration       := 480    ; how long to hold cast (ms)
    RodWaitForBobberDelay := 1000   ; wait for the bobber (ms)
    RodAdjustmentFactor   := 1.0    ; general adjustment multiplier
    RodControlResilience  := 1.0    ; default resilience (increase to make control more forgiving)
}
else if (RodType = "Advanced")
{
    RodCastDuration       := 400
    RodWaitForBobberDelay := 900
    RodAdjustmentFactor   := 0.9
    RodControlResilience  := 1.1
}
else if (RodType = "Custom")
{
    ; Set your custom parameters here
    RodCastDuration       := 500
    RodWaitForBobberDelay := 1100
    RodAdjustmentFactor   := 1.1
    RodControlResilience  := 1.2
}
; =============================================================

; ===================== GENERAL SETTINGS =====================
AutoLowerGraphics      := true
AutoGraphicsDelay      := 50

AutoZoomInCamera       := true
AutoZoomDelay          := 50

AutoEnableCameraMode   := true
AutoCameraDelay        := 50

AutoLookDownCamera     := true
AutoLookDelay          := 200

AutoBlurCamera         := true
AutoBlurDelay          := 50

RestartDelay           := 600    ; wait after fishing before restarting

NavigationKey          := "\"   ; IMPORTANT: set to your navigation key

; ===================== SHAKE SETTINGS =====================
ShakeMode              := "Click"   ; "Navigation" or "Click"
ClickShakeFailsafe     := 20      ; seconds before click shake failsafe
ClickShakeColorTolerance := 3
ClickScanDelay         := 20      ; ms delay between scans
RepeatBypassCounter    := 10      ; scans before forcing a click

NavigationShakeFailsafe:= 30      ; seconds for navigation shake failsafe
NavigationSpamDelay    := 10      ; ms delay between navigation key presses

; ===================== MINIGAME SETTINGS =====================
ManualBarSize          := 0       ; override calculated bar size if non-zero
BarCalculationFailsafe := 10      ; seconds for bar calc failsafe
BarSizeCalculationColorTolerance := 15

FishBarColorTolerance  := 5
WhiteBarColorTolerance := 16
ArrowColorTolerance    := 6

StabilizerLoop         := 12
SideBarRatio           := 0.8
SideBarWaitMultiplier  := 3.5

StableRightMultiplier  := 2.360
StableRightDivision    := 1.550
StableLeftMultiplier   := 1.211
StableLeftDivision     := 1.12

UnstableRightMultiplier:= 2.665
UnstableRightDivision  := 1.55
UnstableLeftMultiplier := 2.190
UnstableLeftDivision   := 1.17

RightAnkleBreakMultiplier := 1.35
LeftAnkleBreakMultiplier  := 0.45

; --------------------- Input Validation ---------------------
if (AutoLowerGraphics != true and AutoLowerGraphics != false)
{
    MsgBox, AutoLowerGraphics must be set to true or false!
    ExitApp
}
if (AutoEnableCameraMode != true and AutoEnableCameraMode != false)
{
    MsgBox, AutoEnableCameraMode must be set to true or false!
    ExitApp
}
if (AutoZoomInCamera != true and AutoZoomInCamera != false)
{
    MsgBox, AutoZoomInCamera must be set to true or false!
    ExitApp
}
if (AutoLookDownCamera != true and AutoLookDownCamera != false)
{
    MsgBox, AutoLookDownCamera must be set to true or false!
    ExitApp
}
if (AutoBlurCamera != true and AutoBlurCamera != false)
{
    MsgBox, AutoBlurCamera must be set to true or false!
    ExitApp
}
if (ShakeMode != "Navigation" and ShakeMode != "Click")
{
    MsgBox, ShakeMode must be set to "Click" or "Navigation"!
    ExitApp
}

; --------------------- Activate Roblox Window ---------------------
WinActivate, Roblox
if WinActive("Roblox")
{
    WinMaximize, Roblox
}
else
{
    MsgBox, where roblox bruh
    ExitApp
}

; Release keys initially
Send {lbutton up}
Send {rbutton up}
Send {shift up}

; ===================== CALCULATIONS =====================
WinGetActiveStats, Title, WindowWidth, WindowHeight, WindowLeft, WindowTop

CameraCheckLeft   := WindowWidth / 2.8444
CameraCheckRight  := WindowWidth / 1.5421
CameraCheckTop    := WindowHeight / 1.28
CameraCheckBottom := WindowHeight

ClickShakeLeft    := WindowWidth / 4.6545
ClickShakeRight   := WindowWidth / 1.2736
ClickShakeTop     := WindowHeight / 9
ClickShakeBottom  := WindowHeight / 1.3409

FishBarLeft       := WindowWidth / 3.3160
FishBarRight      := WindowWidth / 1.4317
FishBarTop        := WindowHeight / 1.1871
FishBarBottom     := WindowHeight / 1.1512

FishBarTooltipHeight := WindowHeight / 1.0626
ResolutionScaling := 2560 / WindowWidth

LookDownX         := WindowWidth / 2
LookDownY         := WindowHeight / 4

; Set up Tooltip positions (optional)
TooltipX := WindowWidth / 20
TooltipYBase := WindowHeight / 2 - 180

Tooltip(Num, Text) {
    global TooltipX, TooltipYBase
    Tooltip, %Text%, %TooltipX%, % (TooltipYBase + Num*20)
}

Tooltip(1, "Made By jaha127g")
Tooltip(2, "Runtime: 0h 0m 0s")
Tooltip(4, "Press 'P' to Start")
Tooltip(5, "Press 'O' to Reload")
Tooltip(6, "Press 'M' to Exit")
Tooltip(8, "AutoLowerGraphics: " . (AutoLowerGraphics ? "true" : "false"))
Tooltip(9, "AutoEnableCameraMode: " . (AutoEnableCameraMode ? "true" : "false"))
Tooltip(10, "AutoZoomInCamera: " . (AutoZoomInCamera ? "true" : "false"))
Tooltip(11, "AutoLookDownCamera: " . (AutoLookDownCamera ? "true" : "false"))
Tooltip(12, "AutoBlurCamera: " . (AutoBlurCamera ? "true" : "false"))
Tooltip(14, "Navigation Key: " . NavigationKey)
Tooltip(16, "Shake Mode: " . ShakeMode)
Tooltip(18, "Rod Type: " . RodType)
Tooltip(19, "Control Resilience: " . RodControlResilience)

; ===================== RUNTIME COUNTER =====================
runtimeS := 0, runtimeM := 0, runtimeH := 0
SetTimer, UpdateRuntime, 1000
UpdateRuntime:
    runtimeS++
    if (runtimeS >= 60)
    {
        runtimeS := 0, runtimeM++
    }
    if (runtimeM >= 60)
    {
        runtimeM := 0, runtimeH++
    }
    Tooltip(2, "Runtime: " . runtimeH . "h " . runtimeM . "m " . runtimeS . "s")
    if WinExist("ahk_exe RobloxPlayerBeta.exe")
    {
        if !WinActive("ahk_exe RobloxPlayerBeta.exe")
            WinActivate
    }
    else ExitApp
return

; ===================== HOTKEYS =====================
$o:: Reload
$m:: ExitApp
$p:: Gosub, StartMacro

; ===================== START OF MACRO =====================
StartMacro:
Gosub, UpdateCalculations
Tooltip(4, "Press 'O' to Reload")
Tooltip(5, "Press 'M' to Exit")

; -------- AutoLowerGraphics Section --------
Tooltip(7, "Current Task: AutoLowerGraphics")
f10counter := 0
if (AutoLowerGraphics)
{
    Send {shift}
    Tooltip(8, "Action: Press Shift")
    Sleep, AutoGraphicsDelay
    Send {shift down}
    Tooltip(8, "Action: Hold Shift")
    Sleep, AutoGraphicsDelay
    Loop, 20
    {
        f10counter++
        Tooltip(9, "F10 Count: " . f10counter . "/20")
        Send {f10}
        Tooltip(8, "Action: Press F10")
        Sleep, AutoGraphicsDelay
    }
    Send {shift up}
    Tooltip(8, "Action: Release Shift")
    Sleep, AutoGraphicsDelay
}

; -------- AutoZoomInCamera Section --------
Tooltip(7, "Current Task: AutoZoomInCamera")
scrollcounter := 0
if (AutoZoomInCamera)
{
    Sleep, AutoZoomDelay
    Loop, 20
    {
        scrollcounter++
        Tooltip(9, "Scroll In: " . scrollcounter . "/20")
        Send {wheelup}
        Tooltip(8, "Action: Scroll In")
        Sleep, AutoZoomDelay
    }
    Send {wheeldown}
    Tooltip(10, "Scroll Out: 1/1 - Action: Scroll Out")
    AutoZoomDelay *= 5
    Sleep, AutoZoomDelay
}

; -------- AutoEnableCameraMode Section --------
Tooltip(7, "Current Task: AutoEnableCameraMode")
rightcounter := 0
if (AutoEnableCameraMode)
{
    PixelSearch,,, CameraCheckLeft, CameraCheckTop, CameraCheckRight, CameraCheckBottom, 0xFFFFFF, 0, Fast
    if (ErrorLevel = 0)
    {
        Sleep, AutoCameraDelay
        Send {2}
        Tooltip(8, "Action: Press 2")
        Sleep, AutoCameraDelay
        Send {1}
        Tooltip(8, "Action: Press 1")
        Sleep, AutoCameraDelay
        Send %NavigationKey%
        Tooltip(8, "Action: Press " . NavigationKey)
        Sleep, AutoCameraDelay
        Loop, 10
        {
            rightcounter++
            Tooltip(9, "Right Count: " . rightcounter . "/10")
            Send {right}
            Tooltip(8, "Action: Press Right")
            Sleep, AutoCameraDelay
        }
        Send {enter}
        Tooltip(8, "Action: Press Enter")
        Sleep, AutoCameraDelay
    }
}

; -------- AutoLookDownCamera Section --------
Tooltip(7, "Current Task: AutoLookDownCamera")
if (AutoLookDownCamera)
{
    Send {rbutton up}
    Sleep, AutoLookDelay
    MouseMove, LookDownX, LookDownY
    Tooltip(8, "Action: Position Mouse")
    Sleep, AutoLookDelay
    Send {rbutton down}
    Tooltip(8, "Action: Hold Right Click")
    Sleep, AutoLookDelay
    DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", 10000)
    Tooltip(8, "Action: Move Mouse Down")
    Sleep, AutoLookDelay
    Send {rbutton up}
    Tooltip(8, "Action: Release Right Click")
    Sleep, AutoLookDelay
    MouseMove, LookDownX, LookDownY
    Tooltip(8, "Action: Position Mouse")
    Sleep, AutoLookDelay
}

; -------- AutoBlurCamera Section --------
Tooltip(7, "Current Task: AutoBlurCamera")
if (AutoBlurCamera)
{
    Sleep, AutoBlurDelay
    Send {m}
    Tooltip(8, "Action: Press M")
    Sleep, AutoBlurDelay
}

; -------- Casting Rod Section --------
Tooltip(7, "Current Task: Casting Rod")
Send {lbutton down}
Tooltip(8, "Action: Casting For " . RodCastDuration . "ms")
Sleep, RodCastDuration
Send {lbutton up}
Tooltip(8, "Action: Waiting For Bobber (" . RodWaitForBobberDelay . "ms)")
Sleep, RodWaitForBobberDelay

if (ShakeMode = "Click")
    Gosub, ClickShakeMode
else if (ShakeMode = "Navigation")
    Gosub, NavigationShakeMode
return

; ===================== UPDATE CALCULATIONS =====================
UpdateCalculations:
    WinGetActiveStats, Title, WindowWidth, WindowHeight, WindowLeft, WindowTop
    CameraCheckLeft   := WindowWidth / 2.8444
    CameraCheckRight  := WindowWidth / 1.5421
    CameraCheckTop    := WindowHeight / 1.28
    CameraCheckBottom := WindowHeight
    ClickShakeLeft    := WindowWidth / 4.6545
    ClickShakeRight   := WindowWidth / 1.2736
    ClickShakeTop     := WindowHeight / 9
    ClickShakeBottom  := WindowHeight / 1.3409
    FishBarLeft       := WindowWidth / 3.3160
    FishBarRight      := WindowWidth / 1.4317
    FishBarTop        := WindowHeight / 1.1871
    FishBarBottom     := WindowHeight / 1.1512
    FishBarTooltipHeight := WindowHeight / 1.0626
    ResolutionScaling := 2560 / WindowWidth
    LookDownX         := WindowWidth / 2
    LookDownY         := WindowHeight / 4
return

; ===================== CLICK SHAKE MODE =====================
ClickShakeMode:
Tooltip(7, "Current Task: Shaking (Click Mode)")
ClickFailsafeCount := 0, ClickCount := 0, ClickShakeRepeatBypassCounter := 0
MemoryX := 0, MemoryY := 0, ForceReset := false
SetTimer, ClickShakeFailsafe, 1000

ClickShakeModeRedo:
    if (ForceReset)
    {
        Gosub, RestartMacro
        return
    }
    Sleep, ClickScanDelay
    PixelSearch, , , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, FishBarColorTolerance, Fast
    if (ErrorLevel = 0)
    {
        SetTimer, ClickShakeFailsafe, Off
        Gosub, BarMinigame
        return
    }
    else
    {
        PixelSearch, ClickX, ClickY, ClickShakeLeft, ClickShakeTop, ClickShakeRight, ClickShakeBottom, 0xFFFFFF, ClickShakeColorTolerance, Fast
        if (ErrorLevel = 0)
        {
            Tooltip(8, "Click X: " . ClickX)
            Tooltip(9, "Click Y: " . ClickY)
            if (ClickX != MemoryX or ClickY != MemoryY)
            {
                ClickShakeRepeatBypassCounter := 0
                Tooltip(12, "Bypass Count: " . ClickShakeRepeatBypassCounter . "/" . RepeatBypassCounter)
                ClickCount++
                Click, %ClickX%, %ClickY%
                Tooltip(11, "Click Count: " . ClickCount)
                MemoryX := ClickX, MemoryY := ClickY
                goto ClickShakeModeRedo
            }
            else
            {
                ClickShakeRepeatBypassCounter++
                Tooltip(12, "Bypass Count: " . ClickShakeRepeatBypassCounter . "/" . RepeatBypassCounter)
                if (ClickShakeRepeatBypassCounter >= RepeatBypassCounter)
                    MemoryX := MemoryY := 0
                goto ClickShakeModeRedo
            }
        }
        else
            goto ClickShakeModeRedo
    }
return

ClickShakeFailsafe:
    ClickFailsafeCount++
    Tooltip(14, "Failsafe: " . ClickFailsafeCount . "/" . ClickShakeFailsafe)
    if (ClickFailsafeCount >= ClickShakeFailsafe)
    {
        SetTimer, ClickShakeFailsafe, Off
        ForceReset := true
    }
return

; ===================== NAVIGATION SHAKE MODE =====================
NavigationShakeMode:
Tooltip(7, "Current Task: Shaking (Navigation Mode)")
NavigationFailsafeCount := 0, NavigationCounter := 0, ForceReset := false
SetTimer, NavigationShakeFailsafe, 1000
Send %NavigationKey%
NavigationShakeModeRedo:
    if (ForceReset)
    {
        Gosub, RestartMacro
        return
    }
    Sleep, NavigationSpamDelay
    PixelSearch, , , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, FishBarColorTolerance, Fast
    if (ErrorLevel = 0)
    {
        SetTimer, NavigationShakeFailsafe, Off
        Gosub, BarMinigame
        return
    }
    else
    {
        NavigationCounter++
        Tooltip(8, "Attempt Count: " . NavigationCounter)
        Sleep, 1000
        Send {s}
        Sleep, 1000
        Send {enter}
        goto NavigationShakeModeRedo
    }
return

NavigationShakeFailsafe:
    NavigationFailsafeCount++
    Tooltip(10, "Failsafe: " . NavigationFailsafeCount . "/" . NavigationShakeFailsafe)
    if (NavigationFailsafeCount >= NavigationShakeFailsafe)
    {
        SetTimer, NavigationShakeFailsafe, Off
        ForceReset := true
    }
return

; ===================== BAR CALCULATION FAILSAFE =====================
BarCalculationFailsafe:
    BarCalcFailsafeCounter++
    Tooltip(10, "Failsafe: " . BarCalcFailsafeCounter . "/" . BarCalculationFailsafe)
    if (BarCalcFailsafeCounter >= BarCalculationFailsafe)
    {
        SetTimer, BarCalculationFailsafe, Off
        ForceReset := true
    }
return

; ===================== BAR MINIGAME =====================
BarMinigame:
Sleep, 600
Tooltip(7, "Current Task: Calculating Bar Size")
Tooltip(8, "Bar Size: Not Found")
Tooltip(10, "Failsafe: 0/" . BarCalculationFailsafe)
ForceReset := false
BarCalcFailsafeCounter := 0
SetTimer, BarCalculationFailsafe, 1000

BarMinigameRedo:
    if (ForceReset)
    {
        Gosub, RestartMacro
        return
    }
    PixelSearch, BarX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0xFFFFFF, BarSizeCalculationColorTolerance, Fast
    if (ErrorLevel = 0)
    {
        SetTimer, BarCalculationFailsafe, Off
        if (ManualBarSize != 0)
            WhiteBarSize := ManualBarSize
        else
            WhiteBarSize := (FishBarRight - (BarX - FishBarLeft)) - BarX
        Gosub, BarMinigameSingle
        return
    }
    Sleep, 1000
    goto BarMinigameRedo
return

; ===================== BAR MINIGAME (IMPROVED CONTROL) =====================
BarMinigameSingle:
Tooltip(7, "Current Task: Playing Bar Minigame (Improved Control)")
Tooltip(8, "Bar Size: " . WhiteBarSize)
; Use improved parameters: narrower safe zone and adjusted multipliers
NewSideBarRatio := 0.7
MaxLeftBar := FishBarLeft + WhiteBarSize * NewSideBarRatio
MaxRightBar := FishBarRight - WhiteBarSize * NewSideBarRatio
HalfBarSize := WhiteBarSize / 2

ImprovedStableLeftMultiplier := StableLeftMultiplier * 0.85
ImprovedStableRightMultiplier := StableRightMultiplier * 0.85
ImprovedUnstableLeftMultiplier := UnstableLeftMultiplier * 1.1
ImprovedUnstableRightMultiplier := UnstableRightMultiplier * 1.1

SideDelay := 0, AnkleBreakDelay := 0
DirectionalToggle := "Disabled"
AtLeastFindWhiteBar := false
MaxLeftToggle := false, MaxRightToggle := false

Tooltip(18, "Safe Left: " . Round(MaxLeftBar))
Tooltip(17, "Safe Right: " . Round(MaxRightBar))

Loop
{
    Sleep, 500
    PixelSearch, FishX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, FishBarColorTolerance, Fast
    if (ErrorLevel)
    {
        Send {lbutton up}
        Sleep, 20
        Continue
    }
    
    if (FishX < MaxLeftBar)
    {
        if (!MaxLeftToggle)
        {
            Tooltip(10, "Direction: Adjust Right")
            Difference := (MaxLeftBar - FishX) * ResolutionScaling * ImprovedStableLeftMultiplier * RodControlResilience
            Loop, % Ceil(Difference/10)
            {
                Send {lbutton up}
                Sleep, 10
            }
            MaxLeftToggle := true
        }
    }
    else if (FishX > MaxRightBar)
    {
        if (!MaxRightToggle)
        {
            Tooltip(10, "Direction: Adjust Left")
            Difference := (FishX - MaxRightBar) * ResolutionScaling * ImprovedStableRightMultiplier * RodControlResilience
            Loop, % Ceil(Difference/10)
            {
                Send {lbutton down}
                Sleep, 10
            }
            MaxRightToggle := true
        }
    }
    else
    {
        MaxLeftToggle := false, MaxRightToggle := false
        Tooltip(10, "Direction: Fine-tuning")
        PixelSearch, BarX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0xFFFFFF, WhiteBarColorTolerance, Fast
        if (!ErrorLevel)
        {
            AtLeastFindWhiteBar := true
            BarX += (WhiteBarSize / 2)
            if (BarX > FishX)
            {
                Difference := (BarX - FishX) * ResolutionScaling * ImprovedStableLeftMultiplier * RodControlResilience
                Loop, % Ceil(Difference/10)
                {
                    Send {lbutton up}
                    Sleep, 10
                }
            }
            else
            {
                Difference := (FishX - BarX) * ResolutionScaling * ImprovedStableRightMultiplier * RodControlResilience
                Loop, % Ceil(Difference/10)
                {
                    Send {lbutton down}
                    Sleep, 10
                }
            }
        }
        else
        {
            Send {lbutton up}
            Sleep, 20
            Send {lbutton down}
            Sleep, 20
        }
    }
    
    PixelSearch, , , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, FishBarColorTolerance, Fast
    if (!ErrorLevel)
    {
        Tooltip(10, "Fish locked. Exiting minigame loop.")
        Break
    }
}
Goto RestartMacro

RestartMacro:
Goto StartMacro
