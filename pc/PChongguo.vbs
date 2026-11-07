Option Explicit
' PChongguo - standalone PC window for short dramas.
' Uses the installed Microsoft Edge in app mode with a DESKTOP user agent.

Dim fso, sh, appDir, profile, edge, url, cmd, lnkPath, lnk, fullLnk, lnk2
Set fso = CreateObject("Scripting.FileSystemObject")
Set sh  = CreateObject("WScript.Shell")

appDir  = fso.GetParentFolderName(WScript.ScriptFullName)
profile = appDir & "\Profile"
If Not fso.FolderExists(profile) Then fso.CreateFolder profile

' One-time Desktop shortcut (skipped on later runs).
On Error Resume Next
lnkPath = sh.SpecialFolders("Desktop") & "\PChongguo.lnk"
If Not fso.FileExists(lnkPath) Then
    Set lnk = sh.CreateShortcut(lnkPath)
    lnk.TargetPath = sh.ExpandEnvironmentStrings("%WINDIR%") & "\System32\w" & "script.exe"
    lnk.Arguments = """" & appDir & "\PChongguo.vbs"""
    lnk.WorkingDirectory = appDir
    lnk.IconLocation = appDir & "\PChongguo.ico,0"
    lnk.Description = "PChongguo - short dramas on PC"
    lnk.Save
End If

' One-time Desktop shortcut for the local 'watch full series' guide.
fullLnk = sh.SpecialFolders("Desktop") & "\PChongguo-Full.lnk"
If fso.FileExists(appDir & "\fullwatch.html") Then
    If Not fso.FileExists(fullLnk) Then
        Set lnk2 = sh.CreateShortcut(fullLnk)
        lnk2.TargetPath = appDir & "\fullwatch.html"
        lnk2.WorkingDirectory = appDir
        lnk2.IconLocation = appDir & "\PChongguo.ico,0"
        lnk2.Description = "PChongguo - watch full series with my own QR"
        lnk2.Save
    End If
End If
On Error Goto 0

edge = FindEdge()
If edge = "" Then
    MsgBox "Microsoft Edge was not found." & vbCrLf & vbCrLf & _
           "Please install or repair Microsoft Edge, then open PChongguo again.", _
           16, "PChongguo"
    WScript.Quit 1
End If

' A DESKTOP user agent is required: mobile UA triggers the open-in-App gate.
url = "https://hongguoduanju.com/category/real-drama"

' Minimal, field-tested argument set (extra flags cause the window to exit).
cmd = """" & edge & """" & _
      " --app=" & url & _
      " --user-data-dir=""" & profile & """" & _
      " --no-first-run" & _
      " --no-default-browser-check" & _
      " --window-size=1280,860"

sh.Run cmd, 1, False

Function FindEdge()
    Dim cands, i, p
    cands = Array( _
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", _
        "C:\Program Files\Microsoft\Edge\Application\msedge.exe", _
        sh.ExpandEnvironmentStrings("%LOCALAPPDATA%") & "\Microsoft\Edge\Application\msedge.exe" )
    FindEdge = ""
    For i = 0 To UBound(cands)
        If fso.FileExists(cands(i)) Then
            FindEdge = cands(i)
            Exit Function
        End If
    Next
    On Error Resume Next
    p = sh.RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe\")
    If Err.Number = 0 Then
        If fso.FileExists(p) Then FindEdge = p
    End If
    On Error Goto 0
End Function
