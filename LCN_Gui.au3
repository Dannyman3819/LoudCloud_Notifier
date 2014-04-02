#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <Crypt.au3>
#include "Include\AES.au3"
#include <Array.au3>
#include <ProgressConstants.au3>

TraySetIcon("LCN.ico")

;sets all settings off
$V_cOn = 0
;~ $V_cOff = 1
$V_eOn = 0
;~ $V_eOff = 1
;~ $V_pOn = 0
;~ $V_pOff = 1
$V_Ln_aOn = 0
;~ $V_Ln_aOff = 1
$V_Ln_f_mOn = 0
;~ $V_Ln_f_mOff = 1
$V_LN_f_iOn = 0
;~ $V_LN_f_iOff = 1
$V_LN_a_lOn = 0
$V_LN_w_On = 0
;~ $V_OK = 0
;~ $V_CANCEL = 0
;~ $V_ABOUT = 0

$sUsername = ""
$sPassword = ""
$sFrequency = "1"
$s_cOn = ""
$s_eOn = ""
$s_Ln_aOn = ""
$s_Ln_f_mOn = ""
$s_Ln_f_iOn = ""
$s_LN_a_lOn = ""
$s_LN_w_On = ""
$P_Load = ""
$L_Load = ""
$Loading = ""


$aPassword = ""
$aUsername = ""
$aFrequency = ""

$random = Random(5, 20, 1) ;create a random number to encrypt password & usernam
;$random = "12345"

;if a config file is found it will overwrite above settings
load() ;loads LCN.conf
;radiobutons(); changes settings of radio buttons into TRUE and FALSE

#region ### START Koda GUI section ### Form=c:\users\daniel\desktop\scripts_stuff\batch\curl\testing_folder\autoit\lcn setup.kxf
$LCN_Setup = GUICreate("LoudCloud Notifier", 554, 397, 265, 139)
$PageControl1 = GUICtrlCreateTab(8, 8, 636, 352)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")

