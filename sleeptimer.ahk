; Sleep Timer - AutoHotkey v2
; GUI with Hours / Minutes / Seconds and a Sleep button
; Schedules a Windows shutdown using: start /b shutdown /s /f /t <seconds>

#Requires AutoHotkey v2.0

; Create GUI
dlg := Gui()
; global Hours, Minutes, Seconds
; Labels and inputs
dlg.Add("Text", "x10 y12", "Hours:")
dlg.Add("Edit", "x70 y10 w60 vHours Number", "0")
dlg.Add("Text", "x150 y12", "Minutes:")
dlg.Add("Edit", "x215 y10 w60 vMinutes Number", "0")
dlg.Add("Text", "x295 y12", "Seconds:")
dlg.Add("Edit", "x355 y10 w60 vSeconds Number", "0")
; Sleep button
btnSleep := dlg.Add("Button", "x10 y50 w200 h30", "Sleep")
btnSleep.OnEvent("Click", DoSleep)

; Exit button (optional)
btnExit := dlg.Add("Button", "x220 y50 w195 h30", "Exit")
btnExit.OnEvent("Click", (*) => dlg.Destroy())

; Abort button
btnAbort := dlg.Add("Button", "x10 y90 w405 h30", "Abort Shutdown")
btnAbort.OnEvent("Click", Abort)
; dlg.Opt("+AlwaysOnTop")
; dlg.OnEvent("Close", (*) => MsgBox("Please use the Exit button to close the application."))
dlg.Show()

; --- Functions ---
DoSleep(*) {
    ; global Hours, Minutes, Seconds, dlg
    ; Pull control values into variables
    dlg.Submit()
    ; Normalize/convert inputs to numeric values (defaults to 0)
    hours := dlg["Hours"].Value + 0
    minutes := dlg["Minutes"].Value + 0
    seconds := dlg["Seconds"].Value + 0


    ; Make sure values are non-negative integers
    if (hours < 0)
        hours := -hours
    if (minutes < 0)
        minutes := -minutes
    if (seconds < 0)
        seconds := -seconds

    total := hours * 3600 + minutes * 60 + seconds

    if (total <= 0) {
        MsgBox("Please enter a time greater than 0 seconds.")
        return
    }

    ; Build command using cmd.exe and start to run shutdown in background
    cmd := "shutdown /s /f /t " total

    ; Inform the user and run the command
    MsgBox("Scheduling shutdown in " total " seconds.")
    Run(cmd)

    ; Keep the GUI open so user can see status; close if desired:
    ; ExitApp()
}

Abort(*){
    ; Abort scheduled shutdown
    Run("shutdown /a")
    MsgBox("Scheduled shutdown aborted.")
}
Return
