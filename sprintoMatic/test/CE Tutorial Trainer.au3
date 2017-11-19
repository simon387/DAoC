#RequireAdmin ;User Account must have Administrator privlidges
#include <NomadMemory.au3> ;Include the NomadMemory functions in this script
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $hMemory ;A global variable

#Region ### START Koda GUI section ###
$hGUI = GUICreate("CE Tutorial Trainer", 259, 75, 192, 124)
$hAttach = GUICtrlCreateButton("Attach", 8, 8, 75, 25, $WS_GROUP)
$hDetach = GUICtrlCreateButton("Detach", 88, 8, 83, 25, $WS_GROUP)
GUICtrlSetState($hDetach, $GUI_DISABLE)
$hStep2 = GUICtrlCreateButton("Patch Step2", 8, 40, 243, 25, $WS_GROUP)
$hQuit = GUICtrlCreateButton("Quit", 176, 8, 75, 25, $WS_GROUP)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
   Switch GUIGetMsg()
      Case $hAttach
         $hMemory = _MemoryOpen(ProcessExists("tutorial.exe"))
         GUICtrlSetState($hDetach,$GUI_ENABLE)
         GUICtrlSetState($hAttach,$GUI_DISABLE)
      Case $hDetach
         _MemoryClose($hMemory)
         GUICtrlSetState($hAttach,$GUI_ENABLE)
         GUICtrlSetState($hDetach,$GUI_DISABLE)
      Case $hStep2
         _PatchStep2()
      Case $hQuit
         Exit
      Case $GUI_EVENT_CLOSE
         Exit
   EndSwitch
WEnd

Func _PatchStep2()
   Local $Offset[2] = [0, Dec(314)]

   ;Get Base Address
   $BaseAddress = _MemoryGetBaseAddress($hMemory, 1)
   If $BaseAddress = 0 Then
      Select
         Case @error = 1
            MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Invalid handle to open process")
         Case @error = 2
            MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to find correct allocation address")
         Case @error = 3
            MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to read from the specified process")
      EndSelect
   EndIf

   ;Calculate and Write
   $StaticOffset = Dec("460C54") - $BaseAddress
   $FinalAddress = "0x" & Hex($BaseAddress + $StaticOffset)
   $Write = _MemoryPointerWrite($FinalAddress, $hMemory, $Offset, "1000")
EndFunc