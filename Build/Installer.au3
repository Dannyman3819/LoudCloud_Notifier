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

$vCheckBox1 = ""
$vCheckBox2 = ""
$vCheckBox3 = ""
$InstallDir = ""

InstallerGUI()
;TermsAndConditions()
;InstallDir()
;InstallFiles()
;InstallationComplete()

Func InstallerGUI()

	If _Singleton("installer", 1) = 0 Then
		MsgBox(0, "Error!", "The Installer is Already Running. This Will now Exit.")
		Exit
	EndIf

	GUICreate("Installer", 400, 340)
	GUISetIcon("LCN.ico")
	;GUICtrlCreatePic("image.jpg", 10, 10, 100, 320)
	GUICtrlCreateLabel("Welcome! Press next to begin installation", 0, 80, 400, 30, $SS_CENTER)
	GUICtrlSetFont(-1, 12, 400, 0, "Arial Black")
	GUICtrlCreateLabel("This Installs LoudCloud Notifier." & @CRLF & @CRLF & "If you have questions, comments or concerns email me at DanielBlevinsLCN at Gmail.com", 0, 150, 400, 100,$SS_CENTER)
	GUICtrlSetFont(-1, 12, 400, 0, "Arial")
	$NextButton = GUICtrlCreateButton("Next", 240, 313, 80)
	GUICtrlSetState(-1, $GUI_FOCUS)
	$CancelButton = GUICtrlCreateButton("Cancel", 320, 313, 80)

	GUISetState()

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case -3
				Exit
			Case $NextButton
				TermsAndConditions()
			Case $CancelButton
				$verify = MsgBox(36, "Cancel Installation", "Are you sure you want to cancel the installation?")
				If $verify = 6 Then Exit
		EndSwitch
	WEnd
EndFunc   ;==>InstallerGUI

Func TermsAndConditions()

	GUIDelete()
	GUICreate("Installer", 410, 340)
	GUISetIcon("LCN.ico")
	$TermsBox = GUICtrlCreateEdit("Test", 10, 40, 390, 200, BitOR($ES_READONLY, $WS_VSCROLL))
	GUICtrlCreateLabel("Terms and Conditions", 10, 8, 200)
	GUICtrlSetFont(-1, 15)
	GUICtrlCreateLabel("Do you Agree to the Terms and Conditions?", 20, 260)
	$Agree = GUICtrlCreateRadio("I Agree", 20, 280)
	GUICtrlSetState(-1, $GUI_FOCUS)
	$Disagree = GUICtrlCreateRadio("I Disagree", 90, 280)
	$NextButton = GUICtrlCreateButton("Next", 240, 313, 80)
	GUICtrlSetState($NextButton, $GUI_DISABLE)
	GUICtrlSetState($Disagree, $GUI_CHECKED)
	$CancelButton = GUICtrlCreateButton("Cancel", 320, 313, 80)


	FileInstall( "LICENSE", "LICENSE" )
	$TermsFileHandle = FileOpen( "LICENSE" )
	$count = 1
	$while = 1
	$Terms1 = ""
	while $while
		$Terms = FileReadLine( $TermsFileHandle, $count )
		$Terms1 &= $Terms & @CRLF
		if @error Then $while = 0
		$count = $count + 1
	WEnd
	GUICtrlSetData( $TermsBox, $Terms1 )
	FileClose( $TermsFileHandle )

	GUISetState()

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case -3
				Exit
			Case $Disagree
				GUICtrlSetState($NextButton, $GUI_DISABLE)
			Case $Agree
				GUICtrlSetState($NextButton, $GUI_ENABLE)
			Case $NextButton
				InstallDir()
			Case $CancelButton
				$verify = MsgBox(36, "Cancel Installation", "Are you sure you want to cancel the installation?")
				If $verify = 6 Then Exit
		EndSwitch
	WEnd
EndFunc   ;==>TermsAndConditions

