#include <gtest/gtest.h>

#define GTEST_ON		// �������� ����������� ������������ �����

#include "XlTable.h"

// ���� �����������
TEST(XlTable, Constructor)
{
	XlTable xlt;

	ASSERT_EQ(true,xlt.table_data.empty());
	ASSERT_EQ(0,xlt.row);
	ASSERT_EQ(0,xlt.col);
	ASSERT_EQ(true,xlt.row_deliver.empty());
	ASSERT_EQ(true,xlt.row_deliver.empty());
}

// ���� ������� IsData
TEST(XlTable, IsData)
{
	XlTable xlt;
	vector<string> v;

	EXPECT_EQ(false,xlt.IsData());				// ����� ������ ������������ ������� ������ ���� ������

	v.push_back("row1 col1");
	v.push_back("row1 col2");
	xlt.table_data.push_back(v);				// ���� ������� �������� ������, �� ���-�� ����� ����� 0
	xlt.row = 0;
	xlt.col = 2;
	EXPECT_EQ(false,xlt.IsData());

	xlt.row = 1;								// ��� ���������
	EXPECT_EQ(true,xlt.IsData());

	xlt.row = 2;								// ���-�� ����� �� ������������� ����������������
	EXPECT_EQ(false,xlt.IsData());

	v.clear();
	v.push_back("row2 col1");
	v.push_back("row2 col2");
	xlt.table_data.push_back(v);

	xlt.col = 3;								// ���-�� �������� �� ������������� ����������������
	EXPECT_EQ(false,xlt.IsData());

	xlt.col = 2;								// ��� ���������
	EXPECT_EQ(true,xlt.IsData());

	xlt.col = 0;								// ���� ������� �������� ������, �� ���-�� �������� ����� 0
	EXPECT_EQ(false,xlt.IsData());

	xlt.table_data.pop_back();					// ���� ������� �����, �� ���-�� ����� � ���-�� �������� ������� �� ����
	xlt.table_data.pop_back();
	EXPECT_EQ(false,xlt.IsData());
}

// ���� ������� InitTable
TEST (XlTable, InitTable)
{
	XlTable xlt;
	string str = "TeSt";
	xlt.InitTable(3,4,str);
	ASSERT_EQ(3,xlt.row);
	ASSERT_EQ(4,xlt.col);
	for (int i = 0; i < 3; i++)
		for (int j = 0; j < 4; j++)
			ASSERT_EQ(str, xlt.table_data[i][j]);
}

// ���� ������� Delete
TEST (XlTable, Delete)
{
	XlTable xlt;
	xlt.InitTable(4,4,"nnn");
	xlt.Delete();
	EXPECT_EQ(0,xlt.row);
	EXPECT_EQ(0,xlt.col);
	EXPECT_EQ(true,xlt.table_data.empty());
}

// ���� ������� SetDelivers
TEST(XlTable, SetDelivers)
{
	XlTable xlt;
	string str_row = "..sdf";
	string str_col = "sdsdsd sd";
	string str_data = "HKJjhjhkhjk";
	string str_topit = "����������";
	xlt.SetDelivers(str_row, str_col, str_data, str_topit);
	EXPECT_EQ(str_row, xlt.row_deliver);
	EXPECT_EQ(str_col, xlt.col_deliver);
	EXPECT_EQ(str_data, xlt.data_deliver);
	EXPECT_EQ(str_topit, xlt.topit_deliver);

	str_row = "";
	str_col = "___";
	str_data = "���������";
	str_topit = "����������";
	xlt.SetDelivers(str_row, str_col, str_data, str_topit);
	EXPECT_EQ(str_row, xlt.row_deliver);
	EXPECT_EQ(str_col, xlt.col_deliver);
	EXPECT_EQ(str_data, xlt.data_deliver);
	EXPECT_EQ(str_topit, xlt.topit_deliver);
}

// ���� ������� DoubleToString
TEST(XlTable, DoubleToString)
{
	XlTable xlt;
	double dbl = 1.2;
	string str = "1.2";
	EXPECT_EQ(str,xlt.DoubleToString(dbl));

	dbl = 0.00001;
	str = "0.00001";
	EXPECT_EQ(str,xlt.DoubleToString(dbl));

	dbl = 103430;
	str = "103430";
	EXPECT_EQ(str,xlt.DoubleToString(dbl));

	dbl = 0.103430;
	str = "0.10343";
	EXPECT_EQ(str,xlt.DoubleToString(dbl));

	dbl = 0.100004;
	str = "0.100004";
	EXPECT_EQ(str,xlt.DoubleToString(dbl));

	dbl = 1001.1001;
	str = "1001.1001";
	EXPECT_EQ(str,xlt.DoubleToString(dbl));

	dbl = .2003;
	str = "0.2003";
	EXPECT_EQ(str,xlt.DoubleToString(dbl));

	dbl = 0.;
	str = "0";
	EXPECT_EQ(str,xlt.DoubleToString(dbl));
}

// ���� ������� GetBuf
TEST(XlTable, GetBuf)
{
	XlTable xlt;
	string topit = "Topic[item]";
	xlt.GetBuf(topit);
	EXPECT_EQ(topit, xlt.buf);
	topit = "[������]�����";
	xlt.GetBuf(topit);
	EXPECT_EQ(topit, xlt.buf);
}