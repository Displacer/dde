'������
'����� � �����  ������� 
'-���(���� ���� �����) ��� ����� (TVS_A) 
'-��� ��� ���, ��� ������ ����� ������� � �� (TVS_F)
'-��� (������� ��� ����������) ��� ��� �������� (TIP_GAZ)
'-��� (������� ��� ����������) ��� ��� ���� (TIP_SBER)
'-�� (������� ������) (TS)
'-T� (������� ������) (TZ)
'-��� (���� ������� �� ������) (TLB)
'-��� (���� ��� ����������) (TTP)
'�������� 4 ��� ������� (����� ������) � �������
'ddeTVS,ddeGAZ,ddeSBER,ddeTABLES
'� ddeTVS �������� ������ �� TVS_A � TVS_F � � ���������� ����� ������� � ��
'  � �� �������������,
'  �� ���� ������ ����� � �������������
'� ddeGAZ � ddeSBER ������ TIP_GAZ � TIP_SBER � ����� �� �������������("������ ������")
'  � �� ������ �� ����� ��� ��� � ��� ��� ���� ��� ������ �� ����, 
'  �� ���� ������ ����� � ������� � ��
'� ddeTABLES TS,TZ,TLB,TTP � � ���������� ����� ������� � ��, 
'  � �� ����� �� �������������,
'  �� ���� ������ ����� � �������������
'��� ����� �������������? 
'������ ������� ������ �� ����� ������ 2 �����:
'1 � ����������� �� ��������� �������� ��� �� �������� ������ � ����� (SELF)
'  �������(�� ������) ���������(����� PIPE_EXE) ��������� ��� ����� � ��������� ��.
'  �� dde.vbs   
'2 ����� �������� ������ � ����� ������ � ������������ ������ ��������� (��� �� ���������
'  � ����������� �� ���������) ������ ������� (COM_EXE) ���������, ���� ��� �� ���� 
'  �������� ����� ��� ������� (�� �� ������, ��� ��� ������ ��� �������� �� ���������� � ���� 1), 
'  ���� ��� ���� �������� � ����������� �� ����� �� ����������. 
'  COM_EXE ���������� ������ �� ������ ����������� ������ ������ (���� 1) ��� ������ 
'  � ����� � ����� COM_EXE �� ���������� ��� ��� �� ��������.
'  ����� �������� �������� �� ������� ������� ��������� ������, �� ����������� ��, 
'  � � ���� �������� ��� ������� ��� ��� ��� �� ����� �������� ����� ���� ������ � ���
'  ��� ��� �� ��� ��� ������ �� ������� � ������ ������������, �� ��� �� ������ 
'  ��� ������ ���������� ���� �����������.
'  

Dim HTA,LOG,YAKOR
Dim IsLOG
Dim fso,WshShell

Set fso = CreateObject("Scripting.FileSystemObject")
Set WshShell = CreateObject ("WSCript.shell")

