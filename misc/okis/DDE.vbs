''���� ������ �������� DDE.EXE, ������ ����� ���������
''� �������� ����� DDE.EXE ������� �� � ����� ���������
''������ ��� �� ������� �� 2 �������� �����
''1 ����� ����������������
''2 ����� ������ ������, ������ (�������) � ������ ������
''��������� ���������
''������ ����� ��������� �� ������ ��� ����� �������  ���������� �� ����� �� ��� � �������
''[���_�������]���_�����=����1;����2;����3... ��� ;(�����������)=Chr(1), ��������,
''[TVS]FUCH=;����;�����;�����;��� ������;����;���-��
''[TVS]FUCH=1;28.01.2009;10:30:00;54652109;SiH9;34795;30
''[TVS]FUCH=2;28.01.2009;10:30:00;54652110;SiH9;34798;5
''[TVS]FUCH=3;28.01.2009;10:30:00;54652111;LKH9;11100;100
''������ ������ ���������, ���� �� ������� ����� � �����, ���� ������ ������ �� �������
''������ ����� - ��� ����� ������ ��������� ��� ������ � ������ ����� (����, �� ���)
''����� ���� ������� � ����������� ����� ������. ����� �� ��������� ������ �������� ������ �� �������
''������� ����������� ��� ������ ������, ��� ����� ���� analis.wsc, ��� ��� �� �������� ����������
''�� ���������� �������� ����� ������ �� �����.
''��� ������� DDE.EXE ����� ���� ���� DDE.VBS(��� ������ EXE)
''��� ���� ��� ����������� ����������� ������ ��������� � ��������� �������(��������) ������ �����
''��������, ������ ��  ������ ������ � ������ (��������) ������� ��������� � ���� ��� ������

Dim LOG,YAKOR
Dim IsLOG
Dim fso
Dim VALUES
Dim SN
''
''1 ����� ����������������
''
''���� ����� ��������� �� START.VBS
'"ddeTVS SN=ddeTVS;T=[TVS]1;COM=script:D:\Quik5\SERVER\analys.wsc;P=self"

If WScript.Arguments.Count<2 Then '������ ���� ���������
   MsgBox "������ ���� ����������  ���������. ����������� ����������!"
   Wscript.Quit
End If

SN=Trim(WScript.Arguments.Unnamed(0))

Set fso = CreateObject("Scripting.FileSystemObject")
Set WshShell = CreateObject ("WSCript.shell")

