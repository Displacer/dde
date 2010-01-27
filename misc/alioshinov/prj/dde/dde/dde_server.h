/*
����� DDE ������������ ����� �������� DDE-�������.
�� ������������ ��� ��������, �������� �������, �������� ���������� ������
*/
#ifndef DDE_SERVER_H_
#define DDE_SERVER_H_

#include <windows.h>
#include <cstring>
#include <ddeml.h>
#include "XlTable.h"

//��������� �� ������� ��������� ������
typedef HDDEDATA (CALLBACK *CallBack) (UINT uType,	UINT uFmt, HCONV hConv,	HSZ hsz1, HSZ hsz2, 
												HDDEDATA hData, DWORD dwData1, DWORD dwData2);	

class DDE
{
public:
	#ifdef GTEST_ON	// ���� ��������� ������ GTEST_ON, �� �������� ���������� ������
	FRIEND_TEST(DdeServer, Constructor_with_parameters);	// ���� ������������ � �����������
	FRIEND_TEST(DdeServer, Constructor_without_parameters);	// ���� ������������ ��� ����������
	FRIEND_TEST(DdeServer, DdeInit);						// ���� ������� DdeInit
	#endif
	DDE(std::string service);				// ���������� � ����������. 
	DDE();									// ���������� ��� ����������.
	~DDE();                                 // ����������. ����������� �������, ������� ��������                            
	void DdeInit(std::string service);		// ������� ������������� 	
	bool Connect(CallBack DdeCallback);		// ������� ������������ ������ � DDEML ���������� � �������� �������������
    void Disconnect();                      // ������� �������� ����������� ������� � ���������� DDEML        
	HSZ GetName();							// ������� ���������� ��� ������������������� �������
	DWORD GetId();							// ������� ���������� ������������� ������������������� �������
	XlTable xltable;						// ������, ���������� ��������
private:
	std::string chService;                  // ������ ��� �������                           
	DWORD idInst;							// ������������� ������������������� ����������
	HSZ hszService;                         // ������������� �������
};

#endif // DE_SERVER_H_
