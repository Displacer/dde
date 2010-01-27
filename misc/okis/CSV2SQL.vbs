Dim WHERE_WE
Set fso = CreateObject("Scripting.FileSystemObject")

HOST_EXE=Wscript.FullName
VBS=WScript.ScriptFullName
VBS=fso.GetFile(VBS).ShortPath


WHERE_WE=Replace(VBS,"\" & WScript.ScriptName,"")

WHERE_FILES=FOLDER_OPEN
If Len(WHERE_FILES)<>0 Then
   Set folder=fso.GetFolder(WHERE_FILES)
   If folder.Files.Count>0 Then
      For Each File In folder.Files
          If Mid(File.Name,1,3)="dde" Then FILE_IN_SQL File
      Next
   Else
      MsgBox "� ����� " & WHERE_FILES & vbCrLf & "��� ���������� ������"
   End IF
End If


Function FILE_IN_SQL(ByVal WHAT)
'Set fso = CreateObject("Scripting.FileSystemObject")
Set FILE = fso.OpenTextFile(WHAT, 1)
HEADER=FILE.ReadLine
HEADER_ARRAY=Split(HEADER,";")
If MsgBox("��� ��������� �������?" & vbCrLf & "(��������� ��� ������ ����������(����) �������� � ������� ����������� (;))" & vbCrLf & HEADER,vbYesNo,"���� " & WHAT)=vbYes Then
   For i=0 To Ubound(HEADER_ARRAY)
       HEADER_ARRAY(i)=Replace(HEADER_ARRAY(i),".","")
       HEADER_ARRAY(i)=Replace(HEADER_ARRAY(i)," ","_")                     
       HEADER_ARRAY(i)=Replace(HEADER_ARRAY(i),"-","_")
       HEADER_ARRAY(i)=Trim(HEADER_ARRAY(i))
       If Len(HEADER_ARRAY(i))=0 Then HEADER_ARRAY(i)="NPP" 
   Next
   HEADER=Join(HEADER_ARRAY,";")
  Else
   For i=0 To Ubound(HEADER_ARRAY)
       HEADER_NEW=HEADER_NEW  & ";�����" & i
   Next
   HEADER_NEW=Replace(HEADER_NEW,";","",1,1) & vbCrLF
   If MsgBox("����� ���������� ����� ��� ������" & vbCrLf & HEADER_NEW & "����������?",vbYesNo,"���������")=vbNo Then Exit Function
End If                  
Set TMP_FILE = fso.CreateTextFile(WHERE_WE & "\tmp.csv",True)
TMP_FILE.WriteLine(HEADER_NEW & HEADER)
For i=1 To 500
    On Error Resume Next
    TMP_FILE.WriteLine(FILE.ReadLine)
    If Err.Number<>0 Then Exit For
    If FILE.AtEndOfStream  Then Exit For
    On Error Goto 0
Next
TMP_FILE.Close
FILE.Close

Set cat_cnn=CreateObject("ADODB.Connection")
Set rst_cnn=CreateObject("ADODB.Connection")
Set rst=CreateObject("ADODB.Recordset")

Set cat=CreateObject("ADOX.Catalog")
Set tbl=CreateObject("ADOX.TABLE")
Set clm=CreateObject("ADOX.Column")
FN=Split(WHAT,"\")
TABLE=MAKE_SQL_NAME(FN(UBound(FN)))
'TABLE=InputBox("������� ��� ������� SQL",,TABLE)
If Len(TABLE)=0 Then 
   MsgBox "����������� ����������",0
   Exit Function
End If
TABLE=MAKE_SQL_NAME(TABLE)
rst_cnn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & WHERE_WE & ";Extended Properties=""text;HDR=Yes;FMT=Delimited(;)"""
cat_cnn.Open "File Name=" & WHERE_WE & "\QUIK.UDL"
WHERE_CSV = WHERE_WE & "\"
CSV = "TMP#CSV" 
sql = "SELECT * FROM [" & CSV & "]  IN '" & WHERE_CSV & "' [TEXT;HDR=Yes;FMT=Delimited(;);]"
rst.Open sql, rst_cnn, 3, 1
rst.MoveLast
If rst.RecordCount<1 Then
   MsgBox "��� ������������ ���-�� ����� � ����� " & vbCrLf & WHAT & vbCrLF & _
          "������� " & TABLE & " �� �������" 
   Exit Function
End If
Set cat.ActiveConnection = cat_cnn
On Error Resume Next
cat.TABLES.Delete TABLE
On Error GoTo 0
COLS=""
For Each fld In rst.fields
    COLS=COLS & ",[" & fld.Name & "] "
    Select Case fld.Type
           Case 7 'adDate
                COLS=COLS & " datetime"
           Case 5 'addouble
                COLS=COLS & " float"
           Case 3 'adInteger
                COLS=COLS & " float"
           Case 202 'adVarWChar
                COLS=COLS & " char(255)"
           Case 131 'adNumeric
                COLS=COLS & " float"
    End Select
    'If Instr(1,fld.Name,"����")>0 Then '������ ��� ���� ������������ �����
       'COLS=COLS & " float"
    'End If
Next
rst.Close
SQL="create table " & TABLE & "(" & Replace(COLS,",","",1,1) & ")"
cat_cnn.Execute SQL
If Err.Number<>0 Then 
   MsgBox "������� " & TABLE & " �� �������" & vbCrLf & err.Number & "-" & Err.Description,0
 Else
   MsgBox "������� " & TABLE  & " ������� ",0
End If 
cat_cnn.Close
rst_cnn.Close
End Function

Function MAKE_SQL_NAME(WHAT)
MAKE_SQL_NAME=Trim(WHAT)
MAKE_SQL_NAME=Replace(MAKE_SQL_NAME,".csv","")
MAKE_SQL_NAME=Replace(MAKE_SQL_NAME,".","_")
MAKE_SQL_NAME=Replace(MAKE_SQL_NAME,"!","")
MAKE_SQL_NAME=Replace(MAKE_SQL_NAME,"`","")
MAKE_SQL_NAME=Replace(MAKE_SQL_NAME,"'","")
MAKE_SQL_NAME=Replace(MAKE_SQL_NAME,"[","(")
MAKE_SQL_NAME=Replace(MAKE_SQL_NAME,"]",")")
For I=0 To 31
    MAKE_SQL_NAME=Replace(MAKE_SQL_NAME,chr(i),"")
Next
End Function

Function FOLDER_OPEN
FOLDER_OPEN=""
Set shell68=CreateObject("Shell.Application") 
On Error Resume Next
'Set folder = shell68.BrowseForFolder(0, "����� � ��", &H200 + &H10 + &H4000, WHERE_WE & "\ARXIV\" & Year(Date) & "\" & Month(Date) & "\" & Day(Date))
Set folder = shell68.BrowseForFolder(0, "����� � ��", &H200 + &H10 , WHERE_WE)
FOLDER_OPEN=folder.Self.Path
On Error GoTo 0
End Function

Function FILE_OPEN
Set DIALOG = CreateObject("UserAccounts.CommonDialog")
With DIALOG
     .Filter = "CSV �����|*.csv|��� �����|*.*"
     .FilterIndex = 1
     .InitialDir = "c:\"
     FILE_OPEN = .ShowOpen
     If FILE_OPEN = True Then FILE_OPEN=DIALOG.FileName
End With     

End Function
Function ASK(MENU,TITLE)
For Each Key In MENU
    ASK=ASK & Key & "-" & MENU(Key) & vbCrLf
Next
ASK=Left(ASK,Len(ASK)-1)
ASK=InputBox(ASK,TITLE, 0)
End Function
