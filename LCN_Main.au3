#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=LCN.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1
	LoudCloud Notifier (LCN)
	Author:         Daniel Blevins
	Contact:        DanielBlevinsLCN at Gmail.com
	Script Function:
	This script will check your LC notifications and notifiy you if you have any new ones.
	specifically this script runs in the background and runs other scripts

#ce ----------------------------------------------------------------------------

#include <Array.au3>
#include <Crypt.au3>
#include <File.au3>

#RequireAdmin
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 3) ; The default tray menu items will not be shown and items are not checked when selected. These are options 1 and 2 for TrayMenuMode.
Opt("TrayOnEventMode", 1) ; Enable TrayOnEventMode.

TraySetIcon("LCN.ico")
$tAbout = TrayCreateItem("About")
TrayItemSetOnEvent(-1, "showAbout")
$tSetup = TrayCreateItem("Setup")
TrayItemSetOnEvent(-1, "tSetup")
$tExit = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "ExitScript")
TraySetState(1) ; Show the tray menu.

$sFrequency = "1"
$s_f_mOn = ""
$s_Ln_aOn = "1"
$s_f_iOn = ""
$s_w_On = ""
$s_a_lOn = "0"; turns debugging off until conf file is read
$s_cOn = ""
$adataID = ""
$nCount = 0

$TempDir = @AppDataDir&"\LoudCloud_Notifier\"

$confHandle = FileOpen($TempDir&"LCN.conf") ;load config settings from setup
$DebugOverride = 1 ;overrides setting in config file good for debugging problems before opening of the conf file

;if $s_a_lOn = 1 or $DebugOverride = 1 Then
		$DebugLog = FileOpen($TempDir&"debug.log", 2) ;open log for debugging
;EndIf

debug("Starting Program Advanced script logging")
if @error Then errorCode(1001)

If $confHandle = -1 Then
	debug("-Error- No config file found!")
	$setup = MsgBox(4, "LCN Error", "An error has ccured opening config file. Would you like to run setup?")
	If $setup = "6" Then
		debug("Running LCN Setup")
		if FileExists( "LCN_Gui.exe" ) Then
			RunWait("LCN_Gui.exe")
		Else
			RunWait("LCN_Gui.au3")
		EndIf
		$confHandle = FileOpen("LCN.conf")
	Else
		Exit
	EndIf
EndIf

$confRead = FileRead($confHandle)
If $confRead = "" Then
	debug("-Error- Reading config file!")
	MsgBox(1, "LCN Error", "An error has ccured reading config file. Exiting!")
	Exit
EndIf

;class ID's:
;$PSY = "9a5769f0-ac0a-4089-9ea7-9a922f94c295"
;$ENG = "a3ba3bfc-8b74-4f86-8ef1-4576345b66ca"
;$MAT = "cb60a800-503d-420e-bee2-b8a65cc9fcf2"
;$PHI = "d16dfd79-74d2-4d46-a186-d38b157f1c8e"

$sPassword = ""
$sUsername = ""
$AESkey = ""

$random = $AESkey

load();loads conf file
debug("Finished loading config file")

$delay = @HOUR*60
$delay = $delay+@MIN ;$delay = timestamp in seconds
$delay = $delay+$sFrequency
;$delay = 5 * $sFrequency ;for testing purposes
$count1 = $delay ;start with counter to max so when program start it will load

While 1 ;main background process; error code 02
	If $count1 = $delay Then
		;MsgBox(0,"", $sFrequency)
		;MsgBox(0, "", $delay)
		load();loads conf file
		getRawHtml();runs .bat script to get info from LC
		$aDataHandleWrite = FileOpen($TempDir&"dataFile.txt", 10)
		$aDataHandle = FileOpen($TempDir&"dataFile.txt")
		$aDataWallHandleWrite = FileOpen($TempDir&"dataWall.txt", 10)
		$aDataWallHandle = FileOpen($TempDir&"dataWall.txt")


		$dCount = 1
		$dCount1 = 0 ;clears how many files there are
		While $dCount
			$dCount1 = $dCount1 + 1
			If FileExists($TempDir&"Announcements" & $dCount1 & ".htm") Then
				getAnnouncements($TempDir&"Announcements" & $dCount1 & ".htm", $TempDir&"dataFile" & $dCount1 & ".txt");parses data into txt file
			Else
				$dCount = 0
			EndIf

