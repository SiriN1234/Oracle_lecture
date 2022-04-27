-- 연산자

DESC employees;

SELECT TOP 5
    employee_id || '-' || emp_name AS employee_info
FROM employees;

-- 표현식 (조건문)
-- CASE WEH 조건 THEN ELSE END
SELECT
    employee_id
    , salary
    , CASE WHEN salary <= 5000 THEN 'C등급'
           WHEN salary > 5000 AND salary <= 15000 THEN 'B등급'
           ELSE 'A등급'
      END AS salary_grade
FROM employees;

-- p.114
-- 비교 조건식 : ANY, SOME, ALL 키워드로 비교하는 조건식

-- ANY
-- 조건 중 하나를 만족해야 함
SELECT
    employee_id
    , salary
FROM employees
WHERE salary = ANY (2000, 3000, 4000)
ORDER BY employee_id;


SELECT
    employee_id
    , salary
FROM employees
WHERE salary = 2000 or salary = 3000 or salary = 4000
ORDER BY employee_id;
        
        
-- ALL
-- 모든 조건을 동시에 만족해야 함
SELECT
    employee_id
    , salary
FROM employees
WHERE salary = ALL (2000, 3000, 4000)
ORDER BY employee_id;

SELECT
    employee_id
    , salary
FROM employees
WHERE salary = 2000 and salary = 3000 and salary = 4000
ORDER BY employee_id;


-- SOME
SELECT
    employee_id
    , salary
FROM employees
WHERE salary = SOME (2000, 3000, 4000)
ORDER BY employee_id;

-- 논리 조건식
SELECT
    employee_id
    , salary
FROM employees
WHERE NOT (salary >= 2500)
ORDER BY employee_id;


-- BETWEEN AND 조건식
-- 범위 지정
-- 급여가 2000 ~ 2500 사이에 해당하는 사원을 조회
SELECT
    employee_id
    , salary
FROM employees
WHERE salary BETWEEN 2000 AND 2500
ORDER BY employee_id;


-- IN 조건식 (OR, =ANY)
SELECT
    employee_id
    , salary
FROM employees
WHERE salary IN (2000, 3000, 4000) -- =ANY
ORDER BY employee_id;

-- NOT IN 조건식 (반대)
SELECT
    employee_id
    , salary
FROM employees
WHERE salary <> 2000 AND salary <> 3000 AND salary <> 4000 -- =<>ALL, <>AND
ORDER BY employee_id;


-- EXISTS 조건식
-- IN과 비슷함, 단 서브쿼리 절에서만 사용 가능
SELECT
    department_id
    , department_name
FROM departments a
WHERE EXISTS (SELECT * 
             FROM employees b
             WHERE a.department_id = b.department_id
               AND b.salary > 3000)
ORDER BY a.department_name;


-- LIKE 조건식
-- 문자열의 패턴을 검색할 때 사용하는 조건식
-- 사원 테이블 사원 이름이 'A'로 시작되는 사원 조회

-- A로 시작하되 나머지는 어떤 글자가 와도 상관없이 모두 조회
SELECT emp_name
  FROM employees
 WHERE emp_name LIKE 'A%'
 ORDER BY emp_name;
 
 -- 3번째 글자가 a인 경우 조회
SELECT emp_name
  FROM employees
 WHERE emp_name LIKE '__a%'
 ORDER BY emp_name;
 
SELECT emp_name
  FROM employees
 WHERE emp_name LIKE '%p'
 ORDER BY emp_name;
