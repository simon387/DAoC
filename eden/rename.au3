

# da eseguire con scite come admin


#NoTrayIcon
#include <MsgBoxConstants.au3>

Local $sWindowTitle = "Dark Age of Camelot © 2001-2021 Electronic Arts Inc. All Rights Reserved."
Local $sNewTitle = "workaround"

Local $hWnd = WinGetHandle($sWindowTitle)

If @error Then
    MsgBox($MB_ICONERROR, "Error", "Window not found!")
    Exit
EndIf

WinSetTitle($hWnd, "", $sNewTitle)

MsgBox($MB_ICONINFORMATION, "Success", "Window title changed successfully!")