;~ 			If FileExists($TempDir&"Wall" & $dCount1 & ".htm") Then
;~ 				getWall($TempDir&"Wall" & $dCount1 & ".htm", $TempDir&"dataWall" & $dCount1 & ".txt");parses data into txt file
;~ 			Else
;~ 				$dCount = 0
;~ 			EndIf


		WEnd
		dataCombine($dCount1);function that opens and combines X many data files
		start()
		FileClose($aDataHandleWrite)
		FileClose($aDataHandle)
		FileClose($aDataWallHandleWrite)
		FileClose($aDataWallHandle)
		$count1 = 0
		;$delay = 60*60*$sFrequency ;redo incase frequency was changed
		$delay = @HOUR*60
		$delay = $delay+@MIN ;$delay = timestamp in seconds
		$delay = $delay+$sFrequency
		debug("TimeStamp:"&$delay)
	EndIf

	$anProcess = ProcessList("Notify.exe")
	if $anProcess[0][0] = 0 then
		TraySetState(8) ;stops flash if no notifications are being displayed
	EndIf

	Sleep(100)
	;$count1 = $count1 + 1
	$count1 = @HOUR*60
	$count1 = $count1+@MIN ;$delay = timestamp in minutes ;this counts the current time
	if @error Then errorCode(0201)
WEnd

Func start() ;error code 04
	$aDataHandle = FileOpen($TempDir&"dataFile.txt")
	if @error Then errorCode(0401)
	$aDataBuffer = FileReadLine($aDataHandle, 1); read first line to see if theres an announcements
	;if @error Then errorCode(0402) normal error (errors when empty)
	$AnnouncementLogHandleRead = FileOpen($TempDir&"Displayed.log", 8)
	if @error Then errorCode(0403)
	$AnnouncementLogHandleWrite = FileOpen($TempDir&"Displayed.log", 9)
	if @error Then errorCode(0404)
	If $aDataBuffer = "" Then ;start while to read data if not empty
		$loop = 0
	Else
		$loop = 1
		$count = 1
		$AnnouncementLog = FileRead($AnnouncementLogHandleRead)
		if @error Then errorCode(0405)
		While $loop
			$aDataID = FileReadLine($aDataHandle, $count)
			;if @error Then errorCode(0406)
			$count = $count + 1;2
			$aDataAuthor = FileReadLine($aDataHandle, $count)
			;if @error Then errorCode(0407)
			$count = $count + 1;3
			$aDataDate = FileReadLine($aDataHandle, $count)
			;if @error Then errorCode(0408)
			$count = $count + 1;4
			$aDataText = FileReadLine($aDataHandle, $count)
			;if @error Then errorCode(0409)
			$count = $count + 1;5
			$AnnouncementLogCheck = StringInStr($AnnouncementLog, $aDataID)
			If $aDataID = "" Then
				$loop = 0
				$AnnouncementLogCheck = ""
				$AnnouncementLog = ""
			Else
				If $AnnouncementLogCheck = 0 Then ;check to see if notification has already been displayed for thsi announcement
					If FileReadLine($aDataHandle, $count) = "" Then ;no more notifications??,,,count reads next data packet (line 5) in file
						;if @error Then errorCode(0410) ;displays error from reading blank line
						$loop = 0
						$AnnouncementLogCheck = ""
						$AnnouncementLog = ""
						;MsgBox( 1, "DEBUG 140", "HERE" )
					EndIf

					FileWriteLine($AnnouncementLogHandleWrite, $aDataID)
					if @error Then errorCode(0411)
					Notify("Announcement:" & @CRLF & $aDataAuthor & " -- " & $aDataDate, $aDataText)
					;MsgBox( 1, "DEBUG 144", "HERE" )
				Else
					debug("Got notification but already displayed: " & $adataID)
				EndIf
			EndIf
		WEnd
	EndIf

	FileClose($AnnouncementLogHandleRead)
	FileClose($AnnouncementLogHandleWrite)

EndFunc   ;==>start

