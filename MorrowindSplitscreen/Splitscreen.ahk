#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; for tes3mp splitscreen
; disables clicking in the wrong window
; while using gamepad and mouse/keyboard
; by discordpeter

SetTitleMatchMode, 2
DetectHiddenWindows, On

ahk = no ;set to inactive by default


Sleep 4000
WinGet, WinID, ID, Firefox
ControlClick,,ahk_id %WinID%,,LEFT
ToolTip, Please recognize. the now active window was chosen. Use k to remap all clicks to this window

Sleep 7000
ToolTip





LButton::
if (ahk = "yes")
ControlClick,,ahk_id %WinID%,,LEFT
else
Send, {LButton}
return

RButton::
if (ahk = "yes")
ControlClick,,ahk_id %WinID%,,RIGHT
else
Send, {RButton}
return

k::
if (ahk = "no")
{
ahk = yes
ToolTip, activated
Sleep 2000
ToolTip
}
else
{
ahk = no
ToolTip, deactivated
Sleep 2000
ToolTip
}
Return

l::
WinClose, Splitscreen.ahk - AutoHotkey
return

j::
WinClose, Splitscreen.ahk - AutoHotkey
return
