#include <gtest/gtest.h>
#include <cstring>

#define GTEST_ON						// ������ ��� ��������� ����������� ������������

#include "command_line_parser.h"

// ���� ������������ � �����������
TEST(CommandLineParser, Constructor_with_parameters)
{
	std::string mas[] = {"excel", ";", "\n", ""};
	std::string str;

	// ��������� ������ ������� ��� �������� ������ ����������
	char *good1[] = {"dde"};
	CommandLineParser clp1(1, good1);	// ��������� ������ ��� ����������
	EXPECT_EQ(CML_OK,clp1.status);
	EXPECT_EQ(mas[0],clp1.service);
	EXPECT_EQ(mas[1],clp1.col_deliver);
	EXPECT_EQ(mas[2],clp1.row_deliver);
	EXPECT_EQ(mas[3],clp1.data_deliver);
	EXPECT_EQ(mas[3],clp1.topit_deliver);	

	// ��������� ������ � ����� ���������� -h
	char *good2[] = {"dde", "-h"};
	CommandLineParser clp2(2, good2);	// �������� ������� ������
	EXPECT_EQ(CML_HELP,clp2.status);

	char *good3[] = {"dde", "-h", "-f", ";"};
	char *good4[] = {"dde", "-n", ";", "-h"};
	CommandLineParser clp3(4, good3);	// ���������, ��� ��� ����� -h ������ �������� ������
	EXPECT_EQ(CML_HELP,clp3.status);
	CommandLineParser clp4(4, good4);	// ���������, ��� ��� ����� -h ������ �������� ������
	EXPECT_EQ(CML_HELP,clp4.status);

	char *good5[] = {"dde", "-s", "MyService", "-f", "++", "-n", "=-=", "-d", "------", "-t", ">>"};
	CommandLineParser clp5(11, good5);	// ��������� ��� ���� �������� ������
	EXPECT_EQ(CML_OK,clp5.status);
	str = good5[2];
	EXPECT_EQ(str,clp5.service);
	str = good5[4];
	EXPECT_EQ(str,clp5.col_deliver);
	str = good5[6];
	EXPECT_EQ(str,clp5.row_deliver);
	str = good5[8];
	EXPECT_EQ(str,clp5.data_deliver);
	str = good5[10];
	EXPECT_EQ(str,clp5.topit_deliver);

	CommandLineParser clp6(5, good5);				// ��������� ��� �� ���� �������� ������ (1)
	EXPECT_EQ(CML_OK,clp6.status);
	str = good5[2];
	EXPECT_EQ(str,clp6.service);
	str = good5[4];
	EXPECT_EQ(str,clp6.col_deliver);
	EXPECT_EQ(mas[2],clp6.row_deliver);
	EXPECT_EQ(mas[3],clp6.data_deliver);
	EXPECT_EQ(mas[3],clp6.topit_deliver);

	char *good6[] = {"dde", "-n", "---", "-t", "!!!"};
	CommandLineParser clp7(5, good6);				// ��������� ��� �� ���� �������� ������ (2)
	EXPECT_EQ(CML_OK,clp7.status);
	EXPECT_EQ(mas[0],clp7.service);
	EXPECT_EQ(mas[1],clp7.col_deliver);
	str = good6[2];
	EXPECT_EQ(str,clp7.row_deliver);
	EXPECT_EQ(mas[3],clp7.data_deliver);
	str = good6[4];
	EXPECT_EQ(str,clp7.topit_deliver);


	// ��������� ������ ������� ��� �������� �� ������� ���-�� ����������
	char *mas1[] = {"dde","your","-s","service_name"};
	CommandLineParser clp8(4, mas1);	// ����� ���������� ���� ������������ ������� (1)
	EXPECT_EQ(CML_HELP,clp8.status);	// ������� ������� ���������� ��������, ����� ��������

	char *mas2[] = {"dde","-n","\n","-f",";","notvalid"};
	CommandLineParser clp9(6, mas2);	// ����� ���������� ���� ������������ ������� (1)
	EXPECT_EQ(CML_HELP,clp9.status);	// ������� ������� ���������� ��������, ����� ��������

	char *mas3[] = {"dde","-n","\n","s","-f",";"};
	CommandLineParser clp10(6, mas3);	// ����� ���������� ���� ������������ ������� (2)
	EXPECT_EQ(CML_HELP,clp10.status);	// �������� -> ���������� -> �������� ��������

	char *mas4[] = {"dde","dss","sdfsd"};
	CommandLineParser clp11(3, mas4);	// ����� ���������� ���� ������������ ������� (3)
	EXPECT_EQ(CML_HELP,clp11.status);	// ��� ��������� �� ��������
}