Func dataCombine($fileCount) ;error code 05
	$dcCountWhile = 1
	$dcCount = 0
	While $dcCountWhile
		$dcCount = $dcCount + 1
		If $dcCount = $fileCount Then
			$dcCountWhile = 0
		Else
			$aDataHandle = FileOpen($TempDir&"dataFile" & $dcCount & ".txt")
			if @error Then errorCode(0501)
			$aDataRead = FileRead($aDataHandle)
			if @error Then errorCode(0502)
			FileWrite($aDataHandleWrite, $aDataRead)
			if @error Then errorCode(0503)
			FileClose($aDataHandle)
		EndIf
	WEnd
EndFunc   ;==>dataCombine

Func Notify($Title, $Text) ;error code 06
	if $s_cOn = "1" Then ;if computer notifications are on
		debug("Displaying Notification: " & $adataID)
		ShellExecute(@ScriptDir & "\Notify.exe", '"' & $Title & '"' & " " & '"' & $Text & '"' & " " & '"-0"' & " " & '"' & "GC=7EBEE9 BF=1000 SC=200" & '"')
		TraySetState(4);start flash
		;syntax(quotes required): Notify.exe "Title" "Message" "-0(means permanant until clicked)" "GC=(Background Color) BF=(Border Flash)"
		if @error Then errorCode(0601)
		Sleep(100) ;required for notify program

	EndIf
EndFunc   ;==>Notify

Func getRawHtml() ;error code 03
	if $s_f_mOn = "1" Then
		;execute main forum script
		debug("Getting Main Forum posts from LC")
	EndIf
	if $s_Ln_aOn = "1" Then
		debug("Getting Announcements from LC")
		CheckInternet()
		TrayTip( "LoudCloud Notifier", "Getting Announcements...", 5, 16)
		ShellExecuteWait(@ScriptDir & "\Fetch_Announcements.bat", $sUsername & " " & $sPassword, "", "", @SW_HIDE)
		If @error Then errorCode(0301)
		If not FileExists($TempDir&"Announcements1.htm") Then
			debug("Either incorrect user or pass, or no class ID's")
			$setup = MsgBox( 4, "LCN", "-Error- Either incorrect username or password, or you did not get class ID's" &@CRLF& "You must run setup again for program to work! Run?")
			If $setup = "6" Then
				debug("Running LCN Setup")
				if FileExists( "LCN_Gui.exe" ) Then
					RunWait("LCN_Gui.exe")
				Else
					RunWait("LCN_Gui.au3")
				EndIf
				getRawHtml() ;run this function again
			Else
				debug("Exiting!")
				Exit
			EndIf
		EndIf
	EndIf
	if $s_f_iOn = "1" Then
		;execute idividual forum script
		debug("Getting Individual Forum posts from LC")
	EndIf
;~ 	if $s_w_On = "1" Then
;~ 		debug("Getting Class Wall posts from LC")
;~ 		CheckInternet()
;~ 		TrayTip( "LoudCloud Notifier", "Getting Class Wall Posts...", 5, 16)
;~ 		ShellExecuteWait(@ScriptDir & "\Fetch_Wall.bat", $sUsername & " " & $sPassword, "", "", @SW_HIDE)
;~ 		If @error Then errorCode(0301)
;~ 		If not FileExists($TempDir&"Announcements1.htm") Then
;~ 			debug("Either incorrect user or pass, or no class ID's")
;~ 			$setup = MsgBox( 4, "LCN", "-Error- Either incorrect username or password, or you did not get class ID's" &@CRLF& "You must run setup again for program to work! Run?")
;~ 			If $setup = "6" Then
;~ 				debug("Running LCN Setup")
;~ 				if FileExists( "LCN_Gui.exe" ) Then
;~ 					RunWait("LCN_Gui.exe")
;~ 				Else
;~ 					RunWait("LCN_Gui.au3")
;~ 				EndIf
;~ 				getRawHtml() ;run this function again
;~ 			Else
;~ 				debug("Exiting!")
;~ 				Exit
;~ 			EndIf
;~ 		EndIf

;~ 	EndIf
EndFunc   ;==>getRawHtml

