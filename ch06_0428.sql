-- 6장
-- 테이블 p.176
-- 동등 조인
SELECT
    a.employee_id
    , a.emp_name
    , a.department_id
    , b.department_name
FROM
    employees a
    , departments b
WHERE
    a.department_id = b.department_id;


-- 세미조인
-- 서브쿼리를 사용함
-- 서브 쿼리에 존재하는 데이터만 메인 쿼리에서 추출
-- IN & EXISTS





SELECT * 
FROM departments a, employees b
WHERE a.department_id = b.department_id
AND b.salary > 3000


-- EXISTS 사용
SELECT
    department_id
    , department_name
FROM departments a
WHERE EXISTS (SELECT * 
              FROM employees b
              WHERE a.department_id = b.department_id
                AND b.salary > 3000) -- EXISTS
ORDER BY a.department_name;


-- IN 사용
SELECT
    department_id
    , department_name
FROM departments a
WHERE a.department_id IN (SELECT b.department_id
                          FROM employees b
                          WHERE b.salary > 3000) -- IN
ORDER BY a.department_name;


-- 안티 조인
-- 세미 조인 개념의 반대
-- 서브쿼리의 B 테이블에는 없는 메인 쿼리의 A 테이블의 데이터만 추출

SELECT
    a.employee_id
    , a.emp_name
    , a.department_id
    , b.department_name
FROM
    employees a
    , departments b
WHERE a.department_id = b.department_id
  AND a.department_id NOT IN (SELECT department_id
                              FROM departments
                              WHERE manager_id IS NULL);


-- 셀프 조인
-- 동일한 한 테이블에서 조인하는 방법
SELECT
    a.employee_id
    , a.emp_name
    , b.employee_id
    , b.emp_name
    , a.department_id
FROM
    employees a
    , employees b
WHERE a.employee_id < b.employee_id
  AND a.department_id = b.department_id
  AND a.department_id = 20;
  
  
-- OUTER JOIN
-- 조인 조건에 만족하지 않더라도 데이터를 모두 추출함

-- 무조건 ID가 매칭이 된 것만 조회
SELECT
    a.department_id
    , a.department_name
    , b.job_id
    , b.department_id
FROM
    departments a
    , job_history b
WHERE
    a.department_id =  b.department_id;

-- 외부조인 걸기
SELECT
    a.department_id
    , a.department_name
    , b.job_id
    , b.department_id
FROM
    departments a
    , job_history b
WHERE
    a.department_id =  b.department_id(+);
-- 매칭이 안되는 값은 NULL을 가져옴


SELECT
    a.employee_id
    , a.emp_name
    , b.job_id
    , b.department_id
FROM
    employees a
    , job_history b
WHERE a.employee_id = b.employee_id(+)
  AND a.department_id = b.department_id(+);
  

-- 카타시안 조인
-- 사원 테이블의 총 건수는 107건
-- 부서 테이블의 총 건수는 27건
-- 107 x 27 = 2889건

-- ANSI 조인
-- ANSI SQL 문법 (JOIN 명 들어감)
-- 2013년 1월 1일 이후에 입사한 사원번호, 사원명, 부서번호, 부서명을 조회하는 쿼리 비교
-- 기존 문법
SELECT
    a.employee_id
    , a.emp_name
    , b.department_id
    , b.department_name
FROM
    employees a
    , departments b
WHERE a.department_id = b.department_id
  AND a.hire_date >= TO_DATE('2003-01-01', 'YYYY-MM-DD');
  
-- ANSI
SELECT
    a.employee_id
    , a.emp_name
    , b.department_id
    , b.department_name
FROM
    employees a
INNER JOIN departments b
        ON (a.department_id = b.department_id)
WHERE a.hire_date >= TO_DATE('2003-01-01', 'YYYY-MM-DD');


-- 기존 외부 조인
SELECT
    a.employee_id
    , a.emp_name
    , b.job_id
    , b.department_id
FROM
    employees a
    , job_history b
WHERE a.employee_id = b.employee_id(+)
  AND a.department_id = b.department_id(+);
  
-- ANSI 외부 조인

SELECT
    a.employee_id
    , a.emp_name
    , b.job_id
    , b.department_id
FROM
    employees a
LEFT OUTER JOIN job_history b
             ON (a.employee_id = b.employee_id
                 AND a. department_id = b.department_id); -- ON
                 

-- CROSS 조인
-- ANSI조인에서 카타시안 조인을 가리키는 말

-- 기존 문법
SELECT
    a.employee_id
    , a.emp_name
    , b.department_id,
    b.department_name
FROM
    employees a,
    departments b;
    
-- ANSI 문법
SELECT
    a.employee_id
    , a.emp_name
    , b.department_id
    , b.department_name
FROM employees a
CROSS JOIN departments b;


