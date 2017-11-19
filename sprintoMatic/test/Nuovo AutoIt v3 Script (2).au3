#RequireAdmin
#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WindowsConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
Global $SwtorWindowHandle = 0
Global $title = "Dark Age of Camelot © 2001-2015 Electronic Arts Inc. All Rights Reserved."
Global $GameWindowDesc = "[TITLE:Dark Age of Camelot © 2001-2015 Electronic Arts Inc. All Rights Reserved.; CLASS:DAoCMW]"

Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 11)
TraySetClick(16)

$infoitem = TrayCreateItem("Info")
TrayItemSetOnEvent(-1, "_ShowInfo")
TrayCreateItem("")
$removeborders = TrayCreateItem("Remove Borders")
TrayItemSetOnEvent(-1, "_RemoveBorders")
$showborders = TrayCreateItem("Show Borders")
TrayItemSetOnEvent(-1, "_ShowBorders")
TrayCreateItem("")
$removeborders = TrayCreateItem("Restore Window")
TrayItemSetOnEvent(-1, "_RestoreWin")
$showborders = TrayCreateItem("Minimize Window")
TrayItemSetOnEvent(-1, "_MinimizeWin")
$showborders = TrayCreateItem("Close Window")
TrayItemSetOnEvent(-1, "_CloseWin")
$showborders = TrayCreateItem("Move Window ...")
TrayItemSetOnEvent(-1, "_MoveWin")
TrayCreateItem("")
$setres = TrayCreateItem("Set Resolution ...")
TrayItemSetOnEvent(-1, "_Setup")
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_ExitScript")
TraySetState()

_verify_resolutions_file()

While 1
;~ 	If Not WinExists($GameWindowDesc) And Not ($SwtorWindowHandle = 0) Then
;~ 		$SwtorWindowHandle = 0
;~ 	EndIf
;~ 	If WinExists($GameWindowDesc) And $SwtorWindowHandle = 0 Then
		$SwtorWindowHandle = 0x00040786;WinGetHandle($GameWindowDesc)
;~ 		If FileExists(@ScriptDir & "\settings.ini") Then
;~ 			Sleep(5000)
			_RemoveBorders()
;~ 		EndIf
;~ 	EndIf
	Sleep(100)
WEnd

Func _ShowInfo()
	MsgBox(0, $title, "This tool removes the borders if you're running SWTOR in windowed mode.")
EndFunc   ;==>_ShowInfo

Func _setres()
	If Not ($SwtorWindowHandle = 0) Then
		$use_custom = IniRead(@ScriptDir & "\settings.ini", "settings", "use custom resolution", "error")
		If Not ($use_custom = "error") Then
			If $use_custom = 1 Then
				$res = IniRead(@ScriptDir & "\settings.ini", "settings", "custom resolution", "error")
			Else
				$res = IniRead(@ScriptDir & "\settings.ini", "settings", "resolution", "error")
			EndIf
			If Not ($res = "error") And Not ($res = "") Then
				$split = StringSplit($res, "x")
				_WinSetClientAreaSize($SwtorWindowHandle, $split[1], $split[2])
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_setres

Func _RemoveBorders()
	Local $use_custom, $res, $split
	If Not ($SwtorWindowHandle = 0) Then
		If _CurrentWindowMode() = "borders" Then
			_WinSetStyle($SwtorWindowHandle, $WS_BORDER)
			_setres()
		EndIf
	EndIf
EndFunc   ;==>_RemoveBorders

Func _ShowBorders()
	If Not ($SwtorWindowHandle = 0) Then
		If _CurrentWindowMode() = "borderless" Then
			_WinSetStyle($SwtorWindowHandle, -1)
		EndIf
	EndIf
EndFunc   ;==>_ShowBorders

Func _RestoreWin()
	If Not ($SwtorWindowHandle = 0) Then
		WinSetState($SwtorWindowHandle, "", @SW_RESTORE)
	EndIf
EndFunc   ;==>_RestoreWin

Func _MinimizeWin()
	If Not ($SwtorWindowHandle = 0) Then
		WinSetState($SwtorWindowHandle, "", @SW_MINIMIZE)
	EndIf
