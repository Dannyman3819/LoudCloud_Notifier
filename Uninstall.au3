#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=LCN.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>

#RequireAdmin

$UninstallDir = ""

UninstallGUI()

Func UninstallGUI()
	$msgboxUninstall = MsgBox( 4, "LoudCloud Notifier", "Are you sure you want to uninstall?")
	if $msgboxuninstall = 7 Then Exit
	GUICreate("Uninstaller", 400, 340)
	GUISetIcon("LCN.ico")
	Global $UninstallDir1 = GUICtrlCreateInput(@ProgramFilesDir & "\LoudCloud Notifier\", 20, 140, 300, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlCreateLabel("Uninstallation Directory", 0, 40, 400, "", $SS_CENTER)
	GUICtrlSetFont(-1, 13)
	$BrowseButton = GUICtrlCreateButton("Browse", 330, 140, 50, 21)
	$UninstallButton = GUICtrlCreateButton("Uninstall", 238, 313, 80)
	GUICtrlSetState(-1, $GUI_FOCUS)
	$CancelButton = GUICtrlCreateButton("Cancel", 319, 313, 80)
	GUICtrlCreateLabel("Choose where you installed LCN...", 120, 110)

	GUISetState()

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case -3
				Exit

			Case $BrowseButton
				$Dir = FileSelectFolder("Choose the Uninstallation Directory...","", 5, @DesktopDir)
				GUICtrlSetData($UninstallDir1, $Dir)
			Case $CancelButton
				$verify = MsgBox(36, "Cancel Uninstallation", "Are you sure you want to cancel the Uninstallation?")
				If $verify = 6 Then Exit
			Case $UninstallButton
				If GUICtrlRead($UninstallDir1) = "" Then
					MsgBox(16, "Error!", "Choose an Uninstallation Directory!")
				Else
					$UinstallDir = GUICtrlRead($UninstallDir1)
					;MsgBox(1, "", $vCheckBox1)
					UninstallFiles()
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>InstallDir

Func UninstallFiles()
	if not FileExists( $UninstallDir & "LCN_Main.exe" ) Then
		MsgBox( 0, "Error", "Files not found in chosen directory!")
		UninstallGUI()
	EndIf
	GUIDelete()
	;AutoItSetOption("GUIOnEventMode", 1)
	GUICreate("Uninstaller", 400, 340)
	GUISetIcon("LCN.ico")
	GUICtrlCreateLabel("Uninstallation in Progress", 0, 80, 400, 30, $SS_CENTER)
	GUICtrlSetFont(-1, 12)
	$Progress = GUICtrlCreateProgress(10, 120, 380, 30, $PBS_SMOOTH)
	$lProgress = GUICtrlCreateInput("", 15, 160, 370, 18, BitOR($SS_CENTER, $ES_READONLY))
	$CancelButton = GUICtrlCreateButton("Cancel", 320, 313, 80)
	;GUICtrlSetOnEvent($CancelButton, "_CancelUninstallation")
	GUISetState()

	;MsgBox(0, "", $InstallDir)
	GUICtrlSetData( $Progress, 20)
	GUICtrlSetData( $lProgress, "Deleting shortcuts" )
	FileDelete( @StartupCommonDir & "\LoudCloud Notifier" )
	FileDelete( @DesktopCommonDir & "\LoudCloud Notifier" )
	GUICtrlSetData( $Progress, 60)
	GUICtrlSetData( $lProgress, "Deleting Files" )
	DirRemove( $UninstallDir, 1)
	GUICtrlSetData( $Progress, 80)
	sleep(500)
	GUICtrlSetData( $Progress, 100)
	GUICtrlSetData( $lProgress, "Done" )
	sleep(500)
    ;AutoItSetOption("GUIOnEventMode", 0)
	GUIDelete()
	UninstallationComplete()
EndFunc   ;==>InstallFiles

Func UninstallationComplete()

	GUIDelete()
	GUICreate("Uninstallation Complete", 400, 200)
	GUISetIcon("LCN.ico")
	GUICtrlCreateLabel("Thank You for Trying my Software", 0, 50, 400, 30, $SS_CENTER)
	GUICtrlSetFont(-1, 13)
	GUICtrlCreateLabel("The Files have Been Uninstalled Successfully!" & @CRLF & "Press Finish to complete the Uninstallation", 0, 80, 400, 40, $SS_CENTER)
	GUICtrlSetFont(-1, 10)

	$ExitButton = GUICtrlCreateButton("Finish", 318, 173, 80)
	GUICtrlSetState(-1, $GUI_FOCUS)

	GUISetState()

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case -3
				Exit
			Case $ExitButton
				Exit
		EndSwitch
	WEnd
EndFunc   ;==>UninstallationComplete

