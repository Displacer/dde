path = "info.exe"
login = "YourLogin"
pass = "YourPassword"

set WshShell = WScript.CreateObject("WScript.Shell")
Set quik = WshShell.Exec(path)

Do Until Dummy = true
WScript.Sleep 1000
' ������ �������, �.�. � VBScript ���� DoEvents
Loop

Call Logon

Function Dummy
Dummy = false
If WshShell.AppActivate("������������� ������������") then
Dummy = True
Exit Function
End If
End Function

Sub Logon
WshShell.SendKeys login
WshShell.SendKeys "{TAB}"
WScript.Sleep 100
WshShell.SendKeys pass + "~"
End Sub