EndFunc   ;==>_MinimizeWin

Func _MoveWin()
	If Not ($SwtorWindowHandle = 0) Then
		$SWTORWinMoveTool = GUICreate("SWTOR Window Move Tool", 290, 185)
		$size = WinGetPos($SWTORWinMoveTool)
		WinMove($SWTORWinMoveTool, "", @DesktopWidth - $size[2] - 200, @DesktopHeight - $size[3] - 200)
		$Button1 = GUICtrlCreateButton("Move SWTOR Window using Mouse", 50, 16, 192, 25)
		GUICtrlCreateLabel("or enter screen coordinates manually in the two input fields below", 18, 53, 265, 29)
		$Input1 = GUICtrlCreateInput("", 66, 91, 65, 21)
		GUICtrlCreateLabel("X", 142, 95, 11, 17)
		$Input2 = GUICtrlCreateInput("", 162, 91, 65, 21)
		$Checkbox1 = GUICtrlCreateCheckbox("remember and apply on game and script start", 30, 128, 250, 17)
		$Button2 = GUICtrlCreateButton("Save and Exit", 81, 155, 130, 25)

		GUISetState(@SW_SHOW)

		While 1
			$winpos = WinGetPos($SwtorWindowHandle)
			If Not (ControlGetFocus($SWTORWinMoveTool) = "Edit1") And Not (ControlGetFocus($SWTORWinMoveTool) = "Edit2") Then
				GUICtrlSetData($Input1, $winpos[0])
				GUICtrlSetData($Input2, $winpos[1])
			Else
				WinMove($SwtorWindowHandle, "", GUICtrlRead($Input1), GUICtrlRead($Input2))
			EndIf

			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					GUIDelete($SWTORWinMoveTool)
					ExitLoop
				Case $Button2
					If GUICtrlRead($Checkbox1) = 1 Then
						IniWrite(@ScriptDir & "\settings.ini", "settings", "reposition window", "1")
						IniWrite(@ScriptDir & "\settings.ini", "settings", "window position", GUICtrlRead($Input1) & "x" & GUICtrlRead($Input2))
					Else
						IniWrite(@ScriptDir & "\settings.ini", "settings", "reposition window", "0")
					EndIf
					GUIDelete($SWTORWinMoveTool)
					ExitLoop
				Case $Button1
					MsgBox(0, "SWTOR Window Move Tool", 'When clicking on the "OK" button below, your mouse pointer will be moved to the center of the SWTOR ' & _
							'window and that window be put in "move mode". It will follow the mouse pointer until you click the left or right mouse button.')
					$winpos = WinGetPos($SwtorWindowHandle)
					MouseMove(($winpos[2] / 2) + $winpos[0], ($winpos[3] / 2) + $winpos[1])
					MouseDown("primary")
					While 1
						$avPos = MouseGetPos()
						WinMove($SwtorWindowHandle, "", $avPos[0] - ($winpos[2] / 2), $avPos[1] - ($winpos[3] / 2))
						If Not _IsPressed(01) And Not _IsPressed(02) Then ExitLoop
						$winpos2 = WinGetPos($SwtorWindowHandle)
						GUICtrlSetData($Input1, $winpos2[0])
						GUICtrlSetData($Input2, $winpos2[1])
						Sleep(10)
					WEnd
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>_MoveWin

Func _CloseWin()
	If Not ($SwtorWindowHandle = 0) Then
		WinClose($SwtorWindowHandle)
	EndIf
EndFunc   ;==>_CloseWin