Func getAnnouncements($htmFile, $dataFile) ;error code 07
	$Announcements = FileOpen($htmFile) ;open announcements file
	if @error Then errorCode(0701)
	$txtOpenAnnouncements = FileOpen($dataFile, 10) ;open file for finished processing
	if @error Then errorCode(0702)
	$R_Announcements = FileRead($Announcements)
	if @error Then errorCode(0703)

	$aBlocks = _StringBetween2($R_Announcements, "<table", "</table>") ;find table of info
	;MsgBox(1, "Debug2", $aBlocks)
	;FileWrite($tOpenAnnouncements,$aBlocks) ;write data into processing file
	$a1 = StringInStr($aBlocks, "</tr>") ;find where actual info starts
	$aBlocksSplit = StringTrimLeft($aBlocks, $a1) ;trim unneeded header

	$a1 = StringInStr($aBlocks, "<tr  id=") ;find where actual info starts

	$loop = 1
	While $loop

		If $a1 = 0 Then
			;MsgBox(1, "DEBUG", "No Announcements")
			Return 0
			ExitLoop
		EndIf

		$aID = _StringBetween2($aBlocksSplit, 'id="', '"') ;find Announcment ID
		$aText = _StringBetween2($aBlocksSplit, ')">', "</a>") ;saves text

		$aAuthor = _StringBetween2($aBlocksSplit, "<td>", "</td>") ;saves Author
		$a2 = StringInStr($aBlocksSplit, "<td>") ;finds authors postion
		$aBlocksSplit = StringTrimLeft($aBlocksSplit, $a2) ;deletes author data
		$aDate = _StringBetween2($aBlocksSplit, "<td>", "</td>") ;saves date
		$a2 = StringInStr($aBlocksSplit, "</tr>") ;find irrelevant data that will get in the way
		$aBlocksSplit = StringTrimLeft($aBlocksSplit, $a2) ;deletes data

		If StringInStr($aBlocksSplit, "<tr  id=") = 0 Then $loop = 0 ;find if there are more annoucments

		;MsgBox(1, "", $aAuthor)
		;MsgBox(1, "", $aDate)
		;MsgBox(1, "", $aID)
		;MsgBox(1, "", $aText)

		if @error Then errorCode(0706)
		FileWriteLine($txtOpenAnnouncements, $aID)
		if @error Then errorCode(0705)
		FileWriteLine($txtOpenAnnouncements, $aAuthor)
		if @error Then errorCode(0706)
		FileWriteLine($txtOpenAnnouncements, $aDate)
		if @error Then errorCode(0707)
		FileWriteLine($txtOpenAnnouncements, $aText)
		if @error Then errorCode(0708)

		;_ArrayDisplay($String)
	WEnd

	FileClose($Announcements)
	FileClose($txtOpenAnnouncements)
EndFunc   ;==>getAnnouncements

Func getWall($htmFile, $dataFile)



EndFunc

Func _StringBetween2($s, $from, $to)
	$x = StringInStr($s, $from) + StringLen($from)
	$y = StringInStr(StringTrimLeft($s, $x), $to)
	Return StringMid($s, $x, $y)
EndFunc   ;==>_StringBetween2

Func load() ;Error code number 01
	$confHandle = FileOpen($TempDir&"LCN.conf")
	debug("Loading config file")
	Local $readBuffer = ""
	;$random = FileReadLine($confHandle, 8) ;random
	;if @error Then errorCode(0101)

	_Crypt_Startup()
	$readBuffer = FileReadLine($confHandle, 2) ;username
	if @error Then errorCode(0102)
	$sUsername = BinaryToString(_Crypt_DecryptData($readBuffer,$random, $CALG_AES_256))
	if @error Then errorCode(0104)

	$readBuffer = FileReadLine($confHandle, 3) ;pass
	;if @error Then errorCode(0105)
	$sPassword = BinaryToString(_Crypt_DecryptData($readBuffer,$random, $CALG_AES_256))
	if @error Then errorCode(0107)
	_Crypt_Shutdown()

	$sFrequency = FileReadLine($confHandle, 4) ;Frequency
	if @error Then errorCode(0108)
	$s_cOn = FileReadLine($confHandle, 5) ;computer contifications
	if @error Then errorCode(0109)
	$s_f_mOn = FileReadLine($confHandle, 6) ;notifiy for main forum
	if @error Then errorCode(0110)
	$s_Ln_aOn = FileReadLine($confHandle, 7) ;notify for announcements
	if @error Then errorCode(0111)
	$s_f_iOn = FileReadLine($confHandle, 9) ;notify for individual forum
	if @error Then errorCode(0112)
	$s_w_On = FileReadLine($confHandle, 10) ;class wall
	if @error Then errorCode(0113)
	$s_a_lOn = FileReadLine($confHandle, 11) ;debug logging
	if @error Then errorCode(0114)
	FileClose($confHandle)

	;debug($sUsername & $sPassword & $sFrequency & $s_cOn & $s_f_mOn & $s_Ln_aOn & $s_f_iOn & $s_w_On & $s_a_lOn)

