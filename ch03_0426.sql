-- SELECT문
/*
SELECT * 혹은 컬럼
FROM 테이블 또는 VIEW
WHERE 조건
ORDER BY 컬럼;
*/

어디서 가져올 것인가? FROM
무엇을 가져올 것인가? SELECT
어떻게 가져올 것인가? WHERE

-- 예시 : 사원 테이블에서 급여가 5000이 넘는 사원번호와 사원명을 조회한다

DESC employees;

SELECT
    employee_id
    , emp_name
FROM employees
WHERE salary > 5000;

SELECT
    employee_id
    , emp_name
    , salary
FROM employees
WHERE salary > 5000
ORDER BY employee_id;

-- 급여가 5000 이상이고 job_id가 IT_PROG인 사원 조회

SELECT
    employee_id
    , emp_name
    , salary
FROM employees
WHERE salary > 5000
    AND job_id = 'IT_PROG'
ORDER BY employee_id;


-- p.94
-- 데이터에 있는 문자열은 대소문자를 구분해서 써야함

SELECT
    employee_id
    , emp_name
    , salary
FROM employees
WHERE salary > 5000
    AND job_id = 'it_prog'
ORDER BY employee_id;

-- 급여가 5000 이상이거나 job_id가 'IT_PROG'인 사원 (OR)

SELECT
    employee_id
    , emp_name
    , salary
FROM employees
WHERE salary > 5000
    OR job_id = 'IT_PROG'
ORDER BY employee_id;

SELECT * FROM employees;

SELECT
    employee_id
    , emp_name
    , phone_number
FROM employees
WHERE salary > 7000
    AND manager_id = 101
ORDER BY employee_id;


SELECT
    a.employee_id
    , a.emp_name
    , a.department_id
    , b.department_name
FROM
    employees a
    , departments b
WHERE a.department_id = b.department_id;


-- INSERT
CREATE TABLE ex3_1 (
    col1    VARCHAR2(10)
    , col2  NUMBER
    , col3 DATE
);

INSERT INTO ex3_1 (col1, col2, col3)
VALUES ('ABC', '10', SYSDATE);

-- 컬럼 순서를 바꿔도 큰 문제가 안됨
INSERT INTO ex3_1 (col3, col1, col2)
VALUES (SYSDATE, 'DEF', 20);

SELECT * FROM ex3_1;

-- 타입을 맞추지 않으면 오류 발생
INSERT INTO ex3_1(col1, col2, col3)
VALUES ('ABC', 10, 30);


-- p.97
-- 컬럼명 생략
INSERT INTO ex3_1
VALUES ('GHI', 10, SYSDATE);

INSERT INTO ex3_1 (col1, col2)
VALUES ('GHI', 20);

INSERT INTO ex3_1
VALUES('GHI', 30);

-- p.98
CREATE TABLE ex3_2 (
    emp_id      NUMBER
    , emp_name  VARCHAR2(100)
);

-- 실무에서 많이 쓰임
INSERT INTO ex3_2(emp_id, emp_name)
SELECT
    employee_id
    , emp_name
FROM employees
WHERE salary > 5000;

SELECT * FROM ex3_2;


-- UPDATE : 기존 데이터를 수정할 때 
-- ALTER : 테이블의 칼럼명, 제약조건 수정

-- UPDATE 테이블명
-- SET 컬럼1 = 변경값1, 컬럼2 = 변경값2
-- WHERE 조건;

SELECT * FROM ex3_1;

-- col2를 모두 50으로 변경한다
UPDATE ex3_1
SET col2 = 50;

SELECT * FROM ex3_1;

SELECT * FROM ex3_2

UPDATE ex3_2
SET EMP_NAME = 10
WHERE EMP_ID = 201;

SELECT * FROM ex3_2


-- MERGE
-- 조건 비교해서 테이블에 해당 조건에 맞는 데이터가 없으면 INSERT
-- 있으면 UPDATE

DROP TABLE ex3_3;

CREATE TABLE ex3_3 (
    employee_id     NUMBER
    , BONUM_AMT     NUMBER DEFAULT 0
);

SELECT * FROM SALES;
DESC SALES;


INSERT INTO ex3_3 (employee_id)
SELECT e.employee_id
FROM
    employees e
    , sales s
WHERE e.employee_id = s.employee_id
    AND s.SALES_MONTH BETWEEN '200010' AND '200012'
GROUP BY e.employee_id;

SELECT * FROM ex3_3 ORDER BY employee_id;


-- (1) 관리자 사번(manager_id)이 146번인 사원을 찾는다
-- (2) ex3_3 테이블에 있는 사원의 사번과 일치하면 보너스 금액에 자신의 급여를 1%를 보너스로 갱신
-- (3) ex3_3 테이블에 있는 사원의 사번과 일치하지 않으면 (1)의 결과의 사원을 신규로 입력 이 때 보너스 금액은 급여의 0.1%
-- (4) 이 때 급여가 8000미만인 사원만 처리해보자

-- 서브쿼리


SELECT
    employee_id
    , manager_id
    , salary
    , salary * 0.01
FROM employees
WHERE employee_id IN (SELECT employee_id
                        FROM ex3_3);


-- 관리자 사번이 46인 사원은 161번 사원 한 명이므로 ex3_3 테이블에서 161인 건의 보너스 금액은 7,000 * 0.001 즉 70으로 갱신

SELECT
    employee_id
    , manager_id
    , salary
    , salary * 0.001
FROM employees
WHERE employee_id NOT IN (SELECT employee_id
                        FROM ex3_3)
    AND manager_id = 146;
    
    
MERGE INTO ex3_3 d 
    USING (SELECT
                employee_id
                , salary 
                , manager_id
           FROM employees
           WHERE manager_id = 146) b 
        ON (d.employee_id = b.employee_id)
WHEN MATCHED THEN 
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01 
WHEN NOT MATCHED THEN 
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * 0.001)
    WHERE (b.salary < 8000);
    
SELECT * FROM ex3_3 ORDER BY employee_id;    


-- UPDATE 절에 DELETE WHERE 구문을 추가할 수 있다
-- 만족하는 행은 삭제가 된다

MERGE INTO ex3_3 d 
    USING (SELECT
                employee_id
                , salary 
                , manager_id
           FROM employees
           WHERE manager_id = 146) b 
        ON (d.employee_id = b.employee_id)
WHEN MATCHED THEN 
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01 
    DELETE WHERE (B.employee_id = 161)
WHEN NOT MATCHED THEN 
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * 0.001)
    WHERE (b.salary < 8000);

SELECT * FROM ex3_3 ORDER BY employee_id;


-- DELETE 문
DELETE ex3_3;
SELECT * FROM ex3_3;


-- Commit Rollback Truncate
-- Commit : 변경한 데이터를 DB에 마지막으로 반영
-- ROLLBACK : 반대로 변경한 데이터를 변경하기 이전 상태로 되돌림
CREATE TABLE ex3_4 (
    employee_id NUMBER
);

INSERT INTO ex3_4 VALUES (100);

SELECT * FROM ex3_4;

commit;
rollback;

-- TRUNCATE
-- DELETE문은 데이터 삭제 후, COMMIT 필요 / ROLLBACK을 실행하면 데이터가 삭제되기 전으로 돌아옴
-- 한번 실행 시, 데이터 바로 삭제, ROLLBACK 적용 안됨

SELECT * FROM ex3_4;
TRUNCATE TABLe ex3_4;