Func _Setup()
	Local $aRes
	Local $resolution = IniRead(@ScriptDir & "\settings.ini", "settings", "resolution", "error")
	Local $custom_res = IniRead(@ScriptDir & "\settings.ini", "settings", "custom resolution", "error")
	Local $use_custom = IniRead(@ScriptDir & "\settings.ini", "settings", "use custom resolution", "error")
	_FileReadToArray(@ScriptDir & "\resolutions.txt", $aRes)
	$Form1 = GUICreate($title, 350, 250)
	$Combo1 = GUICtrlCreateCombo("", 60, 20, 100, 50, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	For $i = 1 To $aRes[0]
		If $resolution = "error" Then
			GUICtrlSetData(-1, $aRes[$i], $aRes[1])
		Else
			GUICtrlSetData(-1, $aRes[$i], $resolution)
		EndIf
	Next
	GUICtrlCreateLabel("choose your resolution", 190, 23, 300, 50)

	_horizontalSeparator(10, 60, 330)

	$x_input = GUICtrlCreateInput("", 30, 85, 50, 20)
	GUICtrlCreateLabel("X", 91, 88, 10, 20)
	$y_input = GUICtrlCreateInput("", 110, 85, 50, 20)
	GUICtrlCreateLabel("set custom resolution", 190, 90, 100, 20)

	If Not ($custom_res = "error") Then
		$split = StringSplit($custom_res, "x")
		GUICtrlSetData($x_input, $split[1])
		GUICtrlSetData($y_input, $split[2])
	EndIf

	_horizontalSeparator(10, 125, 330)

	GUIStartGroup()
	$radio_1 = GUICtrlCreateRadio("use preset resolution", 110, 145, 200, 20)
	$radio_2 = GUICtrlCreateRadio("use custom resolution", 110, 165, 200, 20)
	GUICtrlSetState($radio_1, $GUI_CHECKED)

	If Not ($use_custom = "error") Then
		If $use_custom = 1 Then
			GUICtrlSetState($radio_2, $GUI_CHECKED)
		EndIf
	EndIf

	$ok = GUICtrlCreateButton("Save and Exit", 70, 200, 80, 25)
	$set = GUICtrlCreateButton("Set Resolution", 200, 200, 80, 25)

	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Form1)
				ExitLoop
			Case $ok
				$resolution = GUICtrlRead($Combo1)
				IniWrite(@ScriptDir & "\settings.ini", "settings", "resolution", $resolution)
				$x = GUICtrlRead($x_input)
				$y = GUICtrlRead($y_input)
				If Not ($x = "") And Not ($y = "") Then
					IniWrite(@ScriptDir & "\settings.ini", "settings", "custom resolution", $x & "x" & $y)
				EndIf
				If BitAND(GUICtrlRead($radio_1), $GUI_CHECKED) = $GUI_CHECKED Then
					IniWrite(@ScriptDir & "\settings.ini", "settings", "use custom resolution", "0")
				Else
					IniWrite(@ScriptDir & "\settings.ini", "settings", "use custom resolution", "1")
				EndIf
				GUIDelete($Form1)
				ExitLoop
			Case $set
				$resolution = GUICtrlRead($Combo1)
				IniWrite(@ScriptDir & "\settings.ini", "settings", "resolution", $resolution)
				$x = GUICtrlRead($x_input)
				$y = GUICtrlRead($y_input)
				If Not ($x = "") And Not ($y = "") Then
					IniWrite(@ScriptDir & "\settings.ini", "settings", "custom resolution", $x & "x" & $y)
				EndIf
				If BitAND(GUICtrlRead($radio_1), $GUI_CHECKED) = $GUI_CHECKED Then
					IniWrite(@ScriptDir & "\settings.ini", "settings", "use custom resolution", "0")
				Else
					IniWrite(@ScriptDir & "\settings.ini", "settings", "use custom resolution", "1")
				EndIf
				_setres()
		EndSwitch
	WEnd
EndFunc   ;==>_Setup

Func _ExitScript()
	_ShowBorders()
	Exit
EndFunc   ;==>_ExitScript

Func _CurrentWindowMode()
	$winsize = WinGetPos($SwtorWindowHandle)
	$clientsize = WinGetClientSize($SwtorWindowHandle)
	If Not IsArray($winsize) Or Not IsArray($clientsize) Then
		Return (0)
	EndIf

	If $clientsize[0] = 0 And $clientsize[1] = 0 Then
		Return ("minimized")
	EndIf
	If $clientsize[0] = $winsize[2] And $clientsize[1] = $winsize[3] Then
		Return ("fullscreen")
	EndIf

	If $clientsize[0] < ($winsize[2] - 2) And $clientsize[1] < ($winsize[3] - 2) Then
		Return ("borders")
	EndIf

	If Not ($clientsize[0] < ($winsize[2] - 2)) And Not ($clientsize[1] < ($winsize[3] - 2)) Then
		Return ("borderless")
	EndIf