-- FULL OUTER 조인
-- 외부 조인 하나로 ANSI 조인에서만 제공하는 기능
-- 기존 외부 조인 조건에서는 한쪽에만 (+)를 붙일 수 있기 때문에 FULL OUTER 조인을 사용한다

CREATE TABLE HONG_A  (EMP_ID INT);

CREATE TABLE HONG_B  (EMP_ID INT);

INSERT INTO HONG_A VALUES ( 10);

INSERT INTO HONG_A VALUES ( 20);

INSERT INTO HONG_A VALUES ( 40);

INSERT INTO HONG_B VALUES ( 10);

INSERT INTO HONG_B VALUES ( 20);

INSERT INTO HONG_B VALUES ( 30);

COMMIT;


SELECT
    a.emp_id
    , b.emp_id
FROM hong_a a
FULL OUTER JOIN hong_b b
  ON (a.emp_id = b.emp_id);


-- 서브 쿼리
-- SQL 문장 안에서 보조로 사용되는 또 다른 SELECT 문을 의미
-- 구조 : (1) 메인 쿼리 / (2) 서브 쿼리
SELECT (SELECT (서브쿼리)
        FROM WHERE GROUP BY HAVING ORDER BY
        )
FROM (SELECT FROM WHERE GROUP BY HAVING ORDER BY)
WHERE (SELECT FROM WHERE GROUP BY HAVING ORDER BY)
GROUP BY
HAVING

-- 연관성 없는 서브 쿼리
SELECT * FROM employees; -- 107개의 행

-- 메인쿼리 : 모든 사원 테이블을 조회
-- 서브쿼리 : 조건 - 사원테이블의 평균 급여보다 많은 사원을 조회
-- 결과값은 51개

SELECT *
FROM employees
WHERE salary >= (SELECT AVG(salary) FROM employees);


-- parent_id가 NULL인 부서번호를 가진 총 사원의 건수
SELECT count(*)
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM departments
                        WHERE parent_id IS NULL);
                        
SELECT
    employee_id
    , emp_name
    , job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT
                                    employee_id
                                    , job_id
                                FROM job_history);
                                


-- 연관성 있는 서브 쿼리
SELECT
    a.department_id
    , a.department_name
FROM departments a
WHERE EXISTS (SELECT 1
              FROM job_history b
              WHERE a.department_id = b.department_id);
              
              
SELECT 1
FROM departments a, job_history b
WHERE a.department_id = b.department_id;
              
-- SELECT 절에 서브쿼리가 존재하는 케이스
SELECT
    a.employee_id
    , (SELECT b.emp_name
       FROM employees b
       WHERE a.employee_id = b.employee_id) AS emp_name
    , a.department_id
    , (SELECT b.department_name
       FROM departments b
       WHERE a.department_id = b.department_id) AS dep_name
    , a.job_id
    , (SELECT c.job_title
       FROM jobs c
       WHERE a.job_id = c.job_id) AS title_name
FROM job_history a;


-- 중첩 서브쿼리
SELECT
    a.department_id
    , a.department_name
FROM departments a
WHERE EXISTS (SELECT 1
              FROM employees b
              WHERE a.department_id = b.department_id
              AND b.salary > (SELECT AVG(salary)
                              FROM employees)
              );
              

-- p.198
-- 기획부 산하에 있는 부서에 속한 사원의 평균급여보다 많은 급여를 받는 사원
-- 기획부 : 부서 테이블
-- 급여 : 사원 테이블

SELECT
    a.employee_id
    , a.emp_name
    , b.department_id
    , b.department_name
FROM
    employees a
    , departments b
    , (SELECT AVG(c.salary) AS avg_salary
       FROM
            departments b
            , employees c
       WHERE b.parent_id = 90
         AND b.department_id = c.department_id) d -- 기획부 평균급여
WHERE a.department_id = b.department_id
  AND a.salary > d.avg_salary;

SELECT * FROM departments;
SELECT * FROM employees;

-- p.200
-- 2000년 이탈리아 평균 매출액(연평균) 보다 큰 월의 평균 매출액을 구함
-- 첫 번째 서브 쿼리 : 월별 평균 매출을 구하는 쿼리
-- 두 번째 서브 쿼리 : 연평균 매출액을 구하는 쿼리

SELECT * FROM sales;
SELECT * FROM customers;
SELECt * FROM countries;

-- sales의 공통부분 customers : cust_id
-- customers와 countries의 공통부분 : country_id

SELECT
    a.*
