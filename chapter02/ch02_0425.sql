-- p.49 테이블 생성
-- 쿼리를 작성 한 후, F5 실행
-- SQL Developer (x), VS code | PyCharm | 이클립스 연동
CREATE TABLE ex2_1 (
    COLUMN1 CHAR(10)
    , COLUMN2 VARCHAR2(10)
    , COLUMN3 NVARCHAR2(10)
    , COLUMN4 NUMBER
);

-- 데이터 추가
INSERT INTO ex2_1 (COLUMN1, COLUMN2) VALUES('abc', 'abc');

-- 데이터 확인
SELECT
    COLUMN1
    , LENGTH(COLUMN1) as len1
    , COLUMN2
    , LENGTH(COLUMN2) as len2
FROM ex2_1;

-- 테이블 생성
CREATE TABLE ex2_2(
    COLUMN1 VARCHAR2(3)
    , COLUMN2 VARCHAR2(3 byte)
    , COLUMN3 VARCHAR2(3 char)
);

-- 데이터 추가
INSERT INTO ex2_2 VALUES('abc', 'abc', 'abc');

-- 데이터 확인
SELECT COLUMN1
    , LENGTH(COLUMN1) AS len1
    , COLUMN2
    , LENGTH(COLUMN2) AS len2
    , COLUMN3
    , LENGTH(COLUMN3) AS len3
FROM ex2_2;

-- 한글 데이터 삽입
-- 에러 발생
INSERT INTO ex2_2 VALUES ('홍길동', '홍길동', '홍길동');

-- Column3에만 데이터 추가
INSERT INTO ex2_2 (COLUMN3) VALUES ('홍길동');

-- 데이터 조회
SELECT COLUMN3
    , LENGTH(COLUMN3) AS len3
    , LENGTHB(COLUMN3) AS bytelen
FROM ex2_2;

-- 숫자 데이터 삽입
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

-- 조회
SELECT * FROM ex2_4;


-- p.58
-- 날짜 데이터 타입
CREATE TABLE ex2_5(
    COL_DATE DATE
    , COL_TIMESTAMP TIMESTAMP
);

INSERT INTO ex2_5 VALUES (SYSDATE, SYSTIMESTAMP);

SELECT *
    FROM ex2_5;


-- LOB 데이터 타입
-- Large Object의 약자로 대용량 데이터를 저장할 수 있는 데이터 타입
-- 비정형 데이터는 그 크기가 매우 큰데, 이런 데이터를 저장한다