-- p.49 ���̺� ����
-- ������ �ۼ� �� ��, F5 ����
-- SQL Developer (x), VS code | PyCharm | ��Ŭ���� ����
CREATE TABLE ex2_1 (
    COLUMN1 CHAR(10)
    , COLUMN2 VARCHAR2(10)
    , COLUMN3 NVARCHAR2(10)
    , COLUMN4 NUMBER
);

-- ������ �߰�
INSERT INTO ex2_1 (COLUMN1, COLUMN2) VALUES('abc', 'abc');

-- ������ Ȯ��
SELECT
    COLUMN1
    , LENGTH(COLUMN1) as len1
    , COLUMN2
    , LENGTH(COLUMN2) as len2
FROM ex2_1;

-- ���̺� ����
CREATE TABLE ex2_2(
    COLUMN1 VARCHAR2(3)
    , COLUMN2 VARCHAR2(3 byte)
    , COLUMN3 VARCHAR2(3 char)
);

-- ������ �߰�
INSERT INTO ex2_2 VALUES('abc', 'abc', 'abc');

-- ������ Ȯ��
SELECT COLUMN1
    , LENGTH(COLUMN1) AS len1
    , COLUMN2
    , LENGTH(COLUMN2) AS len2
    , COLUMN3
    , LENGTH(COLUMN3) AS len3
FROM ex2_2;

-- �ѱ� ������ ����
-- ���� �߻�
INSERT INTO ex2_2 VALUES ('ȫ�浿', 'ȫ�浿', 'ȫ�浿');

-- Column3���� ������ �߰�
INSERT INTO ex2_2 (COLUMN3) VALUES ('ȫ�浿');

-- ������ ��ȸ
SELECT COLUMN3
    , LENGTH(COLUMN3) AS len3
    , LENGTHB(COLUMN3) AS bytelen
FROM ex2_2;

-- ���� ������ ����
CREATE TABLE ex2_3 (
    COL_INT INTEGER
    , COL_DEC DECIMAL
    , COL_NUM NUMBER
);

SELECT
    COLUMN_ID
    , COLUMN_NAME
    , DATA_TYPE
    , DATA_LENGTH
FROM user_tab_cols
WHERE table_name = 'EX2_3'
ORDER BY COLUMN_ID;


CREATE TABLE ex2_4 (
    COL_FLOT1   FLOAT(32),
    COL_FLOT2   FLOAT
);


INSERT INTO ex2_4 (col_flot1, col_flot2) VALUES (1234567891234, 1234567891234);

-- ��ȸ
SELECT * FROM ex2_4;


-- p.58
-- ��¥ ������ Ÿ��
CREATE TABLE ex2_5(
    COL_DATE DATE
    , COL_TIMESTAMP TIMESTAMP
);

INSERT INTO ex2_5 VALUES (SYSDATE, SYSTIMESTAMP);

SELECT *
    FROM ex2_5;


-- LOB ������ Ÿ��
-- Large Object�� ���ڷ� ��뷮 �����͸� ������ �� �ִ� ������ Ÿ��
-- ������ �����ʹ� �� ũ�Ⱑ �ſ� ū��, �̷� �����͸� �����Ѵ