;#NoTrayIcon
#include <Misc.au3>

;~ premo f3 deve fare:
;~ x
;~ 1
;~ 2

;~ poi ad ogni f3 solo 
;~ 1
;~ 2

;~ premo f4 deve fare 
;~ y
;~ 3
;~ 4

;~ poi ad ogni f4 solo 
;~ 3
;~ 4

Local $hDLL = DllOpen("user32.dll")
Local $f3 = "72"
Local $f4 = "73"
Local $isFirstF3 = True
Local $isFirstF4 = True
Local $deelay = 50

While True
	If _IsPressed($f3, $hDLL) Then
		If $isFirstF3 Then
			sendAndWait("x")
		EndIf
		sendAndWait("1")
		sendAndWait("2")
		$isFirstF3 = False
		$isFirstF4 = True
	EndIf
	If _IsPressed($f4, $hDLL) Then
		If $isFirstF4 Then
			sendAndWait("y")
		EndIf
		sendAndWait("3")
		sendAndWait("4")
		$isFirstF3 = True
		$isFirstF4 = False
	EndIf
	Sleep($deelay)
WEnd

DllClose($hDLL)

Func quit()
	Exit
EndFunc

Func sendAndWait($key)
	Send($key)
	Sleep($deelay)
EndFunc