// ���� ����������� ��� ����������
TEST(CommandLineParser, Constructor_without_parameters)
{
	CommandLineParser clp;
	std::string mas[] = {"excel", ";", "\n"};

	// ��������� ������ ������� ��� �������� ������ ����������
	EXPECT_EQ(CML_OK,clp.status);
	EXPECT_EQ(mas[0],clp.service);
	EXPECT_EQ(mas[1],clp.col_deliver);
	EXPECT_EQ(mas[2],clp.row_deliver);
}

// ���� ������� GetServiceName
TEST(CommandLineParser, GetServiceName)
{
	std::string str;
	CommandLineParser clp;
	str = "test1";
	clp.service = str;
	EXPECT_EQ(str, clp.GetServiceName());
	str = "XdVeLjYkwwfkfnlwfriuhffwfwef";
	clp.service = str;
	EXPECT_EQ(str, clp.GetServiceName());
}

// ���� ������� GetColDeliver
TEST(CommandLineParser, GetColDeliver)
{
	std::string str;
	CommandLineParser clp;
	str = "slalwjhwq1";
	clp.col_deliver = str;
	EXPECT_EQ(str, clp.GetColDeliver());
	str = "Xd333VeLjYkwfri323uhffw23fwef";
	clp.col_deliver = str;
	EXPECT_EQ(str, clp.GetColDeliver());
}

// ���� ������� GetRowDeliver
TEST(CommandLineParser, GetRowDeliver)
{
	std::string str;
	CommandLineParser clp;
	str = "slal___ ___wjhwq1";
	clp.row_deliver = str;
	EXPECT_EQ(str, clp.GetRowDeliver());
	str = "Xd333VeLjYds sdkwfrd i323uh ffw23fwef";
	clp.row_deliver = str;
	EXPECT_EQ(str, clp.GetRowDeliver());
}

// ���� ������� GetDataDeliver
TEST(CommandLineParser, GetDataDeliver)
{
	std::string str;
	CommandLineParser clp;
	str = "slal___ ___wjhwq1";
	clp.data_deliver = str;
	EXPECT_EQ(str, clp.GetDataDeliver());
	str = "Xd333VeLjYds sdkwfrd i323uh ffw23fwef";
	clp.data_deliver = str;
	EXPECT_EQ(str, clp.GetDataDeliver());
}

// ���� ������� GetTopItDeliver
TEST(CommandLineParser, GetTopItDeliver)
{
	std::string str;
	CommandLineParser clp;
	str = "slal___ ___wjhwq1";
	clp.topit_deliver = str;
	EXPECT_EQ(str, clp.GetTopItDeliver());
	str = "Xd333VeLjYds sdkwfrd i323uh ffw23fwef";
	clp.topit_deliver = str;
	EXPECT_EQ(str, clp.GetTopItDeliver());
}

// ���� ������� GetStatus
TEST(CommandLineParser, GetStatus)
{
	CommandLineParser clp;
	clp.status = CML_OK;
	EXPECT_EQ(CML_OK, clp.GetStatus());
	clp.status = CML_HELP;
	EXPECT_EQ(CML_HELP, clp.GetStatus());
}