EndFunc   ;==>_CurrentWindowMode

Func _WinSetStyle($hwnd, $Style = -1, $ExStyle = 0)
	;thanks to "boltc" for this
	Local Const $GWL_STYLE = -16
	Local Const $GWL_EXSTYLE = -20
	Local Const $SWP_NOMOVE = 0x2
	Local Const $SWP_NOSIZE = 0x1
	Local Const $SWP_SHOWWINDOW = 0x40
	Local Const $SWP_NOZORDER = 0x4
	Local $iFlags = BitOR($SWP_SHOWWINDOW, $SWP_NOSIZE, $SWP_NOMOVE, $SWP_NOZORDER)
	If $Style = -1 Then $Style = $WS_MINIMIZEBOX + $WS_CAPTION + $WS_POPUP + $WS_SYSMENU
	DllCall("User32.dll", "int", "SetWindowLong", "hwnd", $hwnd, "int", $GWL_STYLE, "int", $Style)
	DllCall("User32.dll", "int", "SetWindowLong", "hwnd", $hwnd, "int", $GWL_EXSTYLE, "int", $ExStyle)
	DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hwnd, "hwnd", 0, "int", 0, "int", 0, _
			"int", 0, "int", 0, "int", $iFlags)
EndFunc   ;==>_WinSetStyle

Func _WinSetClientAreaSize($hwnd, $x, $y)
	Local $x_orig = 0, $y_orig = 0
	If IniRead(@ScriptDir & "\settings.ini", "settings", "reposition window", "error") = 1 Then
		$pos = IniRead(@ScriptDir & "\settings.ini", "settings", "window position", "error")
		If Not ($pos = "error") Then
			$split = StringSplit($pos, "x")
			$x_orig = $split[1]
			$y_orig = $split[2]
		EndIf
	EndIf
	$winsize = WinGetPos($hwnd)
	$clientsize = WinGetClientSize($hwnd)
	$x_borders = $winsize[2] - $clientsize[0]
	$y_borders = $winsize[3] - $clientsize[1]
	WinMove($hwnd, "", $x_orig, $y_orig, $x + $x_borders, $y + $y_borders)
EndFunc   ;==>_WinSetClientAreaSize

Func _horizontalSeparator($x, $y, $w)
	GUICtrlCreateLabel("", $x, $y, $w, 1)
	GUICtrlSetBkColor(-1, 0xd5dfe5)
	GUICtrlCreateLabel("", $x, $y + 1, $w, 1)
	GUICtrlSetBkColor(-1, 0xffffff)
EndFunc   ;==>_horizontalSeparator

Func _verify_resolutions_file()
	If Not FileExists(@ScriptDir & "\resolutions.txt") Then
		$file = FileOpen(@ScriptDir & "\resolutions.txt", 2)
		FileWriteLine($file, "800x600")
		FileWriteLine($file, "1024x768")
		FileWriteLine($file, "1280x720")
		FileWriteLine($file, "1280x768")
		FileWriteLine($file, "1280x800")
		FileWriteLine($file, "1280x960")
		FileWriteLine($file, "1280x1024")
		FileWriteLine($file, "1360x768")
		FileWriteLine($file, "1360x1024")
		FileWriteLine($file, "1366x768")
		FileWriteLine($file, "1400x1050")
		FileWriteLine($file, "1440x900")
		FileWriteLine($file, "1600x900")
		FileWriteLine($file, "1600x1200")
		FileWriteLine($file, "1680x1050")
		FileWriteLine($file, "1920x1080")
		FileWriteLine($file, "1920x1200")
		FileClose($file)
	EndIf
EndFunc   ;==>_verify_resolutions_file