$TabSheet1 = GUICtrlCreateTabItem(" LoudCloud Settings")
$UserName = GUICtrlCreateInput($sUsername, 16, 98, 209, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
GUICtrlSetState(-1, $GUI_FOCUS)
$L_Username = GUICtrlCreateLabel("UserName:", 16, 74, 69, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Password = GUICtrlCreateInput($sPassword, 16, 154, 209, 24, $ES_PASSWORD)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_Password = GUICtrlCreateLabel("Password:", 16, 130, 65, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_Frequency = GUICtrlCreateLabel("Check Frequency", 360, 74, 106, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Frequecy = GUICtrlCreateInput($sFrequency, 368, 98, 33, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_Min = GUICtrlCreateLabel("Min.", 408, 106, 23, 19)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")

$L_ClassID = GUICtrlCreateLabel("Get Class ID's again (required if you get new classes or for first use)", 16, 192, 410, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_Intruction = GUICtrlCreateLabel("Please go through all tabs to select settings for first use!", 16, 42, 330, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$B_Get = GUICtrlCreateButton("Get", 16, 216, 75, 25)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_Intruction = GUICtrlCreateLabel("Current Classes:", 20, 243, 120)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$LI_ClassID = GUICtrlCreateList("", 24, 268, 400, 86)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
loadClassID() ;fills list if get script already ran

$TabSheet2 = GUICtrlCreateTabItem("Notification")
$Label1 = GUICtrlCreateLabel("Do you want to turn on computer notifications?", 16, 42, 273, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$cGroup = GUICtrlCreateGroup("", 16, 58, 520, 289)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$L_cComputer = GUICtrlCreateLabel("Computer:", 24, 74, 64, 20)
$cOn = GUICtrlCreateRadio("On", 32, 98, 41, 17)
$cOff = GUICtrlCreateRadio("Off", 80, 98, 41, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$TabSheet3 = GUICtrlCreateTabItem("LoudCloud Notifications")

$Label2 = GUICtrlCreateLabel("Pick what you want to be notified for:", 16, 40, 213, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")

GUIStartGroup()
$L_aAnnouncments = GUICtrlCreateLabel("Announcements:", 24, 72, 102, 20)
$Ln_aOn = GUICtrlCreateRadio("On", 32, 96, 41, 17)
$Ln_aOff = GUICtrlCreateRadio("Off", 80, 96, 41, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUIStartGroup()
$Label4 = GUICtrlCreateLabel("Forum:", 24, 128, 45, 20)
$Label3 = GUICtrlCreateLabel("Main Forum: (WIP)", 32, 152, 114, 20)
$Ln_f_mOn = GUICtrlCreateRadio("On", 40, 176, 41, 17)
$Ln_f_mOff = GUICtrlCreateRadio("Off", 80, 176, 41, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUIStartGroup()
$Label5 = GUICtrlCreateLabel("Individual Forum: (WIP)", 32, 200, 138, 20)
$LN_f_iOn = GUICtrlCreateRadio("On", 40, 224, 41, 17)
$LN_f_iOff = GUICtrlCreateRadio("Off", 80, 224, 41, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUIStartGroup()
GUIStartGroup()
GUIStartGroup()
$Label6 = GUICtrlCreateLabel("Class Wall:", 24, 256, 71, 20)
$LN_w_On = GUICtrlCreateRadio("On", 32, 280, 41, 17)
$LN_w_Off = GUICtrlCreateRadio("Off", 72, 280, 33, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUIStartGroup()
GUICtrlCreateGroup("", -99, -99, 1, 1)
$TabSheet4 = GUICtrlCreateTabItem("Advanced")
$Label7 = GUICtrlCreateLabel("Warning Debugging setting don't touch unless you know what your doing!", 16, 40, 472, 19)
GUICtrlSetFont(-1, 10, 400, 0, "Arial Rounded MT Bold")
$Group2 = GUICtrlCreateGroup("", 16, 60, 520, 265)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label8 = GUICtrlCreateLabel("Logging:", 24, 76, 53, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$LN_a_lOff = GUICtrlCreateRadio("Off", 72, 100, 33, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$LN_a_lOn = GUICtrlCreateRadio("On", 32, 100, 33, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
$OK = GUICtrlCreateButton("&OK", 302, 368, 75, 25)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
$CANCEL = GUICtrlCreateButton("&Cancel", 382, 368, 75, 25)
$ABOUT = GUICtrlCreateButton("&About", 464, 368, 75, 25)
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
		Case $LN_w_On
			$V_LN_w_Off = 0
			$V_LN_w_On = 1
		Case $LN_w_Off
			$V_LN_w_Off = 1
			$V_LN_w_On = 0
		Case $LN_a_lOn
			$V_LN_a_lOn = 1
			$V_LN_a_lOff = 0
		Case $LN_a_lOff
			$V_LN_a_lOn = 1
			$V_LN_a_lOff = 0

		Case $OK
			$V_OK = 1
			save()
		Case $CANCEL
			$V_CANCEL = 1
			$TempError = MsgBox(4, "LoudCloud Notifier", "Not saving! Continue?")
			If $TempError = 6 Then Exit
		Case $ABOUT
			$V_ABOUT = 1
			showAbout()
		Case $B_Get
			loadClassIDGUI()
			getClassID()
			loadClassID(1)
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
	$Label2 = GUICtrlCreateLabel("Version: ", 232, 56, 70, 17)
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
				GUIDelete($Form1_1)
		EndSwitch
	WEnd
EndFunc   ;==>showAbout

Func save()
	$aPassword = GUICtrlRead($Password)
	$aUsername = GUICtrlRead($UserName)
	$aFrequency = GUICtrlRead($Frequecy)

	If $aUsername = "" Or $aPassword = "" Then
		MsgBox(0, "LoudCloud Notifier", "Error! Please enter Username and Password")
	Else
		Local $pEncrypted = _AesEncrypt($random, $aPassword)
		Local $uEncrypted = _AesEncrypt($random, $aUsername)
		if @error Then MsgBox( 0, "", "ERROR encrypting")
		$LCNconfHandle = FileOpen("LCN.conf", 2 + 8)
		FileWriteLine($LCNconfHandle, "----LCN Config do not edit unless you know what you are doing!!!!!----")

		;$pEncrypted = $Password
		;$uEncrypted = $UserName
		;MsgBox(1, "DEBUGGER2", $uEncrypted)
		;MsgBox(1, "DEBUGGER2", $pEncrypted)
		;MsgBox(1, "DEBUGGER2", $aPassword)
		;MsgBox(1, "DEBUGGER2", $aUsername)
		FileWrite($LCNconfHandle, $uEncrypted & @CRLF) ;2
		FileWrite($LCNconfHandle, $pEncrypted & @CRLF) ;3
		FileWriteLine($LCNconfHandle, $aFrequency) ;4
		FileWriteLine($LCNconfHandle, $V_cOn) ;5
		FileWriteLine($LCNconfHandle, $V_Ln_f_mOn) ;6
		FileWriteLine($LCNconfHandle, $V_Ln_aOn) ;7
		FileWriteLine($LCNconfHandle, $random) ;8
		FileWriteLine($LCNconfHandle, $V_LN_f_iOn) ;9
		FileWriteLine($LCNconfHandle, $V_LN_w_On) ;10
		FileWriteLine($LCNconfHandle, $V_LN_a_lOn) ;11
		FileClose($LCNconfHandle)
		;Exit

		$LCNconfHandle = FileOpen("LCN.conf")
		$uReadBuffer = FileReadLine($LCNconfHandle, 2);username
		$pReadBuffer = FileReadLine($LCNconfHandle, 3) ;pass
		$rReadBuffer = FileReadLine($LCNconfHandle, 8)

		$sEnUsername = _AesDecrypt($rReadBuffer, $uReadBuffer)
		$sEnUsername = BinaryToString($sEnUsername)

		$sEnPassword = _AesDecrypt($rReadBuffer, $pReadBuffer)
		$sEnPassword = BinaryToString($sEnPassword)
		FileClose($LCNconfHandle)

		if $sEnPassword = $aPassword and $sEnUsername Then
			Exit
		Else
			FileDelete( "LCN.conf" )
			MsgBox(0, "LCN", "Error! Unable to save please enter username and password again!")
			GUICtrlSetData($UserName, "")
			GUICtrlSetData($Password, "")
		EndIf

	EndIf
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
		$s_Ln_f_mOn = FileReadLine($LCNconfHandleLoad, 6)
		$s_Ln_aOn = FileReadLine($LCNconfHandleLoad, 7)
		$s_Ln_f_iOn = FileReadLine($LCNconfHandleLoad, 9)
		$s_LN_w_On = FileReadLine($LCNconfHandleLoad, 10)
		$s_LN_a_lOn = FileReadLine($LCNconfHandleLoad, 11)
		FileClose($LCNconfHandleLoad)

	EndIf
EndFunc   ;==>load

Func loadClassID($loadingGUI = 0)
	If FileExists("ClassesID.txt") Then
		If $loadingGUI = 1 Then
			GUICtrlSetData($P_Load, 95)
			GUICtrlSetData($L_Load, "Preparing data...")
		EndIf
		$aID_ClassesIDReadHandle = FileOpen("ClassesID.txt")
		$aID_ClassesNameReadHandle = FileOpen("ClassesName.txt")
		$aID_countWhile = 1
		$aID_count = 1
		While $aID_countWhile
			$aID_IDbuffer = FileReadLine($aID_ClassesIDReadHandle, $aID_count)
			$aID_Namebuffer = FileReadLine($aID_ClassesNameReadHandle, $aID_count)
			If @error Then
				$aID_countWhile = 0
				If $loadingGUI = 1 Then
					GUICtrlSetData($P_Load, 100)
					GUICtrlSetData($L_Load, "Done...")
					Sleep(100)
					GUIDelete($Loading)
				EndIf
			Else
				;if $aID_IDbuffer = "" or $aID_IDbuffer = "" Then ExitLoop ;if file is empty
				GUICtrlSetData($LI_ClassID, $aID_Namebuffer & " --- " & $aID_IDbuffer)
				$aID_count = $aID_count + 1
			EndIf
		WEnd

	EndIf
EndFunc   ;==>loadClassID

Func loadClassIDGUI()
	$Loading = GUICreate("Loading", 298, 121, 457, 297)
	$P_Load = GUICtrlCreateProgress(8, 56, 278, 25, $PBS_SMOOTH)
	$L_LoadWait = GUICtrlCreateLabel("Loading...Please Wait", 72, 16, 158, 22)
	GUICtrlSetFont(-1, 12, 400, 0, "Arial")
	$L_Load = GUICtrlCreateLabel("STARTING", 24, 96, 243, 17, $SS_CENTER)
	GUICtrlSetData(-1, "Downloading Class ID's from LC...")
	GUISetState(@SW_SHOW)

EndFunc   ;==>loadClassIDGUI

Func radiobutons() ;loads save settings
	$exist = FileExists("LCN.conf")
	If $exist Then
		If $s_cOn = 1 Then
			GUICtrlSetState($cOn, $GUI_CHECKED)
			$V_cOn = 1
		Else
			GUICtrlSetState($cOff, $GUI_CHECKED)
			$V_cOn = 0
		EndIf
		If $s_Ln_aOn = 1 Then
			GUICtrlSetState($Ln_aOn, $GUI_CHECKED)
			$V_Ln_aOn = 1
		Else
			GUICtrlSetState($Ln_aOff, $GUI_CHECKED)
			$V_Ln_aOn = 0
		EndIf
		If $s_Ln_f_mOn = 1 Then
			GUICtrlSetState($Ln_f_mOn, $GUI_CHECKED)
			$V_Ln_f_mOn = 1
		Else
			GUICtrlSetState($Ln_f_mOff, $GUI_CHECKED)
			$V_Ln_f_mOn = 0
		EndIf
		If $s_Ln_f_iOn = 1 Then
			GUICtrlSetState($LN_f_iOn, $GUI_CHECKED)
			$V_LN_f_iOn = 1
		Else
			GUICtrlSetState($LN_f_iOff, $GUI_CHECKED)
			$V_LN_f_iOff = 0
		EndIf
		If $s_LN_w_On = 1 Then
			GUICtrlSetState($LN_w_On, $GUI_CHECKED)
			$V_LN_w_On = 1
		Else
			GUICtrlSetState($Ln_f_mOff, $GUI_CHECKED)
			$V_LN_w_Off = 0
		EndIf
		If $s_LN_a_lOn = 1 Then
			GUICtrlSetState($LN_a_lOn, $GUI_CHECKED)
			$V_LN_a_lOn = 1
		Else
			GUICtrlSetState($LN_a_lOff, $GUI_CHECKED)
			$V_LN_a_lOff = 0
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

Func getClassID()
	GUICtrlSetData($P_Load, 15)
	Sleep(10)
	GUICtrlSetData($P_Load, 20)
	GUICtrlSetData($L_Load, "Downloading Class ID's from LC...")
	$cID_Username = GUICtrlRead($UserName)
	$cID_Password = GUICtrlRead($Password)
	ShellExecuteWait(@ScriptDir & "\Fetch_ClassID.bat", $cID_Username & " " & $cID_Password, "", "", @SW_HIDE)
	GUICtrlSetData($P_Load, 40)
	GUICtrlSetData($L_Load, "Parsing data...")
	$cID_MainReadHandle = FileOpen("Temp\Main_Page.htm")
	$cID_ClassesIDWriteHandle = FileOpen("ClassesID.txt", 2) ;write mode, overwrites data
	$cID_ClassesNameWriteHandle = FileOpen("ClassesName.txt", 2) ;write mode, overwrites data
	If @error Then MsgBox(0, "", "ERROR")
	$cID_MainRead = FileRead($cID_MainReadHandle)
	GUICtrlSetData($P_Load, 45)
	GUICtrlSetData($L_Load, "Parsing data...")
	$cID_WhileCount = 1
	While $cID_WhileCount
		$cID_IDBlock = _StringBetween2($cID_MainRead, 'input class="allClassCheck" checked="checked" type="checkbox" name="allClassCheck" value="', '" /></span>') ;find table of info

		;MsgBox(1, "DEBUG 14", $cID_IDBlock)

		FileWriteLine($cID_ClassesIDWriteHandle, $cID_IDBlock) ;write data into processing file
		$cID_IDBlockNumber = StringInStr($cID_MainRead, 'input class="allClassCheck" checked="checked" type="checkbox" name="allClassCheck" value="') ;find where actual info starts
		$cID_IDBlockNumber = $cID_IDBlockNumber - 1 ;removes data 1 line before the ID

		;MsgBox(1, "DEBUG 20", $cID_IDBlockNumber)

		$cID_MainRead = StringTrimLeft($cID_MainRead, $cID_IDBlockNumber) ;trim used data that will get in the way

		$cID_NameBlock = _StringBetween2($cID_MainRead, '" /></span> <label>', '</label>') ;finds class name

		;MsgBox(1, "DEBUG 26", $cID_NameBlock)

		FileWriteLine($cID_ClassesNameWriteHandle, $cID_NameBlock) ;write data into processing file
		$cID_NameBlockNumber = StringInStr($cID_MainRead, '" /></span> <label>') ;find where actual info starts
		$cID_MainRead = StringTrimLeft($cID_MainRead, $cID_NameBlockNumber) ;trim used data that will get in the way

		;MsgBox(1, "DEBUG 32", $cID_MainRead)

		$cID_IDBlockTemp = _StringBetween2($cID_MainRead, 'input class="allClassCheck" checked="checked" type="checkbox" name="allClassCheck" value="', '" /></span>') ;find table of info
		If Not StringInStr($cID_IDBlockTemp, @CRLF) = 0 Then
			GUICtrlSetData($P_Load, 90)
			GUICtrlSetData($L_Load, "Closing Files..")
			$cID_WhileCount = 0
			FileClose($cID_ClassesIDWriteHandle)
			FileClose($cID_ClassesNameWriteHandle)
			FileClose($cID_MainReadHandle)
		EndIf
	WEnd

EndFunc   ;==>getClassID

Func _StringBetween2($s, $from, $to)
	$x = StringInStr($s, $from) + StringLen($from)
	$y = StringInStr(StringTrimLeft($s, $x), $to)
	Return StringMid($s, $x, $y)
EndFunc   ;==>_StringBetween2