FROM
    (SELECT
        a.sales_month
        , ROUND(AVG(a.amount_sold)) AS month_avg
     FROM
        sales a
        , customers b
        , countries c
     WHERE a.sales_month BETWEEN '200001' AND '200012'
       AND a.cust_id = b.cust_id
       AND b.country_id = c.country_id
       AND c.country_name = 'Italy'
     GROUP BY a.sales_month
     ) a
     , (SELECT ROUND(AVG(a.amount_sold)) AS year_avg
        FROM
            sales a
            , customers b
            , countries c
        WHERE a.sales_month BETWEEN '200001' AND '200012'
          AND a.cust_id = b.CUST_ID
          AND b.country_id = c.country_id
          and c.country_name = 'Italy'
        ) b
WHERE a.month_avg > b.year_avg;
     
    
-- p.200
-- 복잡한 쿼리 작성법 예시
-- (1), (2) --> 메인 쿼리 작성
-- (3), (4) --> 서브 쿼리 작성 후 합치기
-- 연도별로 이탈리아 매출 데이터를 살펴 매출실적이 가장 많은 사원의 목록과 매출액을 구하라
-- 연도, 최대매출사원, 최대매출액
-- 이탈리아 찾기 : countries
-- 이탈리아 고객 : customers
-- 매출 : sales
-- 사원정보 : employees

-- (1) 연도, 사원별 이탈리아 매출액 구하기
-- 이탈리아 고객 찾기 : customers, countries country_id로 조인
-- 이탈리아 매출 찾기 : 위 결과와 sales 테이블을 cust_id로 조인
-- 최대 매출액 구하려면 MAX 함수 쓰고, 연도별로 GROUP BY

SELECT
    SUBSTR(a.sales_month, 1, 4) as years
    , a.employee_id
    , SUM(a.amount_sold) AS amount_sold
FROM
    sales a
    , customers b
    , countries c
WHERE a.cust_id = b.cust_id
  AND b.country_id = c.country_id
  AND c.country_name = 'Italy'
GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id;

-- (1) 결과에서 연도별 최대, 최소 매출액 구하기
SELECT
    years
    , MAX(amount_sold) AS max_sold
    , MIN(amount_sold) AS min_sold
FROM
    (SELECT
     SUBSTR(a.sales_month, 1, 4) as years
     , a.employee_id
     , SUM(a.amount_sold) AS amount_sold
     FROM
        sales a
        , customers b
        , countries c
     WHERE a.cust_id = b.cust_id
       AND b.country_id = c.country_id
       AND c.country_name = 'Italy'
     GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id) K
GROUP BY years
ORDER BY years;

-- (3) (1)의 결과와 (2)의 결과를 조인해서 최대매출, 최소매출액을 일으킨 사원을 찾는다

SELECT
    emp.years
    , emp.employee_id
    , emp.amount_sold
FROM
    (SELECT
        SUBSTR(a.sales_month, 1, 4) as years
        , a.employee_id
        , SUM(a.amount_sold) AS amount_sold
     FROM
        sales a
        , customers b
        , countries c
     WHERE a.cust_id = b.cust_id
       AND b.country_id = c.country_id
       AND c.country_name = 'Italy'
    GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id) emp
    , (SELECT
          years
         , MAX(amount_sold) AS max_sold
         , MIN(amount_sold) AS min_sold
       FROM
          (SELECT
              SUBSTR(a.sales_month, 1, 4) as years
              , a.employee_id
              , SUM(a.amount_sold) AS amount_sold
           FROM
              sales a
              , customers b
              , countries c
           WHERE a.cust_id = b.cust_id
             AND b.country_id = c.country_id
             AND c.country_name = 'Italy'
           GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id) K
        GROUP BY years) sale
WHERE emp.years = sale.years
  AND emp.amount_sold = sale.max_sold
ORDER BY years;


-- (4) 마지막으로 (3) 결과와 사원 테이블을 조인해서 사원 이름을 가져온다

SELECT
    emp.years
    , emp.employee_id
    , emp2.emp_name
    , emp.amount_sold
FROM
    (SELECT
        SUBSTR(a.sales_month, 1, 4) as years
        , a.employee_id
        , SUM(a.amount_sold) AS amount_sold
     FROM
        sales a
        , customers b
        , countries c
     WHERE a.cust_id = b.cust_id
       AND b.country_id = c.country_id
       AND c.country_name = 'Italy'
    GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id) emp
    , (SELECT
          years
         , MAX(amount_sold) AS max_sold
         , MIN(amount_sold) AS min_sold
       FROM
          (SELECT
              SUBSTR(a.sales_month, 1, 4) as years
              , a.employee_id
              , SUM(a.amount_sold) AS amount_sold
           FROM
              sales a
              , customers b
              , countries c
           WHERE a.cust_id = b.cust_id
             AND b.country_id = c.country_id
             AND c.country_name = 'Italy'
           GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id) K
        GROUP BY years) sale
    , employees emp2
WHERE emp.years = sale.years
  AND emp.amount_sold = sale.max_sold
  AND emp.employee_id = emp2.employee_id
ORDER BY years;