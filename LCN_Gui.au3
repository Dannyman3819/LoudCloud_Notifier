#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <Crypt.au3>
#Include "Include\AES.au3"

;sets all settings off
$V_cOn = 0
;~ $V_cOff = 1
$V_eOn = 0
;~ $V_eOff = 1
;~ $V_pOn = 0
;~ $V_pOff = 1
$V_Ln_aOn = 0
;~ $V_Ln_aOff = 1
;~ $V_Ln_f_mOn = 0
;~ $V_Ln_f_mOff = 1
;~ $V_LN_f_iOn = 0
;~ $V_LN_f_iOff = 1
;~ $V_OK = 0
;~ $V_CANCEL = 0
;~ $V_ABOUT = 0

$sUsername = ""
$sPassword = ""
$sFrequency = ""
$s_cOn = ""
$s_eOn = ""
$s_Ln_aOn = ""

$aPassword = ""
$aUsername = ""
$aFrequency = ""

$random = Random(5, 20, 1) ;create a random number to encrypt password & usernam
;$random = "12345"

;if a config file is found it will overwrite above settings
load() ;loads LCN.conf
;radiobutons(); changes settings of radio buttons into TRUE and FALSE


#region ### START Koda GUI section ### Form=c:\users\daniel\desktop\scripts_stuff\batch\curl\testing_folder\autoit\lcn setup.kxf
$LCN_Setup = GUICreate("LoudCloud Notifier", 651, 401, 246, 130)
$PageControl1 = GUICtrlCreateTab(8, 8, 636, 352)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")