EndFunc   ;==>load

Func getClassID() ;error code 08
	debug("Getting Class ID's")
	ShellExecuteWait(@ScriptDir & "\Fetch_ClassID.bat", $sUsername & " " & $sPassword, "", "", @SW_HIDE)
	if @error Then errorCode(0801)
	$cID_MainReadHandle = FileOpen($TempDir&"Main_Page.htm")
	$cID_ClassesIDWriteHandle = FileOpen($TempDir&"ClassesID.txt", 2) ;write mode, overwrites data
	$cID_ClassesNameWriteHandle = FileOpen($TempDir&"ClassesName.txt", 2) ;write mode, overwrites data
	if @error Then errorCode(0802)

	$cID_MainRead = FileRead($cID_MainReadHandle)
	if @error Then errorCode(0803)

	$cID_WhileCount = 1
	While $cID_WhileCount

		$cID_IDBlock = _StringBetween2($cID_MainRead, 'input class="allClassCheck" checked="checked" type="checkbox" name="allClassCheck" value="', '" /></span>') ;find table of info

		;MsgBox(1, "DEBUG 14", $cID_IDBlock)

		FileWriteLine($cID_ClassesIDWriteHandle, $cID_IDBlock) ;write data into processing file
		$cID_IDBlockNumber = StringInStr($cID_MainRead, 'input class="allClassCheck" checked="checked" type="checkbox" name="allClassCheck" value="') ;find where actual info starts
		$cID_IDBlockNumber = $cID_IDBlockNumber - 1 ;removes data 1 line before the ID
		if @error Then errorCode(0804)
		;MsgBox(1, "DEBUG 20", $cID_IDBlockNumber)

		$cID_MainRead = StringTrimLeft($cID_MainRead, $cID_IDBlockNumber) ;trim used data that will get in the way

		$cID_NameBlock = _StringBetween2($cID_MainRead, '" /></span> <label>', '</label>') ;finds class name

		;MsgBox(1, "DEBUG 26", $cID_NameBlock)

		FileWriteLine($cID_ClassesNameWriteHandle, $cID_NameBlock) ;write data into processing file
		$cID_NameBlockNumber = StringInStr($cID_MainRead, '" /></span> <label>') ;find where actual info starts
		$cID_MainRead = StringTrimLeft($cID_MainRead, $cID_NameBlockNumber) ;trim used data that will get in the way
		if @error Then errorCode(0805)
		;MsgBox(1, "DEBUG 32", $cID_MainRead)

		$cID_IDBlockTemp = _StringBetween2($cID_MainRead, 'input class="allClassCheck" checked="checked" type="checkbox" name="allClassCheck" value="', '" /></span>') ;find table of info
		if not StringInStr( $cID_IDBlockTemp, @CRLF ) = 0 Then
			$cID_WhileCount = 0
			FileClose( $cID_ClassesIDWriteHandle )
			FileClose( $cID_ClassesNameWriteHandle )
			FileClose( $cID_MainReadHandle )
		EndIf
	WEnd
if @error Then errorCode(0806)
EndFunc

Func debug($TempLogMsg)
	if $s_a_lOn = 1 or $DebugOverride = 1 Then
		_FileWriteLog($DebugLog, $TempLogMsg)
	EndIf
endfunc

