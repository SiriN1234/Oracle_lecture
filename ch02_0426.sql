-- p.59~
-- NOT NULL
-- 제약조건

CREATE TABLE ex2_6(
    COL_NULL VARCHAR2(10)
    , COL_NOT_NULL VARCHAR2(10) NOT NULL
);

INSERT INTO ex2_6 VALUES ('AA', '');
INSERT INTO ex2_6 VALUES ('AA', 'BB');

SELECT * FROM ex2_6;

-- USER CONSTRAINTS 제약 조건 확인
SELECT constraint_name, constraint_type, table_name, search_condition
 FROM user_constraints
WHERE table_name = 'EX2_6';

CREATE TABLE ex2_7(
    COL_UNIQUE_NULL VARCHAR2(10) UNIQUE
    , COL_UNIQUE_NNULL VARCHAR2(10) UNIQUE NOt NULL
    , COL_UNIQUE VARCHAR2(10)
    , CONSTRAINTS unique_nm1 UNIQUE (COL_UNIQUE)
);

SELECT constraint_name, constraint_type, table_name, search_condition
 FROM user_constraints
WHERE table_name = 'EX2_7';

INSERT INTO ex2_7 VALUES ('AA', 'AA', 'AA');
SELECT * FROM ex2_7;

INSERT INTO ex2_7 VALUES ('AA', 'AA', 'AA');

INSERT INTO ex2_7 VALUES ('', 'BB', 'BB');
SELECT * FROM ex2_7;

INSERT INTO ex2_7 VALUES ('', 'CC', 'CC');
SELECT * FROM ex2_7;


-- 기본키 (p.63)
CREATE TABLE ex2_8 (
    COL1 VARCHAR2(10) PRIMARY KEY
    , COL2 VARCHAR2(10)
);

SELECT constraint_name, constraint_type, table_name, search_condition
 FROM user_constraints
WHERE table_name = 'EX2_8';

INSERT INTO ex2_8 VALUES ('', 'AA');
INSERT INTO ex2_8 VALUES ('AA', 'AA');
SELECT * FROM ex2_8;

INSERT INTO ex2_8 VALUES ('AA', 'AA');
-- ORA-00001: 무결성 제약 조건(ORA_USER.SYS_C007492)에 위배됩니다


-- CHECK
CREATE TABLE ex2_9 (
    num1     NUMBER 
        CONSTRAINTS check1 CHECK ( num1 BETWEEN 1 AND 9),
    gender   VARCHAR2(10) 
        CONSTRAINTS check2 CHECK ( gender IN ('MALE', 'FEMALE'))        
); 

SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_9';
 
INSERT INTO ex2_9 VALUES (10, 'MAN');

INSERT INTO ex2_9 VALUES (5, 'FEMALE');

-- DEFAULT 

CREATE TABLE ex2_10 (
   Col1        VARCHAR2(10) NOT NULL, 
   Col2        VARCHAR2(10) NULL, 
   Create_date DATE DEFAULT SYSDATE);
   
INSERT INTO ex2_10 VALUES ('AA', 'AA'); 

SELECT *
FROM ex2_10;

-- DEFAULT 
DROP TABLE ex2_10;
CREATE TABLE ex2_10 (
   Col1        VARCHAR2(10) NOT NULL, 
   Col2        VARCHAR2(10) NULL, 
   Create_date DATE DEFAULT SYSDATE);
   
-- Col1 Col2 사용자가 입력
-- Create_Date DB에서 자동으로 입력
INSERT INTO ex2_10 (col1, col2) VALUES ('AA', 'BB');

SELECT * FROM ex2_10;  

-- DEFAULT
-- PL/SQL
DROP TABLE ex2_1;
DROP TABLE ex2_2;
DROP TABLE ex2_3;
DROP TABLE ex2_4;
DROP TABLE ex2_5;
DROP TABLE ex2_6;
DROP TABLE ex2_7;
DROP TABLE ex2_8;
DROP TABLE ex2_9;
DROP TABLE ex2_10;

-- 어떻게해야 한번에 지울 수 있을까


-- 테이블 변경 (p.68)
-- (1) 컬럼명 변경
ALTER TABLE ex2_10 RENAME COLUMN Col1 TO Col11;
SELECT * FROM ex2_10;