$TabSheet1 = GUICtrlCreateTabItem(" LoudCloud Settings")
$UserName = GUICtrlCreateInput($sUsername, 16, 66, 209, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_Username = GUICtrlCreateLabel("UserName:", 16, 42, 69, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Password = GUICtrlCreateInput($sPassword, 16, 130, 209, 24, BitOR($GUI_SS_DEFAULT_INPUT, $ES_PASSWORD))
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_Password = GUICtrlCreateLabel("Password:", 16, 106, 65, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_Frequency = GUICtrlCreateLabel("Check Frequency", 16, 178, 106, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Frequecy = GUICtrlCreateInput($sFrequency, 16, 202, 33, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_Min = GUICtrlCreateLabel("Min.", 56, 210, 23, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")

$TabSheet2 = GUICtrlCreateTabItem("Notificaiton")
$Label1 = GUICtrlCreateLabel("This program can notifiy you using a popup on your computer, emailing it to you, or even have it text you!", 16, 42, 608, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$cGroup = GUICtrlCreateGroup("", 16, 58, 609, 97)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_cComputer = GUICtrlCreateLabel("Computer:", 24, 74, 64, 20)
$cOn = GUICtrlCreateRadio("On", 32, 98, 41, 17)
$cOff = GUICtrlCreateRadio("Off", 80, 98, 41, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$eGroup = GUICtrlCreateGroup("", 16, 154, 609, 97)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_eEmail = GUICtrlCreateLabel("Email:", 24, 170, 41, 20)
$eOn = GUICtrlCreateRadio("On", 32, 194, 41, 17)
$eOff = GUICtrlCreateRadio("Off", 80, 194, 41, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$pGroup = GUICtrlCreateGroup("", 16, 250, 609, 89)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_pPhone = GUICtrlCreateLabel("Phone Texting: (WIP)", 24, 266, 128, 20)
$pOn = GUICtrlCreateRadio("On", 32, 290, 41, 17)
GUICtrlSetState(-1, $GUI_HIDE)
$pOff = GUICtrlCreateRadio("Off", 80, 290, 41, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_HIDE)
$L_pNumber = GUICtrlCreateLabel("Phone Number:", 168, 266, 94, 20)
GUICtrlSetState(-1, $GUI_HIDE)
$pNumber = GUICtrlCreateInput("", 176, 290, 121, 24, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$TabSheet3 = GUICtrlCreateTabItem("LoudCloud Notifications")
GUICtrlSetState(-1, $GUI_SHOW)
$Label2 = GUICtrlCreateLabel("Pick what you wan to be notified for:", 16, 40, 213, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")

GUIStartGroup()
$L_aAnnouncments = GUICtrlCreateLabel("Announcements:", 24, 72, 102, 20)
$Ln_aOn = GUICtrlCreateRadio("On", 32, 96, 41, 17)
$Ln_aOff = GUICtrlCreateRadio("Off", 80, 96, 41, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
GUIStartGroup()
$Label4 = GUICtrlCreateLabel("Forum:", 24, 128, 45, 20)
$Label3 = GUICtrlCreateLabel("Main Forum: (WIP)", 32, 152, 114, 20)
$Ln_f_mOn = GUICtrlCreateRadio("On", 40, 176, 41, 17)
GUICtrlSetState(-1, $GUI_HIDE)
$Ln_f_mOff = GUICtrlCreateRadio("Off", 80, 176, 41, 17, BitOR($BS_RADIOBUTTON, $WS_GROUP))
GUICtrlSetState(-1, $GUI_HIDE)
GUIStartGroup()
$Label5 = GUICtrlCreateLabel("Individual Forum: (WIP)", 32, 200, 138, 20)
$LN_f_iOn = GUICtrlCreateRadio("On", 40, 224, 41, 17, $BS_RADIOBUTTON)
GUICtrlSetState(-1, $GUI_HIDE)
$LN_f_iOff = GUICtrlCreateRadio("Off", 80, 224, 41, 17, $BS_RADIOBUTTON)
GUICtrlSetState(-1, $GUI_HIDE)
GUIStartGroup()
GUIStartGroup()
GUIStartGroup()
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
$OK = GUICtrlCreateButton("&OK", 406, 368, 75, 25)
$CANCEL = GUICtrlCreateButton("&Cancel", 486, 368, 75, 25)
$ABOUT = GUICtrlCreateButton("&About", 568, 368, 75, 25)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

radiobutons()

While 1
	Sleep(10)
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $cOn
			$V_cOn = 1
			$V_cOff = 0
		Case $cOff
			$V_cOff = 1
			$V_cOn = 0
		Case $eOn
			$V_eOn = 1
			$V_eOff = 0
		Case $eOff
			$V_eOff = 1
			$V_eOn = 0
		Case $pOn
			$V_pOn = 1
			$V_pOff = 0
		Case $pOff
			$V_pOff = 1
			$V_pOn = 0
		Case $Ln_aOn
			$V_Ln_aOn = 1
			$V_Ln_aOff = 0
		Case $Ln_aOff
			$V_Ln_aOff = 1
			$V_Ln_aOn = 0
		Case $Ln_f_mOn
			$V_Ln_f_mOn = 1
			$V_Ln_f_mOff = 0
		Case $Ln_f_mOff
			$V_Ln_f_mOff = 1
			$V_Ln_f_mOn = 0
		Case $LN_f_iOn
			$V_LN_f_iOn = 1
			$V_LN_f_iOff = 0
		Case $LN_f_iOff
			$V_LN_f_iOff = 1
			$V_LN_f_iOn = 0
;~ 		Case $Password
;~ 			$aPassword = $nMsg
;~ 		Case $UserName
;~ 			$aUsername = $nMsg
		Case $OK
			$V_OK = 1
			save()
			Exit
		Case $CANCEL
			$V_CANCEL = 1
			Exit
		Case $ABOUT
			$V_ABOUT = 1
			showAbout()
	EndSwitch
WEnd


Func showAbout()
	#include <ButtonConstants.au3>
	#include <GUIConstantsEx.au3>
	#include <StaticConstants.au3>
	#include <WindowsConstants.au3>
	#region ### START Koda GUI section ### Form=c:\users\daniel\desktop\scripts_stuff\batch\curl\testing_folder\autoit\about.kxf
	$Form1_1 = GUICreate("About", 323, 240, 417, 208)
	$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 305, 185)
	$Label1 = GUICtrlCreateLabel("LoudCloud Notifier (LCN)", 80, 24, 151, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$Label2 = GUICtrlCreateLabel("Version: OMG", 232, 56, 70, 17)
	$Label3 = GUICtrlCreateLabel("Created By: Daniel Blevins", 16, 56, 129, 17)
	$Label4 = GUICtrlCreateLabel("Contact me: DanielBlevinsLCN at gmail.com", 48, 104, 211, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Button1 = GUICtrlCreateButton("&OK", 116, 208, 75, 25, 0)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit

			Case $Button1
		EndSwitch
	WEnd
EndFunc   ;==>showAbout


Func save()
	$LCNconfHandle = FileOpen("LCN.conf", 2+8)
	FileWriteLine($LCNconfHandle, "----LCN Config do not edit unless you know what you are doing!!!!!----")
	$aPassword = GUICtrlRead($Password)
	$aUsername = GUICtrlRead($UserName)
	$aFrequency = GUICtrlRead($Frequecy)
	Local $pEncrypted = _AesEncrypt($random, $aPassword)
	Local $uEncrypted = _AesEncrypt($random, $aUsername)
	;$pEncrypted = $Password
	;$uEncrypted = $UserName
	;MsgBox(1, "DEBUGGER2", $uEncrypted)
	;MsgBox(1, "DEBUGGER2", $pEncrypted)
	;MsgBox(1, "DEBUGGER2", $aPassword)
	;MsgBox(1, "DEBUGGER2", $aUsername)
	FileWrite($LCNconfHandle, $uEncrypted&@CRLF) ;2
	FileWrite($LCNconfHandle, $pEncrypted&@CRLF) ;3
	FileWriteLine($LCNconfHandle, $aFrequency) ;4
	FileWriteLine($LCNconfHandle, $V_cOn) ;5
	FileWriteLine($LCNconfHandle, $V_eOn) ;6
	FileWriteLine($LCNconfHandle, $V_Ln_aOn) ;7
	FileWrite($LCNconfHandle, $random) ;8
	;FileWrite($LCNconfHandle, $pEncrypted);9
	FileClose($LCNconfHandle)
EndFunc   ;==>save

Func load()
	$exist = FileExists("LCN.conf")
	Local $readBuffer = ""
	If $exist Then
		$LCNconfHandleLoad = FileOpen("LCN.conf")
		$r_random = FileReadLine($LCNconfHandleLoad, 8) ;random
		$random = $r_random
		;MsgBox(1 ,"DEBUGGER",$r_random)
		$readBuffer = FileReadLine($LCNconfHandleLoad, 2) ;username
		;MsgBox(1 ,"DEBUGGER",$readBuffer)
		$sUsername = _AesDecrypt($r_random, $readBuffer)
		$sUsername = BinaryToString($sUsername)
		;$sUsername = $readBuffer
		;MsgBox(1 ,"DEBUGGER",$sUsername)
		$readBuffer = FileReadLine($LCNconfHandleLoad, 3) ;pass
		;MsgBox(1 ,"DEBUGGER",$readBuffer)
		$sPassword = _AesDecrypt($r_random, $readBuffer)
		$sPassword = BinaryToString($sPassword)
		;$sPassword = $readBuffer
		;MsgBox(1 ,"DEBUGGER",$sPassword)

		$sFrequency = FileReadLine($LCNconfHandleLoad, 4)
		$s_cOn = FileReadLine($LCNconfHandleLoad, 5)
		$s_eOn = FileReadLine($LCNconfHandleLoad, 6)
		$s_Ln_aOn = FileReadLine($LCNconfHandleLoad, 7)
		FileClose($LCNconfHandleLoad)
	EndIf
EndFunc   ;==>load

Func radiobutons()
	$exist = FileExists("LCN.conf")
	If $exist Then
		If $s_cOn = 1 Then
			GUICtrlSetState($cOn, $GUI_CHECKED)
			$V_cOn = 1
		Else
			GUICtrlSetState($cOff, $GUI_CHECKED)
			$V_cOn = 0
		EndIf
		If $s_eOn = 1 Then
			GUICtrlSetState($eOn, $GUI_CHECKED)
			$V_eOn = 1
		Else
			GUICtrlSetState($eOff, $GUI_CHECKED)
			$V_eOff = 0
		EndIf
		If $s_Ln_aOn = 1 Then
			GUICtrlSetState($Ln_aOn, $GUI_CHECKED)
			$V_Ln_aOn = 1
		Else
			GUICtrlSetState($Ln_aOff, $GUI_CHECKED)
			$V_Ln_aOn = 0
		EndIf
	EndIf
EndFunc   ;==>radiobutons


Func StringEncrypt($fEncrypt, $sData, $sKey)
	_Crypt_Startup() ; Start the Crypt library.
	Local $sReturn = ''
	If $fEncrypt Then ; If the flag is set to True then encrypt, otherwise decrypt.

		Local $hKey = _Crypt_DeriveKey($sKey, $CALG_AES_256)
		Local $sReturn = _Crypt_EncryptData($sData, $hKey, $CALG_USERKEY)
		_Crypt_DestroyKey($hKey)
	Else
		Local $hKey = _Crypt_DeriveKey($sKey, $CALG_AES_256)
		Local $sReturn = BinaryToString(_Crypt_DecryptData(Binary($sData), $hKey, $CALG_USERKEY))
		_Crypt_DestroyKey($hKey)
		EndIf
	_Crypt_Shutdown() ; Shutdown the Crypt library.
	Return $sReturn
EndFunc   ;==>StringEncrypt