HOST_EXE=Wscript.FullName
VBS=WScript.ScriptFullName
Set VBS_FILE=fso.GetFile(WScript.ScriptFullName)
WHERE_WE=Replace(VBS_FILE.ShortPath,"\" &  VBS_FILE.ShortName,"")
WHERE_QUIK=fso.GetFolder(WHERE_WE).ParentFolder.ShortPath


IsLOG=True
On Error Resume Next
Set LOG = CreateObject("FindHTA68.HTA68").HTA("LOG") 
Set YAKOR=LOG.frames("GRID").document.all("YAKOR") 
If Err.Number<>0 Then IsLOG=False
On Error GoTo 0

WriteLOG "�������� DDE.VBS " & WScript.Arguments.Unnamed(0) & " " & WScript.Arguments.Unnamed(1)

''������������� � ��
Set cnn=CreateObject("ADODB.Connection")
cnn.Open "File Name=" & WHERE_WE & "\QUIK.UDL"
cnn.CursorLocation=3

Set dCMD = CreateObject("Scripting.Dictionary")

Set cat=CreateObject("ADOX.Catalog")
Set cat.ActiveConnection = cnn
'������ ���� ������� � ��
'�������� DDEServer_��������_��������
'         ddeTVS_TVS_F � �������� ��
For Each TBL In cat.Tables
    If InStr(1,TBL.Name,SN) Then 
       cnn.Execute "set ARITHABORT ON",&H80
       cnn.Execute "delete from " & TBL.Name,&H80
       Set dCMD(TBL.Name)=CreateObject("ADODB.Command") 
       WHATP=""
       COUNT=TBL.Columns.Count-1
       For i=0 To COUNT
           If InStr(1,cnn.Provider,".Jet.") Then 
              WHATP=WHATP & ",[@P" & i & "]"   '��� ��������� SQL ���
            Else
              If (cnn.Execute("SELECT COLUMNPROPERTY( OBJECT_ID('" & TBL.Name & "'),'" & TBL.Columns(i).Name & "','IsIdentity')").Fields(0).Value) + _
                 (cnn.Execute("SELECT COLUMNPROPERTY( OBJECT_ID('" & TBL.Name & "'),'" & TBL.Columns(i).Name & "','IsComputed')").Fields(0).Value)=0  Then
                  SQL="select isnull((select [VALUE] from ::fn_listextendedproperty(NULL,'user','dbo','table','" & TBL.Name & "','column','" & TBL.Columns(i).Name & "') as T where [name]='MS_Description'),'NULL')"
                  def=cnn.Execute(SQL).Fields(0).Value 
                  If def<>"~" Then
                     WHATP=WHATP & ",?"               '��� ��������� MS SQL 
                    Else
                     WHATP=WHATP & ",DEFAULT"
                  End If   
              End If 
           End If   
       Next
       WHATP=Replace(WHATP,",","",1,1)
       dCMD(TBL.Name).CommandType=1
       dCMD(TBL.Name).CommandText="insert into " & TBL.Name & " values(" & WHATP & ");"
       dCMD(TBL.Name).ActiveConnection = cnn
       dCMD(TBL.Name).Parameters.Refresh
       dCMD(TBL.Name).Prepared=True
    End if
Next
Set cat=Nothing

NOW_PATH = CreateArxiv
DELIMETER=Chr(1)
''
''����� 1-� �����
''

''
''������ 2� �����
''
Set DDE_EXE=WshShell.Exec(WHERE_WE & "\dde.exe " & WScript.Arguments(1) )
Do While Not DDE_EXE.StdOut.AtEndOfStream
     WHAT = DDE_EXE.StdOut.ReadLine
     ''������ 
     ''WHAT=[TVS]FUCH=1;28.01.2009;10:30:00;54652109;SiH9;34795;30
     ARR=Split(WHAT,"=",2)
     ''������
     ''ARR(0)=[TVS]FUCH
     ''ARR(1)=1;28.01.2009;10:30:00;54652109;SiH9;34795;30
     VALUES=Split(ARR(1),DELIMETER)
     ''������
     ''VALUES(0)=1
     ''VALUES(1)=28.01.2009
     ''......
     TABLE=Split(ARR(0),"]",2)
     TABLE(0)=Replace(TABLE(0),"[","",1,1)
     SQL_TABLE=SN & "_" & TABLE(0) & "_" & TABLE(1)
     ''������
     ''TABLE(0)=TVS
     ''TABLE(1)=F
     ''SQL_TABLE=ddeTVS_TVS_F
     On Error Resume Next  
        '���� ���� ������� � ��, �� ������� ������ � ������� �� SQL_TABLE    
        If dCMD.Exists(SQL_TABLE) Then
           dCMD(SQL_TABLE).Execute 0,VALUES,&h80
           If Err.Number<> 0 Then WriteERR2File NOW_PATH & "\ERR",ARR,Err.Number,ERR.DESCRIPTION
          Else '����� ������� � ����
           Write2File NOW_PATH & "\" & SQL_TABLE,VALUES
        End If
        '������ ��� � � ���� � ����� ������
        'Write2File NOW_PATH & "\" & SQL_TABLE,VALUES
     On Error GoTo 0 
     Set ARR=Nothing                    
Loop
''������� ����������
For Each Key In dCMD.Keys
    On Error Resume Next
    Set dCMD(Key)=Nothing
    On Error GoTo 0
Next
cnn.Close

Set dCMD=Nothing
Set LOG   = Nothing
Set YAKOR = Nothing

Function CreateArxiv
'���� ���� - �������� �������� �������
what=WHERE_WE & "\ARXIV" '���� ��� ���������� ������
CreateIfNotExists what
what=what & "\" & Year(Date)
CreateIfNotExists what
what=what & "\" & Month(Date) 
CreateIfNotExists what
what=what & "\" & Day(Date)
CreateIfNotExists what
CreateArxiv=what
End Function

Function CreateIfNotExists(what)
If Not (fso.FolderExists(what)) Then 
   fso.CreateFolder(what)
End If 
End Function

Function WriteERR2File(FILE_NAME,ARR,ERR_NUMBER,ERR_DESCRIPTION)
On Error Resume Next
With fso.OpenTextFile(FILE_NAME & ".csv",8,True)
     .WriteLine "(" &  Err_Number & ") " & Err_Description & ";" & ARR(0) & ";" & ARR(1)
     .Close
End With     
On Error GoTo 0
End Function

Function Write2File(FILE_NAME,VALUES)
On Error Resume Next
With fso.OpenTextFile(FILE_NAME & ".csv",8,True)
     .WriteLine Join(VALUES,";")
     If Err.Number<>0 Then WriteLOG Err.Number & "-" & Err.Description
     .Close
End With     
On Error GoTo 0
End Function

Function WriteLOG(what)
On Error Resume Next
YAKOR.insertAdjacentText "BeforeEnd","[dde.vbs/" & SN & "]" & what & vbCrLf 
YAKOR.Document.Body.DoScroll
End Function