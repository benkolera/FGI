#NoEnv 
#Warn  
SendMode Input 
SetWorkingDir %A_ScriptDir% 

F1::
if WinExist("Fantasy Grounds")
    WinActivate 
    Send, /reload{ENTER}

F2::
if WinExist("Fantasy Grounds")
    WinActivate 
    Send, /die 2d4{ENTER}