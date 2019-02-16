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
WinGet, WinID, ID, OpenMW
ahk = no

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
ahk = yes
else
ahk = no
Return

l::
WinClose, Splitscreen.ahk - AutoHotkey
return

j::
WinClose, Splitscreen.ahk - AutoHotkey
return
