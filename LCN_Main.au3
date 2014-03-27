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
#include "Include\Notify.au3"
#include "Include\AES.au3"


Opt("TrayAutoPause", 0)
TraySetIcon( "LCN.ico" )


; Register message for click event
_Notify_RegMsg()

; Set notification location
_Notify_Locate(0)

$sFrequency = ""

$confHandle = FileOpen("LCN.conf") ;load config settings from setup

If $confHandle = -1 Then
	$setup = MsgBox(4, "LCN Error", "An error has ccured opening config file. Would you like to run setup?")
	if $setup = "6" Then
		RunWait( "LCN_Gui.exe" )
		$confHandle = FileOpen("LCN.conf")
	Else
		Exit
	EndIf
EndIf

$confRead = FileRead($confHandle)
If $confRead = "" Then
	MsgBox(1, "LCN Error", "An error has ccured reading config file. Exiting!")
	Exit
EndIf

;class ID's:
$PSY = "9a5769f0-ac0a-4089-9ea7-9a922f94c295"
$ENG = "a3ba3bfc-8b74-4f86-8ef1-4576345b66ca"
$MAT = "cb60a800-503d-420e-bee2-b8a65cc9fcf2"
$PHI = "d16dfd79-74d2-4d46-a186-d38b157f1c8e"

$sPassword = ""
$sUsername = ""

;getRawHtml($ENG);runs .bat script to get info from LC
;getAnnouncements("Temp\Announcements.htm", "dataFile.txt");parses data into txt file
load();loads conf file

$count1 = 0

;$delay = 60*$sFrequency
$delay = 5 * $sFrequency ;for testing purposes

;start() ;runs check once

While 1 ;main background process
	If $count1 = $delay Then
		;MsgBox(1, "DEBUG", "HERE")
		getRawHtml();runs .bat script to get info from LC
		; $aDataHandle = FileOpen($aDataLocation)
		$aDataHandleWrite = FileOpen( "Temp\dataFile.txt", 10 )
		$aDataHandle = FileOpen( "Temp\dataFile.txt" )
		getAnnouncements("Temp\Announcements1.htm", "Temp\dataFile1.txt");parses data into txt file
		getAnnouncements("Temp\Announcements2.htm", "Temp\dataFile2.txt");parses data into txt file
		getAnnouncements("Temp\Announcements3.htm", "Temp\dataFile3.txt");parses data into txt file
		getAnnouncements("Temp\Announcements4.htm", "Temp\dataFile4.txt");parses data into txt file
		dataCombine("4");function that opens and combines X many files
		start()
		FileClose($aDataHandleWrite)
		FileClose($aDataHandle)
		$count1 = 0
	EndIf

	Sleep(1000)
	$count1 = $count1 + 1
WEnd


Func start()
	$aDataBuffer = FileReadLine($aDataHandle, 1); read first line to see if theres an announcements
	$AnnouncementLogHandleRead = FileOpen("Temp\DisplayedAnnouncements.log", 8)
	$AnnouncementLogHandleWrite = FileOpen("Temp\DisplayedAnnouncements.log", 9)
	If $aDataBuffer = "" Then ;start while to read data if not empty
		$loop = 0
	Else
		$loop = 1
		$count = 1
		$AnnouncementLog = FileRead($AnnouncementLogHandleRead)
		While $loop
			$aDataID = FileReadLine($aDataHandle, $count)
			$count = $count + 1;2
			$aDataAuthor = FileReadLine($aDataHandle, $count)
			$count = $count + 1;3
			$aDataDate = FileReadLine($aDataHandle, $count)
			$count = $count + 1;4
			$aDataText = FileReadLine($aDataHandle, $count)
			$count = $count + 1;5

			;$aDataIDSplit = StringSplit($aDataID, "-")
			;MsgBox( 1, "", $aDataID)
			;MsgBox( 1, "", $AnnouncementLog)
			$AnnouncementLogCheck = StringInStr($AnnouncementLog, $aDataID)
			;MsgBox( 1, "DEBUG", $aDataID & @CRLF & $aDataID)
			;MsgBox( 1, "DEBUG", $AnnouncementLogCheck)
			If $aDataID = "" Then
				$loop = 0
				$AnnouncementLogCheck = ""
				$AnnouncementLog = ""
			Else
				If $AnnouncementLogCheck = 0 Then ;check to see if notification has already been displayed for thsi announcement
					If FileReadLine($aDataHandle, $count) = "" Then ;no more notifications??
						$loop = 0
						$AnnouncementLogCheck = ""
						$AnnouncementLog = ""

					EndIf
					FileWriteLine($AnnouncementLogHandleWrite, $aDataID)
					Notify($aDataAuthor & " -- " & $aDataDate, $aDataText)

				EndIf
			EndIf
		WEnd
	EndIf

	FileClose($AnnouncementLogHandleRead)
	FileClose($AnnouncementLogHandleWrite)

EndFunc   ;==>start

Func dataCombine($fileCount)
Local $aDataHandle1 = FileOpen("Temp\dataFile1.txt")
Local $aDataHandle2 = FileOpen("Temp\dataFile2.txt")
Local $aDataHandle3 = FileOpen("Temp\dataFile3.txt")
Local $aDataHandle4 = FileOpen("Temp\dataFile4.txt")

