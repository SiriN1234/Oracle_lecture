-- 분석함수 : RANK, DENSE RANK, LAG, LEAD
-- RANK() OVER(PARTITION BY 컬럼명 ORDER BY 컬럼명)

-- window 절
-- ROW,
-- RANGE,
-- BETWEEN ~ AND
-- UNBOUNDED PRECEDING : 파티션으로 구분된 첫 번째 로우가 시작 지점
-- UNBOUNDED FOLLOWING : 파티션으로 구분된 마지막 로우가 끝 지점

SELECT
    department_id
    , emp_name
    , hire_date
    , salary
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ) AS all_salary
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                        ) AS first_current_sal
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
                        ) AS current_end_sal
FROM employees
WHERE department_id IN (30, 90);


-- FIRST_VALUE
-- 가장 첫 번째 값을 반환
SELECT
    department_id
    , emp_name
    , hire_date
    , salary
    , FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ) AS all_salary
    , FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                        ) AS first_current_sal
    , FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
                        ) AS current_end_sal
FROM employees
WHERE department_id IN (30, 90);


-- LAST_VALUE
-- 마지막 값을 보여준다
SELECT
    department_id
    , emp_name
    , hire_date
    , salary
    , LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ) AS all_salary
    , LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                        ) AS first_current_sal
    , LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
                        ) AS current_end_sal
FROM employees
WHERE department_id IN (30, 90);


-- NTH_VALUE
-- n번째 로우에 해당되는 값을 반환
SELECT
    department_id
    , emp_name
    , hire_date
    , salary
    , NTH_VALUE(salary, 2) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ) AS all_salary
    , NTH_VALUE(salary, 3) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                        ) AS first_current_sal
    , NTH_VALUE(salary, 2) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
                        ) AS current_end_sal
FROM employees
WHERE department_id IN (30, 90);


-- p.211
-- 계층형 쿼리
-- 핵심 포인트 : CONNECT BY 조건문 정리
SELECT
    department_id
    , LPAD(' ', 3 * (LEVEL - 1)) || department_name, LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;


-- manager_id는 해당 사원의 매니저 사번이 있다
-- 각 매니저는 사원 ID가 있다
-- 사원별 계층 구조를 만들고, 부서 테이블과 조인해서 부서명까지 조회한다
SELECT
    a.employee_id
    , LPAD(' ', 3 * (LEVEL - 1)) || a.emp_name
    , LEVEL
    , b.department_name
FROM
    employees a
    , departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id = a.manager_id;


-- WHERE a.department_id = 30
SELECT
    a.employee_id
    , LPAD(' ', 3 * (LEVEL - 1)) || a.emp_name
    , LEVEL
    , b.department_name
FROM
    employees a
    , departments b
WHERE a.department_id = b.department_id
  AND a.department_id = 30
START WITH a.manager_id IS NULL
CONNECT BY NOCYCLE PRIOR a.employee_id = a.manager_id;


-- CONNECT BY a.department_id = 30;
SELECT
    a.employee_id
    , LPAD(' ', 3 * (LEVEL - 1)) || a.emp_name
    , LEVEL
    , b.department_name
FROM
    employees a
    , departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY NOCYCLE PRIOR a.employee_id = a.manager_id
AND a.department_id = 30;

-- CONNECT BY PRIOR 자식컬럼 = 부모컬럼 : 부모에서 자식으로 트리 구성(TOP DOWN)
-- CONNECT BY PRIOR 부모컬럼 = 자식컬럼 : 자식에서 부모로 트리 구성 (BOTTOM UP)
-- CONNECT BY NOCYCLE PRIOR = 무한루프 방지
SELECT
    a.employee_id
    , LPAD(' ', 3 * (LEVEL - 1)) || a.emp_name
    , LEVEL
    , b.department_name
FROM
    employees a
    , departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY NOCYCLE PRIOR a.manager_id = a.employee_id
AND a.department_id = 30;


-- p.226 WITH 절
-- kor_loan_status 테이블에서 연도별 최종월 기준 가장 대출이 많은 도시와 잔액

SELECT b2.*
FROM ( SELECT period, region, sum(loan_jan_amt) jan_amt
         FROM kor_loan_status 
         GROUP BY period, region
      ) b2,      
      ( SELECT b.period,  MAX(b.jan_amt) max_jan_amt
         FROM ( SELECT period, region, sum(loan_jan_amt) jan_amt
                  FROM kor_loan_status 
                 GROUP BY period, region
              ) b,
              ( SELECT MAX(PERIOD) max_month
                  FROM kor_loan_status
                 GROUP BY SUBSTR(PERIOD, 1, 4)
              ) a
         WHERE b.period = a.max_month
         GROUP BY b.period
      ) c   
 WHERE b2.period = c.period
   AND b2.jan_amt = c.max_jan_amt
 ORDER BY 1;
 
 
-- WITH절을 사용할 때 : 동일 구문 반복 사용 시
WITH b2 AS (SELECT
                period
                , region
                , sum(loan_jan_amt) jan_amt
            FROM kor_loan_status
            GROUP BY period, region) -- AS SELECT
     , c AS (SELECT
                b.period
                , MAX(b.jan_amt) max_jan_amt
             FROM (SELECT
                        period
                        , region
                        , sum(loan_jan_amt) jan_amt
                   FROM kor_loan_status
                   GROUP BY period, region) b
                   , (SELECT MAX(PERIOD) max_month
                      FROM kor_loan_status
                      GROUP BY SUBSTR(PERIOD, 1, 4)) a -- FROM
             WHERE b.period = a.max_month
             GROUP BY b.period) -- AS SELECT
SELECT b2.*
FROM
    b2, c
WHERE b2.period = c.period
  AND b2.jan_amt = c.max_jan_amt
ORDER BY 1;


WITH temp AS (SELECT 
                    employee_id
                    , emp_name
                    , job_id
                    , salary
               FROM employees
)
SELECT job_id, sum(salary)
FROM temp
GROUP BY job_id