Func InstallDir()

	GUIDelete()
	GUICreate("Installer", 400, 340)
	GUISetIcon("LCN.ico")
	Global $InstallDir1 = GUICtrlCreateInput(@ProgramFilesDir & "\LoudCloud Notifier\", 20, 140, 300, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlCreateLabel("Installation Directory", 0, 40, 400, "", $SS_CENTER)
	GUICtrlSetFont(-1, 13)
	$BrowseButton = GUICtrlCreateButton("Browse", 330, 140, 50, 21)
	$InstallButton = GUICtrlCreateButton("Install", 238, 313, 80)
	GUICtrlSetState(-1, $GUI_FOCUS)
	$CancelButton = GUICtrlCreateButton("Cancel", 319, 313, 80)
	GUICtrlCreateLabel("Choose Where to Install the Files to...", 120, 110)
	$CheckBox1 = GUICtrlCreateCheckbox( "Run at Startup?", 50, 200)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$vCheckBox1 = 1
	$CheckBox2 =GUICtrlCreateCheckbox( "Desktop Shortcut?", 50, 220)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$vCheckBox2 = 1
	$CheckBox3 =GUICtrlCreateCheckbox( "Run Setup after installation finishes?", 50, 240)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$vCheckBox3 = 1

	GUISetState()

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case -3
				Exit
			Case $CheckBox1
				$vCheckBox1 = GUICtrlRead($CheckBox1)
				;MsgBox(0,"",$vCheckBox1)
			Case $CheckBox2
				$vCheckBox2 = GUICtrlRead($CheckBox2)
				;MsgBox(0,"",$vCheckBox2)
			Case $CheckBox3
				$vCheckBox3 = GUICtrlRead($CheckBox3)
				;MsgBox(0,"",$vCheckBox3)
			Case $BrowseButton
				$Dir = FileSelectFolder("Choose the Installation Directory...","", 5, @DesktopDir)
				GUICtrlSetData($InstallDir1, $Dir)
			Case $CancelButton
				$verify = MsgBox(36, "Cancel Installation", "Are you sure you want to cancel the installation?")
				If $verify = 6 Then Exit
			Case $InstallButton
				If GUICtrlRead($InstallDir1) = "" Then
					MsgBox(16, "Error!", "Choose an Installation Directory!")
				Else
					$InstallDir = GUICtrlRead($InstallDir1)
					;MsgBox(1, "", $vCheckBox1)
					InstallFiles()
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>InstallDir

Func InstallFiles()
	GUIDelete()
	AutoItSetOption("GUIOnEventMode", 1)
	GUICreate("Installer", 400, 340)
	GUISetIcon("LCN.ico")
	GUICtrlCreateLabel("Installation in Progress", 0, 80, 400, 30, $SS_CENTER)
	GUICtrlSetFont(-1, 12)
	$Progress = GUICtrlCreateProgress(10, 120, 380, 30, $PBS_SMOOTH)
	$lProgress = GUICtrlCreateInput("", 15, 160, 370, 18, BitOR($SS_CENTER, $ES_READONLY))
	$CancelButton = GUICtrlCreateButton("Cancel", 320, 313, 80)
	GUICtrlSetOnEvent($CancelButton, "_CancelInstallation")
	GUISetState()

	;MsgBox(0, "", $InstallDir)
	GUICtrlSetData( $Progress, 10)
	GUICtrlSetData( $lProgress, "Coping into Installation Directory" )
	;ShellExecute(@WindowsDir&"\System32\cmd.exe", 'rmdir /Q /S "'&$InstallDir&'"',"","runas")
	;ShellExecute(@WindowsDir&"\System32\cmd.exe", 'mkdir "'&$InstallDir&'"',"","runas")
	DirRemove($InstallDir)
	DirCreate($InstallDir)

	DirCreate($InstallDir&"Temp\")
	DirCreate(@AppDataDir&"\LoudCloud_Notifier\")
	FileInstall( "Build.zip",$InstallDir )
	GUICtrlSetData( $Progress, 20)
	GUICtrlSetData( $lProgress, "Coping into Installation Directory" )
	FileInstall ( "7z.exe", $InstallDir )
	GUICtrlSetData( $Progress, 40)
	GUICtrlSetData( $lProgress, "Extracting" )

	ShellExecuteWait( $InstallDir & "7z.exe", 'x "'&$InstallDir&'Build.zip" -y -o"' & $InstallDir & '"', "", "");, @SW_HIDE )
	GUICtrlSetData( $Progress, 75)
	GUICtrlSetData( $lProgress, "Cleaning" )
	FileDelete( $InstallDir & "Build.zip" )
	FileDelete ( $InstallDir & "7z.exe" )
	GUICtrlSetData( $Progress, 90)
	GUICtrlSetData( $lProgress, "Making Shortcuts" )

	if $vCheckBox1 = 1 Then FileCreateShortcut( $InstallDir & "LCN_Main.exe", @StartupCommonDir & "\LoudCloud Notifier" )
	if $vCheckBox2 = 1 Then FileCreateShortcut( $InstallDir & "LCN_Main.exe", @DesktopCommonDir & "\LoudCloud Notifier" )
	GUICtrlSetData( $Progress, 100)
	GUICtrlSetData( $lProgress, "Done" )
	sleep(500)
	AutoItSetOption("GUIOnEventMode", 0)
	GUIDelete()
	InstallationComplete()
EndFunc   ;==>InstallFiles

Func InstallationComplete()

	GUIDelete()
	GUICreate("Installation Complete", 400, 200)
	GUISetIcon("LCN.ico")
	GUICtrlCreateLabel("Thank You for Installing", 0, 50, 400, 30, $SS_CENTER)
	GUICtrlSetFont(-1, 13)
	GUICtrlCreateLabel("The Files have Been Installed Successfully!" & @CRLF & "Press Finish to complete the installation", 0, 80, 400, 40, $SS_CENTER)
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
				If $vCheckBox3 = 1 Then ShellExecute( $InstallDir & "LCN_Gui.exe", "", "", "", @SW_HIDE)
				Exit
		EndSwitch
	WEnd
EndFunc   ;==>InstallationComplete

Func _CancelInstallation()
	$verify = MsgBox(36, "Cancel Installation", "Are You Sure You Want to Cancel the Installation?")
	If $verify = 6 Then Exit
EndFunc   ;==>_CancelInstallation
