[General]
SyntaxVersion=2
BeginHotkey=49
BeginHotkeyMod=2
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=c734c388-fcfa-4b04-a288-a17a4bb5e4d6
Description=连连看点击2
Enable=1
AutoRun=0
[Repeat]
Type=0
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]

[Script]
step_path = "step.txt"

title = "linkgame"
nx = 12
ny = 7
width = 40
height = 50

Hwnd = Plugin.Window.Find("SunAwtFrame", title)   
Call Plugin.Window.Move(Hwnd, 0, 0)
Call Plugin.Window.Top(Hwnd, 0)
Call Plugin.Window.SetClientSize(Hwnd, width * (nx + 2), height * (ny + 2))

file2 = Plugin.File.OpenFile(step_path)

pos = Plugin.File.ReadLine(file2)
If pos <> "-1" Then 
	x1 = int(pos * width + width / 2)
	pos = Plugin.File.ReadLine(file2)
	y1 = int((ny + 1 - pos) * height + height / 2)
	pos = Plugin.File.ReadLine(file2)
	x2 = int(pos * width + width / 2)
	pos = Plugin.File.ReadLine(file2)
	y2 = int((ny + 1 - pos) * height + height / 2)
	MoveTo x1, y1
	Delay 500
	LeftClick 1
	Delay 300
	MoveTo x2, y2
	Delay 500
	LeftClick 1
End If

Call Plugin.File.CloseFile(file2)
	
Hwnd = Plugin.Window.Find("#32770", "linkgame_auto")
Call Plugin.Window.CloseEx(Hwnd)