DESC ex2_10;
-- pandas의 info와 같은 기능

-- (2) 컬럼 타입 변경
-- 컬럼 타입 변경 (VARCHAR2(10) -> VARCHAR2(30))으로 변경
ALTER TABLE ex2_10 MODIFY Col2 VARCHAR2 (30);
DESC ex2_10;

-- (3) col3 NUMBER 타입으로 신규 생성
ALTER TABLE ex2_10 ADD Col3 NUMBER;
DESC ex2_10;

-- (4) 컬럼삭제
ALTER TABLE ex2_10 DROP COLUMN Col3;
DESC ex2_10;

-- (5) 제약조건 추가
ALTER TABLE ex2_10 ADD CONSTRAINTS pk_ex2_10 PRIMARY KEY (col11);

-- USER CONSTRAINTS 제약 조건 확인
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_10';

-- (6) 제약조건 삭제
ALTER TABLE ex2_10 DROP CONSTRAINTS pk_ex2_10;

-- USER CONSTRAINTS 제약 조건 확인
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_10';
 
 
-- 테이블 복사
-- p.72
CREATE TABLE ex2_9_1 AS SELECT * FROM ex2_9;

SELECT * FROM ex2_9_1;

-- 뷰 (VIEW)
-- 테이블이랑 비슷
SELECT
    a.employee_id
    , a.emp_name
    , a.department_id -- 부서명 칼럼
    , b.department_name
FROM
    employees a,
    departments b
WHERE a.department_id = b.department_id;

CREATE OR REPLACE VIEW emp_dept_v1 AS
SELECT
    a.employee_id
    , a.emp_name
    , a.department_id -- 부서명 칼럼
    , b.department_name
FROM
    employees a,
    departments b
WHERE a.department_id = b.department_id;

SELECT * FROM emp_dept_v1;


-- 인덱스 생성
-- 추후 공부해야 할 내용 - 인덱스 내부 구보에 따른 분류
-- (초중급 레벨) B-Tree 인덱스, 비트맵 인덱스, 함수 기반 인덱스
-- DB 성능과 관련이 있음
-- col11 값에 중복 값을 허용하지 않는다
-- 인덱스 생성 시, user_indexes 시스템 뷰에서 내역 확인
CREATE UNIQUE INDEX ex_10_ix01
ON ex2_10(col11);

SELECT index_name, index_type, table_name, uniqueness
 FROM user_indexes
WHERE table_name = 'EX2_10';


-- p.90 테이블 1, 2, 3번 생성
-- 1번
CREATE TABLE ORDERS (
    ORDER_ID NUMBER(12, 0) PRIMARY KEY
    , ORDER_DATE DATE
    , ORDER_MODE VARCHAR2(8 BYTE) CHECK (ORDER_MODE IN ('direct', 'online'))
    , CUSTOMER_ID NUMBER(6, 0)
    , ORDER_STATUS NUMBER(2, 0)
    , ORDER_TOTAL NUMBER(8, 2) DEFAULT 0
    , SALES_REP_ID NUMBER(6, 0)
    , PROMOTION_ID NUMBER(6, 0)
);
/*
, CONSTRAINT PK_ORDER PRIMARY KEY (ORDER_ID)
, CONSTRAINT CK_ORDER_MODE CHECK (ORDER_MODE in ('direct', 'online'))
제약 조건을 이렇게 쓸 수도 있다
*/

DESC ORDERS;

SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'ORDERS';


-- 2번
CREATE TABLE ORDER_ITEMS (
    ORDER_ID        NUMBER(12, 0)
    , LINE_ITEM_ID  NUMBER(3, 0)
    , PRODUCT_ID    NUMBER(3, 0)
    , UNIT_PRICE    NUMBER(8, 2) DEFAULT 0
    , QUANTITY  NUMBER(8, 0) DEFAULT 0
    , CONSTRAINT PK_ORDER_ITEMS PRIMARY KEY (ORDER_ID, LINE_ITEM_ID)
);

DESC ORDER_ITEMS;

SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'ORDER_ITEMS';
 

-- 3번
CREATE TABLE PROMOTIONS (
    PROMO_ID        NUMBER(6, 0) PRIMARY KEY
    , PROMO_NAME    VARCHAR2(20)
);

DESC PROMOTIONS;

SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'PROMOTIONS';