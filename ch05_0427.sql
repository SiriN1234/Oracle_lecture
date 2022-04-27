-- p.152
-- 기본 집계 함수
-- Count(expr) 쿼리 결과 건수, 전체 로우 수 반환 (행 갯수)
SELECT count(*) FROM employees;

SELECT count(employee_id) FROM employees;

-- NUULL값은  count() 함수에 계산 안됨
SELECT count(department_id) FROM employees;


-- DISTINCT
SELECT count(DISTINCT department_id)
  FROM employees;
  
SELECT DISTINCT department_id
  FROM employees
 ORDER BY 1;
 
 
-- SUM(expr)
-- 합계 구하기
SELECT SUM(salary) FROM employees;

SELECT
    SUM(salary)
    , SUM(DISTINCT salary)
FROM employees;


-- AVG(expr)
SELECT
    AVG(salary)
    , AVG(DISTINCT salary)
FROM employees;


-- MIN, MAX
SELECT
    MIN(salary)
    , MAX(salary)
FROM employees;


-- VARIANCE, STDDEV
-- 분산, 표준편차
SELECT
    VARIANCE(salary)
    , STDDEV(salary)
FROM employees;


-- GROUP BY / HAVING
SELECT
    department_id,
    SUM(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;

SELECT
    period
    , region
    , SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, region
ORDER BY period, region;


-- 2013년 11월 총 잔액만 구한다
SELECT
    period
    , region
    , SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY period, region
HAVING SUM(loan_jan_amt) > 100000
ORDER BY region;


-- ROLLUP절과 CUBE절, GROUPING SETS
-- ROLLUP : 소그룹간의 합계를 계산함
SELECT
    period
    , gubun
    , SUM(loan_jan_amt) totl_nam
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, gubun
ORDER BY period;


SELECT
    period
    , gubun
    , SUM(loan_jan_amt) totl_nam
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period, gubun);


-- CUBE
SELECT
    period
    , gubun
    , SUM(loan_jan_amt) totl_nam
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY CUBE(period, gubun);


-- GROUPING SETS
-- 특정항목에 대한 소계를 계산하는 함수
SELECT
    period
    , gubun
    , SUM(loan_jan_amt) totl_nam
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY GROUPING SETS(period, gubun);


-- 집합 연산자

CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));
       
INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

COMMIT;

-- UNION
-- 두 개의 데이터 집합에서 출발
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
ORDER BY seq;


SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION -- 합집합 개념 적용
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';


-- INTERSECT
-- 합집합이 아니라 교집합을 의미한다
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
INTERSECT -- 교집합 개념 적용
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';


-- MINUS
-- 차집합
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
MINUS -- 차집합 개념 적용
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';