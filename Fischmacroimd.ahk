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

; Set default parameters; you can adjust these values per rod type
if (RodType = "Standard")
{
    RodCastDuration      := 480    ; how long to hold cast (ms)
    RodWaitForBobberDelay:= 1000   ; wait for the bobber (ms)
    RodAdjustmentFactor  := 1.0    ; multiplier for any rod-specific adjustments
}
else if (RodType = "Advanced")
{
    RodCastDuration      := 400
    RodWaitForBobberDelay:= 900
    RodAdjustmentFactor  := 0.9
}
else if (RodType = "Custom")
{
    ; Set your custom parameters here
    RodCastDuration      := 500
    RodWaitForBobberDelay:= 1100
    RodAdjustmentFactor  := 1.1
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

Tooltip(1, "Made By AsphaltCake")
Tooltip(2, "Runtime: 0h 0m 0s")
Tooltip(4, "Press 'P' to Start")
Tooltip(5, "Press 'O
