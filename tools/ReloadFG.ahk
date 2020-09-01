#NoEnv 
#Warn  
SendMode Input 
SetWorkingDir %A_ScriptDir% 

F1::
if WinExist("ahk_class HORIZON")
    WinActivate 
    Send, /reload{ENTER}

F2::
if WinExist("ahk_class HORIZON")
    WinActivate 
    Send, /die 3d6{!}+5d8{!}k{ENTER}