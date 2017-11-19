#RequireAdmin
#NoTrayIcon
#include <NomadMemory.au3>
;~ HotKeySet(_iniRead("hotkey"), "quit")
HotKeySet("{esc}", "quit")
Global Const $sIniName = @ScriptDir & '\settings.ini'
Global Const $sGameDll = "game.dll"
Global Const $sSprintKey = _iniRead("sprintKey")
Global Const $hAddresses[3] = [_iniRead("a1"), _iniRead("a2"), _iniRead("a3")]
Global Const $hAddress = _iniRead("a4")
Global Const $iDeelay = _iniRead("deelay")
Global Const $sTitle = _iniRead("title")
Global Const $hMemory = _MemoryOpen(ProcessExists($sGameDll))
Global Const $iPID = WinGetProcess($sTitle)

If $hMemory = 0 Or $iPID = 0 Then quit()
If Not IsArray($hMemory) Then quit()

While True
	$text = _MemoryRead($hAddress, $hMemory)
	ToolTip("END=" & $text)
	If WinGetTitle(WinGetHandle("")) = $sTitle Then
		If _MemoryRead($hAddresses[0], $hMemory) = 0 _
		Or _MemoryRead($hAddresses[1], $hMemory) = 0 _
		Or _MemoryRead($hAddresses[2], $hMemory) = 0 Then
			Send($sSprintKey)
		EndIf
	EndIf
	Sleep($iDeelay)
;~ 	ConsoleWrite(_MemoryRead($hAddresses[0], $hMemory)&@CRLF)
WEnd

quit()

Func quit()
	_MemoryClose($hMemory)
	Exit
EndFunc

Func _iniRead($sKey)
	Return IniRead($sIniName, "main", $sKey, "")
