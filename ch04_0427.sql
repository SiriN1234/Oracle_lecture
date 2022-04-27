-- SQL 함수 살펴보기
-- ABS(n) : 절대값 반환하는 함수
SELECT
    ABS(10)
    , ABS(10.123)
    , ABS(-10)
    , ABS(-10.123)
FROM DUAL;


-- CEIL & FLOOR
-- CEIL : 올림
-- FLOOR : 버림
SELECT
    CEIL(10.123)
    , CEIL(-10.123)
    , FLOOR(10.123)
    , FLOOR(-10.123)
FROM DUAL;


-- ROUND & TRUNC (n1, n2)
-- ROUND : 반올림
SELECT
    ROUND(10.154)
    , ROUND(10.151)
    , ROUND(11.001)
    , ROUND(-10.154)
    , ROUND(-10.151)
    , ROUND(-11.001)
FROM DUAL;


SELECT
    ROUND(10.154, 1)
    , ROUND(10.151, 2)
    , ROUND(-10.154, 1)
    , ROUND(-10.151, 2)
FROM DUAL;

SELECT
    ROUND(0, 3)
    , ROUND(115.155, -1) -- 1의 자리에서 반올림
    , ROUND(115.155, -2) -- 10의 자리에서 반올림
FROM DUAL;


-- TRUNC
-- 반올림 안함, 소수점 절삭
SELECT
    TRUNC(115.155)
    , TRUNC(115.155, 1)
    , TRUNC(115.155, 2)
    , TRUNC(115.155, -2)
FROM DUAL;


-- POWER (n2, n1) SQRT(n)
-- 제곱 & 제곱근
SELECT
    POWER(3, 2)
    , POWER(3, 3)
    , SQRT(9)
    , SQRT(8)
FROM DUAL;


-- MOD(n2, n1)와 REMAINDER(n2, n1)
-- MOD 함수는 n2를 n1으로 나눈 나머지 값 반환
SELECT
    MOD(19, 4)
    , REMAINDER(19, 4)
FROM DUAL;

-- EXP, LN, LOG
SELECT
    EXP(2)
    , LN(2.713)
    , LOG(10, 100)
FROM DUAL;


-- 문자 함수
-- CONCAT : '||' 연산자처럼 두 문자를 붙여 반환
SELECT
    CONCAT('I Have', 'A Dream'),
    'I Have' || 'A Dream'
FROM DUAL;


-- SUBSTR (**** 중요함 ****)
-- 문자 개수 단위로 문자열을 자름
SELECT
    SUBSTR('ABCDEFG', 1, 4)
    , SUBSTR('ABCDEFG', -6, 4)
FROM DUAL;

-- SUBSTRB
-- 문자열의 바이트 수만큼 자름
SELECT
    SUBSTRB('ABCDEFG', 1, 4)
    , SUBSTRB('가나다라마바사', 1, 4)
FROM DUAL;


-- LTRIM(char, set), RTRIM(char, set)
SELECT
    LTRIM('ABCDEFGABC', 'ABC')
    , LTRIM('가나다라', '가')
    , RTRIM('ABCDEFGABC', 'ABC')
    , RTRIM('가나다라', '다라')
FROM DUAL;


-- LPAD, RPAD
-- 무언가를 입력해준다
CREATE TABLE ex4_1 (
    phone_num   VARCHAR2(30)
);

INSERT INTO ex4_1 VALUES('111-1111');
INSERT INTO ex4_1 VALUES('111-2222');
INSERT INTO ex4_1 VALUES('111-3333');

SELECT * FROM ex4_1;

SELECT
    LPAD(phone_num, 12, '(02)')
    , RPAD(phone_num, 12, '(02)')
FROM ex4_1;


-- 날짜 함수 (p.138)
SELECT
    SYSDATE
    , SYSTIMESTAMP
FROM DUAL;
    

-- ADD_MONTHS
SELECT
    ADD_MONTHS(SYSDATE, 1)
    , ADD_MONTHS(SYSDATE, -1)
FROM DUAL;


-- MONTHS_BETWEEN
SELECT
    MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE, 1)) mon1
    , MONTHS_BETWEEN(ADD_MONTHS(SYSDATE, 1), SYSDATE) mon2
FROM DUAL;


-- LAST_DAY
SELECT
    LAST_DAY(SYSDATE)
    , LAST_DAY(ADD_MONTHS(SYSDATE, 1))
FROM DUAL;


-- ROUND(date, format)
-- TRUNC(date, format)
SELECT
    SYSDATE
    , ROUND(SYSDATE, 'month')
    , TRUNC(SYSDATE, 'month')
FROM DUAL;


-- NEXT_DAY(date, char)
SELECT NEXT_DAY(SYSDATE, '금요일')
FROM DUAL;



-- p.140
-- 형변환
SELECT TO_CHAR(123456789, '999,999,999')
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')
FROM DUAL;


-- TO_NUMBER(expr, format)
-- 문자나 다른 유형의 숫자를 NUMBER 형으로 변환하는 함수
SELECT TO_NUMBER('123456')
FROM DUAL;


-- TO_DATE, TO_TIMESTAMP
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';

SELECT
    TO_DATE('20140101', 'YYYY-MM-DD')
    , TO_DATE('20220427 14:06:10', 'YYYY-MM-DD HH24:MI:SS')
FROM DUAL;


-- NULL 관련 함수
SELECT
    NVL(manager_id, employee_id)
FROM employees
WHERE manager_id IS NULL;

-- NVL2(expr1, expr2, expr3)
-- expr1이 NULL이 아니면, expr2를 실행
-- expr1이 NULL이면, expr3를 실행


DESC employees;

SELECT
    employee_id
    , NVL2(commission_pct
           , salary + (salary + commission_pct)
           , salary) as final_salary
FROM employees;


-- COALESCE(expr1, expr2, ...)
-- 매개변수로 들어오는 표현식에서 NULL이 아닌 첫번째 표현식 반환

SELECT
    employee_id
    , salary
    , commission_pct
    , COALESCE(salary * commission_pct, salary) AS salary
FROM employees;



-- LNNVL
-- 매개변수로 들어오는 조건식의 결과 FALSE나 UNKNOWN --> TRUE 반환
-- TRUE 이면 FALSE로 반환
SELECT
    employee_id
    , commission_pct
FROM employees
WHERE commission_pct < 0.2;
-- 이 쿼리의 문제점 : NULL 조회가 안된 상태임


SELECT
    -- COUNT(*) -- 행 갯수 반환
    employee_id
    , commission_pct
FROM employees
WHERE LNNVL(commission_pct >= 0.2);


-- NULLIF

SELECT
    employee_id
    , TO_CHAR(start_date, 'YYYY') start_year
    , TO_CHAR(end_date, 'YYYY') end_year
    , NULLIF(TO_CHAR(end_date, 'YYYY'), TO_CHAR(start_date, 'YYYY')) nullif_year
FROM job_history;


-- DECODE (IF - ELIF - ELIF - ELSE)
SELECT UNIQUE(channel_id) FROM sales;

SELECT
    prod_id
    , DECODE(channel_id, 3, 'Direct'
                       , 9, 'Direct'
                       , 5, 'Indirect'
                       , 4, 'Indirect'
                          , 'Others') decodes
FROM sales
WHERE prod_id = 125;

