#Requires AutoHotkey v2.0
#SingleInstance Force

global isRunning := false
global angle := 0
global timerInterval := 50 ; 20 times per second
global Pi := 3.141592653589793

A_IconTip := "EpicMouseMover v2 by elite hacker 2hourpause"

; Tray icon setup
A_TrayMenu.Delete()
A_TrayMenu.Add("Toggle Jitter", ToggleJitter)
A_TrayMenu.Add("Exit", (*) => ExitApp())
A_TrayMenu.Default := "Toggle Jitter"
A_TrayMenu.ClickCount := 1

TraySetIcon(A_ScriptDir "\epicmousemover.ico")

; Prompt on startup
if MsgBox("Start mouse jitter?", "EpicMouseMover v2 by elite hacker 2hourpause", "YesNo") = "Yes" {
    StartJitter()
}

; Hotkey: Ctrl + Alt + M
^!m::ToggleJitter()

ToggleJitter(*) {
    global isRunning
    if isRunning {
        StopJitter()
    } else {
        StartJitter()
    }
}

StartJitter() {
    global isRunning
    isRunning := true
    SetTimer(UpdateMousePosition, timerInterval)
    ShowTooltip("Jitter started (Press 'Ctrl+Alt+M' to stop)")
}

StopJitter() {
    global isRunning
    isRunning := false
    SetTimer(UpdateMousePosition, 0)
    ShowTooltip("Jitter stopped (Press 'Ctrl+Alt+M' to start)")
}

UpdateMousePosition() {
    global angle

    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight
    centerX := screenWidth // 2
    centerY := screenHeight // 2
    radiusX := centerX * 0.8
    radiusY := centerY * 0.8

    x := centerX + radiusX * Cos(angle)
    y := centerY + radiusY * Sin(angle)

    DllCall("SetCursorPos", "int", Round(x), "int", Round(y))

    angle += (2 * Pi) / 20
    if angle > (2 * Pi)
        angle -= (2 * Pi)
}

ShowTooltip(text) {
    MouseGetPos &x, &y
    ToolTip(text, x + 20, y + 20)
    SetTimer(() => ToolTip(), -3000) ; Auto-hide after 1.5 seconds
}