EndFunc
#cs
Func _WinAPI_GetCommandLineFromPID($iPID)
    Local $aCall = DllCall("kernel32.dll", "handle", "OpenProcess", _
            "dword", 1040, _ ; PROCESS_VM_READ | PROCESS_QUERY_INFORMATION
            "bool", 0, _
            "dword", $iPID)
    If @error Or Not $aCall[0] Then
        Return SetError(1, 0, "")
    EndIf

    Local $hProcess = $aCall[0]

    Local $tPROCESS_BASIC_INFORMATION = DllStructCreate("dword_ptr ExitStatus;" & _
            "ptr PebBaseAddress;" & _
            "dword_ptr AffinityMask;" & _
            "dword_ptr BasePriority;" & _
            "dword_ptr UniqueProcessId;" & _
            "dword_ptr InheritedFromUniqueProcessId")

    $aCall = DllCall("ntdll.dll", "int", "NtQueryInformationProcess", _
            "handle", $hProcess, _
            "dword", 0, _ ; ProcessBasicInformation
            "ptr", DllStructGetPtr($tPROCESS_BASIC_INFORMATION), _
            "dword", DllStructGetSize($tPROCESS_BASIC_INFORMATION), _
            "dword*", 0)

    If @error Then
        DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
        Return SetError(2, 0, "")
    EndIf

    Local $tPEB = DllStructCreate("byte InheritedAddressSpace;" & _
            "byte ReadImageFileExecOptions;" & _
            "byte BeingDebugged;" & _
            "byte Spare;" & _
            "ptr Mutant;" & _
            "ptr ImageBaseAddress;" & _
            "ptr LoaderData;" & _
            "ptr ProcessParameters;" & _
            "ptr SubSystemData;" & _
            "ptr ProcessHeap;" & _
            "ptr FastPebLock;" & _
            "ptr FastPebLockRoutine;" & _
            "ptr FastPebUnlockRoutine;" & _
            "dword EnvironmentUpdateCount;" & _
            "ptr KernelCallbackTable;" & _
            "ptr EventLogSection;" & _
            "ptr EventLog;" & _
            "ptr FreeList;" & _
            "dword TlsExpansionCounter;" & _
            "ptr TlsBitmap;" & _
            "dword TlsBitmapBits[2];" & _
            "ptr ReadOnlySharedMemoryBase;" & _
            "ptr ReadOnlySharedMemoryHeap;" & _
            "ptr ReadOnlyStaticServerData;" & _
            "ptr AnsiCodePageData;" & _
            "ptr OemCodePageData;" & _
            "ptr UnicodeCaseTableData;" & _
            "dword NumberOfProcessors;" & _
            "dword NtGlobalFlag;" & _
            "ubyte Spare2[4];" & _
            "int64 CriticalSectionTimeout;" & _
            "dword HeapSegmentReserve;" & _
            "dword HeapSegmentCommit;" & _
            "dword HeapDeCommitTotalFreeThreshold;" & _
            "dword HeapDeCommitFreeBlockThreshold;" & _
            "dword NumberOfHeaps;" & _
            "dword MaximumNumberOfHeaps;" & _
            "ptr ProcessHeaps;" & _
            "ptr GdiSharedHandleTable;" & _
            "ptr ProcessStarterHelper;" & _
            "ptr GdiDCAttributeList;" & _
            "ptr LoaderLock;" & _
            "dword OSMajorVersion;" & _
            "dword OSMinorVersion;" & _
            "dword OSBuildNumber;" & _
            "dword OSPlatformId;" & _
            "dword ImageSubSystem;" & _
            "dword ImageSubSystemMajorVersion;" & _
            "dword ImageSubSystemMinorVersion;" & _
            "dword GdiHandleBuffer[34];" & _
            "dword PostProcessInitRoutine;" & _
            "dword TlsExpansionBitmap;" & _
            "byte TlsExpansionBitmapBits[128];" & _
            "dword SessionId")

    $aCall = DllCall("kernel32.dll", "bool", "ReadProcessMemory", _
            "ptr", $hProcess, _
            "ptr", DllStructGetData($tPROCESS_BASIC_INFORMATION, "PebBaseAddress"), _
            "ptr", DllStructGetPtr($tPEB), _
            "dword", DllStructGetSize($tPEB), _
            "dword*", 0)

    If @error Or Not $aCall[0] Then
        DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
        Return SetError(3, 0, "")
    EndIf

    Local $tPROCESS_PARAMETERS = DllStructCreate("dword AllocationSize;" & _
            "dword ActualSize;" & _
            "dword Flags;" & _
            "dword Unknown1;" & _
            "word LengthUnknown2;" & _
            "word MaxLengthUnknown2;" & _
            "ptr Unknown2;" & _
            "handle InputHandle;" & _
            "handle OutputHandle;" & _
            "handle ErrorHandle;" & _
            "word LengthCurrentDirectory;" & _
            "word MaxLengthCurrentDirectory;" & _
            "ptr CurrentDirectory;" & _
            "handle CurrentDirectoryHandle;" & _
            "word LengthSearchPaths;" & _
            "word MaxLengthSearchPaths;" & _
            "ptr SearchPaths;" & _
            "word LengthApplicationName;" & _
            "word MaxLengthApplicationName;" & _
            "ptr ApplicationName;" & _
            "word LengthCommandLine;" & _
            "word MaxLengthCommandLine;" & _
            "ptr CommandLine;" & _
            "ptr EnvironmentBlock;" & _
            "dword Unknown[9];" & _
            "word LengthUnknown3;" & _
            "word MaxLengthUnknown3;" & _
            "ptr Unknown3;" & _
            "word LengthUnknown4;" & _
            "word MaxLengthUnknown4;" & _
            "ptr Unknown4;" & _
            "word LengthUnknown5;" & _
            "word MaxLengthUnknown5;" & _
            "ptr Unknown5;")

    $aCall = DllCall("kernel32.dll", "bool", "ReadProcessMemory", _
            "ptr", $hProcess, _
            "ptr", DllStructGetData($tPEB, "ProcessParameters"), _
            "ptr", DllStructGetPtr($tPROCESS_PARAMETERS), _
            "dword", DllStructGetSize($tPROCESS_PARAMETERS), _
            "dword*", 0)

    If @error Or Not $aCall[0] Then
        DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
        Return SetError(4, 0, "")
    EndIf

    $aCall = DllCall("kernel32.dll", "bool", "ReadProcessMemory", _
            "ptr", $hProcess, _
            "ptr", DllStructGetData($tPROCESS_PARAMETERS, "CommandLine"), _
            "wstr", "", _
            "dword", DllStructGetData($tPROCESS_PARAMETERS, "MaxLengthCommandLine"), _
            "dword*", 0)

    If @error Or Not $aCall[0] Then
        DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
        Return SetError(5, 0, "")
    EndIf

    DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)

    Return $aCall[3]

EndFunc
#ce