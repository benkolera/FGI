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
    Send, /die add(3d6{!},5d8{!}k){ENTER}