HOST_EXE=Wscript.FullName
VBS=WScript.ScriptFullName
Set VBS_FILE=fso.GetFile(WScript.ScriptFullName)
WHERE_WE=Replace(VBS_FILE.ShortPath,"\" &  VBS_FILE.ShortName,"")
WHERE_QUIK=fso.GetFolder(WHERE_WE).ParentFolder.ShortPath
Set VBS_FILE=Nothing

IsLOG=False

'��������, ��� �� �����, ������� ��� �����, �� �����
Set TESTME=CreateObject("Scripting.Dictionary")
TESTME(0)=WHERE_QUIK & "\info.exe" 
TESTME(2)=WHERE_WE   & "\LOG.HTA"
'TESTME(3)=WHERE_WE   & "\TRANS2QUIK.dll"
TESTME(4)=WHERE_WE   & "\FindHTA68.exe"
'TESTME(5)=WHERE_WE   & "\QUIK.mdb"
TESTME(7)=WHERE_WE   & "\dde.exe"
TESTME(8)=WHERE_WE   & "\DDE.wsc"
TESTME(9)=WHERE_WE   & "\DDE.vbs"
TESTME(10)=WHERE_WE   & "\QUIK.udl"
For Each Key In TESTME.Keys
    If Not fso.FileExists(TESTME(Key)) Then
       MsgBox "��� �����" & vbCrLf & TESTME(Key)
       Wscript.Quit
    End If
Next
Set TESTME=Nothing

'�������� ����������� � ��
On Error Resume Next
Set cnn=CreateObject("ADODB.Connection")
cnn.Open "File Name=" & WHERE_WE & "\QUIK.UDL"
If err.Number<>0 Then
   MsgBox "�� ������� ADODB.Connection" & vbCrLF & "��������� QUIK.udl"
   Wscript.Quit
End If
cnn.Close
Set cnn=Nothing
On Error GoTo 0
'�������� ��� ����
WshShell.Run WHERE_WE & "\FINDHTA68.EXE",0,True
Set LOG=Nothing
Set HTA = CreateObject("FindHTA68.HTA68")
Set LOG=HTA.START_HTA(WHERE_WE & "\LOG.HTA", "LOG")
If Not(LOG Is Nothing) Then IsLOG=True
Set YAKOR=LOG.frames("GRID").document.all("YAKOR") 
WriteLOG "������ ������..."

CreateArxiv("*")
Set P=CreateObject("Scripting.Dictionary")

'�������� 5 �������� ddeST,ddeTVS,ddeGAZ,ddeSBER,ddeTBL 
'
'ddeST
'����� ������� �����
'��� �������. �� ��� ������ ����� ����� ������� ������ �������
'������ ����� � ������ �����������. ��� ����� �������� ���� ������� � �����:
'��� ������������� ����:^$$^
'������ ����� � ����������� ����� ������:��(V)
'��������� ��������:�������,���� �������,���� �������,�������
'� ����� ��� ������ GAZ � ��������� ������ ��� ������ 
'DDE ������: ddeST
'������� �����:ST
'����:GAZ (��� ����� SBER)
'����� ����� ��������:��   [V]
'� ����������� �����:���   [ ]
'� ����������� ��������:���[ ]

SN="ddeST"          '��� �������    
P("SN")=SN
P("RN")=1           '���������� ����� ������   
StartDDE "wscript.exe " & WHERE_WE & "\DDE.VBS //D " & SN,P 'StartDDE ��� ����� �-�� �� ����


'ddeTVS ����� ������� �����
'� ����� ��� TVS_A � ��������� ������ ��� ������ 
'DDE ������: ddeTVS
'������� �����:TVS
'����:A
'����� ����� ��������:��  [V]
'� ����������� �����:��   [V]
'� ����������� ��������:��[V]
'[������ �����]
'� ����� ��� TVS_F � ��������� ������ ��� ������ 
'DDE ������: ddeTVS
'������� �����:TVS
'����:F
'����� ����� ��������:��  [V]
'� ����������� �����:��   [V]
'� ����������� ��������:��[V]
'[������ �����]
SN="ddeTVS"              '��� �������    
P("SN")=SN
P("RN")=0
P("T4A")="[TVS]F"
P("COM")="script:" & WHERE_WE & "\analys.wsc" '�� dde.wsc
StartDDE "wscript.exe " & WHERE_WE & "\DDE.VBS //D " & SN,P 'StartDDE ��� ����� �-�� �� ����

'ddeGAZ ����� ������� �����
'� ����� ��� TIP_GAZ � ��������� ������ ��� ������ 
'DDE ������: ddeGAZ
'������� �����:TIP
'����:GAZ
'����� ����� ��������:��  [V]
'� ����������� �����:��   [V]
'� ����������� ��������:��[V]
'[������ �����]
SN="ddeGAZ"           '��� �������    
P("SN")=SN   
P("T4A")="[TIP]GAZ"                           '[���_�������]���� ������ �� ���� ��������� ��� ����� ������� ���� �������������
P("COM")="script:" & WHERE_WE & "\analys.wsc" '�� dde.wsc
P("P")=""                                     '����� �� �����
StartDDE "wscript.exe " & WHERE_WE & "\DDE.VBS //D " & SN,P 'StartDDE ��� ����� �-�� �� ����

'ddeSBER ����� ������� �����
'� ����� ��� TIP_SBER � ��������� ������ ��� ������ 
'DDE ������: ddeSBER
'������� �����:TIP
'����:SBER
'����� ����� ��������:��  [V]
'� ����������� �����:��   [V]
'� ����������� ��������:��[V]
'[������ �����]
SN="ddeSBER"           '��� �������    
P("SN")=SN   
P("T4A")="[TIP]SBER"                          '[���_�������]���� ������ �� ���� ��������� ��� ����� ������� ���� �������������
P("COM")="script:" & WHERE_WE & "\analys.wsc" '�� dde.wsc
P("P")=""                                     '����� �� �����
StartDDE "wscript.exe " & WHERE_WE & "\DDE.VBS //D " & SN,P 'StartDDE ��� ����� �-�� �� ����

'ddeTBL ����� ������� �����
'� ����� ��� TC,��,���,��� � ��������� ������ ��� ������ 
'DDE ������: ddeTBL
'������� �����:TBL
'����:TS     (TZ ��� TZ,TTP ��� ��� ,TLB ��� ���)    
'����� ����� ��������:��  [V]
'� ����������� �����:��   [V]
'� ����������� ��������:��[V]
'[������ �����]
P.removeAll
SN="ddeTBL"              '��� �������    
P("SN")=SN
StartDDE "wscript.exe " & WHERE_WE & "\DDE.VBS //D " & SN,P 'StartDDE ��� ����� �-�� �� ����

WriteLOG "��������� " & WHERE_QUIK & "\info.exe (����)"
PID_QUIK=START_QUIK_EXE '��� ����� �-�� �� ����

'��������, ����� ���������� ����
Set WMI = GetObject("winmgmts:\\.\root\cimv2")
Set colProcesses = WMI.ExecNotificationQuery ("Select * From __InstanceDeletionEvent Within 1 Where TargetInstance ISA 'Win32_Process'")
Do Until i = 999
    Set objProcess = colProcesses.NextEvent
    If objProcess.TargetInstance.ProcessID = PID_QUIK Then
       Exit Do
    End If
Loop

'������ ����� ��� DDE.EXE
Set WMI = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2").ExecQuery("Select * from Win32_Process Where Name = 'dde.exe'")
For Each DDE_EXE in WMI
    DDE_EXE.Terminate
Next

Wscript.Quit

Function CreateArxiv(what_del)
'���� ����, �������� �������� �������
what=WHERE_WE & "\ARXIV" '���� ��� ���������� ���� ������
CreateIfNotExists what   '��� ����� �-�� �� ����
what=what & "\" & Year(Date)
CreateIfNotExists what
what=what & "\" & Month(Date) 
CreateIfNotExists what
what=what & "\" & Day(Date)
CreateIfNotExists what
'�������� ���� �� ��� csv �����
If fso.GetFolder(what).Files.Count > 0 Then
   On Error Resume Next
   fso.DeleteFile what & "\" & what_del & ".CSV"
   If Err.Number <> 53 And Err.Number <> 0 Then
      MsgBox Err.Number & "-" & Err.Description
      Wscript.Quit
   End If
End If
WriteLOG "����������� �������� ������� " & what   
End Function

Function CreateIfNotExists(what)
If Not (fso.FolderExists(what)) Then 
   fso.CreateFolder(what)
End If 
End Function

'������ ��� �������
Function StartDDE(WHAT_RUN,P)
'���������� ������ ���������� ����
' /SN=ddeTVS;/RN=1;...
For Each Key In P.Keys
    P_String=P_String &  ";" & Key & "=" & P(Key) 
Next
P_String=Mid(P_String,2)
'�������� 
WshShell.Run WHAT_RUN & " " & P_String,1,False
WriteLog "��������� " & WHAT_RUN  & " " & P_String
P.RemoveAll
End Function

'������ �����
Function START_QUIK_EXE
Set WMI = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2").ExecQuery("Select * from Win32_Process Where Name = 'info.exe'")
If WMI.Count=0 Then
   WshShell.CurrentDirectory = WHERE_QUIK
   QUIK_CMD = WHERE_QUIK & "\info.exe /i" '& App.Path & "\info.ini"
   START_QUIK_EXE=WshShell.Exec(QUIK_CMD).ProcessID
  Else
   For Each pr In WMI
       START_QUIK_EXE=pr.ProcessId
   Next
   Set pr=Nothing    
End If   
Set WMI=Nothing
End Function

'������ � ��� ����
Function WriteLOG(what)
On Error Resume Next
YAKOR.insertAdjacentText "BeforeEnd","[start.vbs]" & what & vbCrLf 
YAKOR.Document.Body.DoScroll
End Function