Func errorCode($TempErrorCode)
	debug("--Error-- Internal ErrorCode:"&$TempErrorCode)
	;function load() = 01
	;main while = 02
	;function getRawHtml() = 03
	;function start() = 04
	;function dataCombine() = 05
	;function notify() = 06
	;function getAnnouncements() = 07
	;function getClassID() = 08
	;function checkinternet() = 09
	;start = 10

	Local $ErrorID1 = StringTrimRight($TempErrorCode, 2) ;strips last two characters leaving error id
	Local $ErrorID2 = StringTrimLeft($TempErrorCode, 2) ;strips main ID leaving last two characters

	If $ErrorID1 = 01 Then
		;do some error processing
	ElseIf $ErrorID1 = 02 Then
		;;
	ElseIf $ErrorID1 = 03 Then
		;;
	ElseIf $ErrorID1 = 04 Then
		;;
	ElseIf $ErrorID1 = 05 Then
		;;
	EndIf

	$TempErrorCode = ""
	$ErrorID1 = ""
	$errorID2 = ""
EndFunc

Func CheckInternet() ;error Code 09
	;This function checks for an internet connection
	;Stalls program until internet is found
	$internetWhile = 1

	While $internetWhile
		sleep(10)
		ping( "www.Google.com" );checks for internet
		if @error Then ;if no internet
			errorCode(0901) ;set error
			TrayTip( "LoudCloud Notifier", "Check Internet connection will retry in 60 seconds", 30, 16)
			Sleep(60000) ;wait 60 seconds
		Else
			$internetWhile = 0
		EndIf

	WEnd
EndFunc

Func ExitScript()
    Exit
EndFunc   ;==>ExitScript

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

Func tSetup()
	debug("Launching Setup from Tray")
	if FileExists( "LCN_Gui.exe" ) Then
		debug("Running LCN_Gui.exe")
		ShellExecuteWait("LCN_Gui.exe", "", "", "", @SW_HIDE)
	Else
		debug("Running LCN_Gui.exe")
		;$TempConfAu3Dir = @ProgramFilesDir & '\AutoIt3\autoit3.exe" "' & @ScriptDir & '\LCN_Gui.au3""'
		;MsgBox(0,"",$TempConfAu3Dir)
		ShellExecuteWait(@ProgramFilesDir & "\AutoIt3\autoit3.exe", @ScriptDir & "\LCN_Gui.au3", "", "", @SW_HIDE)
	EndIf
	debug("Setup Closed")
EndFunc

Func CheckUserPass()
	$check_Username = $sUsername
	$check_Password = $sPassword
	ShellExecuteWait( "CheckUserPass.bat", $check_Username & " " & $check_Password, "", "", @SW_HIDE)
	$check_count = 1
	$check_fileHandle = FileOpen($TempDir&"CheckUserPass.htm")
	$check_fileRead = FileReadLine($check_fileHandle, 1)
	if $check_fileRead = "" Then
		MsgBox( 0, "LCN", "Username or Password incorrect!")
		Return 0
	Else
		Return 1
	EndIf
EndFunc

Func CheckUpdate()
	InetGet( "http://fs1.d-h.st/download/00111/NEl/CurrentVersion.txt", $TempDir&"CheckUpdate.log", 1)
	$checkUpdateHandle = FileOpen( $TempDir&"CheckUpdate.log" )
	$currentVersionHandle = FileOpen( "CurrentVersion.txt" )
	$checkUpdateRead = FileReadLine( $checkUpdateHandle, 1 )
	$currentVersionRead = FileReadLine( $currentVersionHandle, 1 )

	if $currentVersionRead >= $checkUpdateRead Then
		;MsgBox( 0, "", "Latest Version")
		FileClose( $checkUpdateHandle )
		FileClose( $currentVersionHandle )
	Else
		;MsgBox( 0, "", "New Version Found"&@CRLF&"Current Version: "&$currentVersionRead&@CRLF&"New Version: "&$checkUpdateRead&@CRLF&"Download and Install?")
		$update = MsgBox( 4, "", "New Version Found! Download and Install?")
		if $update = 6 Then
			;ShellExecute( "LCN_Updater.exe", "", "", "", @SW_HIDE)
			Exit ;exit program so it can be rewritten
		EndIf
	EndIf
EndFunc
