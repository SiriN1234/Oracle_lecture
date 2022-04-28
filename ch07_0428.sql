-- WINDOW Function
-- 분석 함수 : 특정 그룹별 집계를 담당함
--            함수의 종류

-- PARTITION BY : 분석 함수로 계산될 대상 로우의 그룹(파티션)을 지정

--ROW_NUMBER()
SELECT
    department_id
    , emp_name
    , ROW_NUMBER() OVER(PARTITION BY department_id
                        ORDER BY department_id, emp_name) dep_rows
FROM employees;

-- RANK(), DENSE_RANK()
SELECT
    department_id
    , emp_name
    , salary
    , RANK() OVER (PARTITION BY department_id
                   ORDER BY salary) dep_rank
    , DENSE_RANK() OVER (PARTITION BY department_id
                         ORDER BY salary) dep_denserank
FROM employees;


-- CUME_DIST, PERCENT_RANK
-- CUME_DIST : 주어진 그룹에 대한 상대 누적 분포도값 반환
-- 분포도 값(비율) 반환 값의 범위 0초과 1이하 사이의 값 반환

SELECT
    department_id
    , emp_name
    , CUME_DIST() over(PARTITION BY department_id
                       ORDER BY salary) dep_dist
FROM employees;

-- PERCENT_RANK : 해당 그룹 내의 백분위 순위를 반환
-- 0이상 1이하를 반환
SELECT
    department_id
    , emp_name
    , salary
    , rank() OVER (PARTITION BY department_id
                   ORDER BY salary) ranking
    , CUME_DIST() OVER (PARTITION BY department_id
                        ORDER BY salary) cume_dist_value
    , PERCENT_RANK() OVER (PARTITION BY department_id
                           ORDER BY salary) percentile
FROM employees
WHERE department_id = 60;


-- NTILE 함수
-- NTILE(4) 값을 4등분 함

SELECT
    department_id
    , emp_name
    , salary
    , NTILE(5) OVER (PARTITION BY department_id
                      ORDER BY salary) NTILES
FROM employees
WHERE department_id IN (30, 60);


-- LAG : 선행 로우의 값 참조
-- LEAD : 후행 로우의 값 참조

SELECT
    emp_name
    , hire_date
    , salary
    , LAG(salary, 1, 0) OVER (ORDER BY hire_date) AS prev_sal
    , LEAD(salary, 1, 0) OVER (ORDER BY hire_date) AS next_sal
FROM employees
WHERE department_id = 30;