$aDataRead1 = FileRead( $aDataHandle1 )
$aDataRead2 = FileRead( $aDataHandle2 )
$aDataRead3 = FileRead( $aDataHandle3 )
$aDataRead4 = FileRead( $aDataHandle4 )


$aDataRead = FileRead( $aDataHandleWrite )
$aDataRead = $aDataRead1 & $aDataRead2 & $aDataRead3 & $aDataRead4
FileWrite( $aDataHandleWrite, $aDataRead )

FileClose( $aDataHandle1 )
FileClose( $aDataHandle2 )
FileClose( $aDataHandle3 )
FileClose( $aDataHandle4 )

EndFunc

Func Notify($Title, $Text)
	_Notify_Set(0, Default, 0x7EBEE9, "Arial", True, 750, 250)
	_Notify_Show("LCN.ico", $Title, $Text)
EndFunc   ;==>Notify

Func getRawHtml()
	;RunWait( "1st_Final_step.bat" )
	;$classID = ""
	;MsgBox(1, "1", $classID)
	;MsgBox( 1, "DEBUG", $ENG & @CRLF & $PSY & @CRLF & $PHI & @CRLF & $MAT & @CRLF & $sUsername & @CRLF & $sPassword )
	ShellExecuteWait(@ScriptDir & "\Fetch_Announcements.bat", $PSY & " " & $ENG & " " & $MAT & " " & $PHI & " " & $sUsername & " " & $sPassword, "", "", @SW_HIDE)

EndFunc   ;==>getRawHtml

Func getAnnouncements($htmFile, $dataFile)
	$Announcements = FileOpen($htmFile) ;open announcements file
	;$tOpenAnnouncements = FileOpen( "Temp\tAnnouncements.htm", 10 ) ;open temp txt for data processing
	$txtOpenAnnouncements = FileOpen($dataFile, 10) ;open file for finished processing
	$R_Announcements = FileRead($Announcements)

	$aBlocks = _StringBetween2($R_Announcements, "<table", "</table>") ;find table of info
	;MsgBox(1, "Debug2", $aBlocks)
	;FileWrite($tOpenAnnouncements,$aBlocks) ;write data into processing file
	$a1 = StringInStr($aBlocks, "</tr>") ;find where actual info starts
	$aBlocksSplit = StringTrimLeft($aBlocks, $a1) ;trim unneeded header

	$a1 = StringInStr($aBlocks, "<tr  id=") ;find where actual info starts

	$loop = 1
	While $loop

		If $a1 = 0 Then
			;MsgBox(1, "IF", "ERROR No Announcements")
			;Exit
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

		;$a2 = StringInStr( $aBlocksSplit , "</td>")
		;$aBlocksSplit = StringTrimLeft( $aBlocksSplit, $a2 )

		If StringInStr($aBlocksSplit, "<tr  id=") = 0 Then $loop = 0 ;find if there are more annoucments

		;MsgBox(1, "", $aAuthor)
		;MsgBox(1, "", $aDate)
		;MsgBox(1, "", $aID)
		;MsgBox(1, "", $aText)

		FileWriteLine($txtOpenAnnouncements, $aID)
		FileWriteLine($txtOpenAnnouncements, $aAuthor)
		FileWriteLine($txtOpenAnnouncements, $aDate)
		FileWriteLine($txtOpenAnnouncements, $aText)

		;_ArrayDisplay($String)
	WEnd

	FileClose($Announcements)
	FileClose($txtOpenAnnouncements)
EndFunc   ;==>getAnnouncements

Func _StringBetween2($s, $from, $to)
	$x = StringInStr($s, $from) + StringLen($from)
	$y = StringInStr(StringTrimLeft($s, $x), $to)
	Return StringMid($s, $x, $y)
EndFunc   ;==>_StringBetween2

Func load()
	Local $readBuffer = ""
	$random = FileReadLine($confHandle, 8) ;random
	$readBuffer = FileReadLine($confHandle, 2) ;username
	;MsgBox(1 ,"DEBUGGER",$readBuffer)
	$sUsername = _AesDecrypt($random, $readBuffer)
	$sUsername = BinaryToString($sUsername)
	;$sUsername = $readBuffer
	;MsgBox(1 ,"DEBUGGER",$sUsername)
	$readBuffer = FileReadLine($confHandle, 3) ;pass
	;MsgBox(1 ,"DEBUGGER",$readBuffer)
	$sPassword = _AesDecrypt($random, $readBuffer)
	$sPassword = BinaryToString($sPassword)
	;$sPassword = $readBuffer
	;MsgBox(1 ,"DEBUGGER",$sPassword)

	$sFrequency = FileReadLine($confHandle, 4)
	;if $sFrequency = "" Then $sFrequency = "1"
	$s_cOn = FileReadLine($confHandle, 5)
	$s_eOn = FileReadLine($confHandle, 6)
	$s_Ln_aOn = FileReadLine($confHandle, 7)
	FileClose($confHandle)
EndFunc   ;==>load
