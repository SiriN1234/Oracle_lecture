-- 6장 연습문제
-- 1. 101번 사원에 대해 아래의 결과를 산출하는 쿼리를 작성해 보자
-- 사번 사원명 job명칭 job시작일자 job종료일자 job수행부서명

SELECT * FROM employees;
SELECT * FROM job_history;
SELECT * FROM jobs;
SELECT * FROM departments;

/*
사번, 사원명은 employees 테이블에 있다
job 시작일자, job 종료일자는 job_history 테이블에 있다
job 명칭은 jobs 테이블에 있다
수행부서명은 departments 테이블에 있다

employees 테이블과 departments 테이블은 department_id를 이용해 조인
departments 테이블과 job_history 테이블은 department_id를 이용해 조인
job_history 테이블과 jobs 테이블은 job_id를 이용해 조인
*/
SELECT
    a.employee_id
    , a.emp_name
    , b.start_date
    , b.end_date
    , c.job_title
    , d.department_name
FROM
    employees a
    , job_history b
    , jobs c
    , departments d
WHERE a.department_id = d.department_id
  AND d.department_id = b.department_id
  AND b.job_id = c.job_id
  AND a.employee_id = 101;
  
-- 2. 아래의 쿼리를 수행하면 오류가 발생한다. 오류의 원인은 무엇인지 설명해 보자
SELECT
    a.employee_id
    , a.emp_name
    , b.job_id
    , b.department_id
FROM
    employees a
    , job_history b
WHERE a.employee_id = b.employee_id(+)
  AND a.department_id(+) = b.department_id;
  
-- 답 : AND a.department_id(+) = b.department_id;에서 외부조인이 앞에 붙어서


-- 3. 외부 조인을 할 때 (+)연산자를 같이사용할 수 없는데, IN 절에 사용하는 값이 한 개이면 사용할 수 있다 그 이유는 무엇인지 설명해 보자
/*
답 :
오라클은 IN 절에 포함된 값을 기준으로 OR로 변환한다.
예를 들어, 
   department_id IN (10, 20, 30) 은
   department_id = 10
   OR department_id = 20
   OR department_id = 30) 로 바꿔 쓸 수 있다.
   
그런데 IN절에 값이 1개인 경우, 즉 department_id IN (10)일 경우 department_id = 10 로 변환할 수 있으므로,
외부조인을 하더라도 값이 1개인 경우는 사용할 수 있다.
*/

-- 4. 다음의 쿼리를 ANSI 문법으로 변경해보자
SELECT a.department_id, a.department_name
FROM departments a, employees b
WHERE a.department_id = b.department_id
  AND b.salary > 3000
ORDER BY a.department_name;

-- 답 :
SELECT
    a.department_id
    , a.department_name
FROM
    departments a
INNER JOIN employees b
        ON (a.department_id = b.department_id)
WHERE b.salary > 3000
ORDER BY a.department_name;


-- 5. 다음은 연관성 있는 서브 쿼리다. 이를 연관성 없는 서브 쿼리로 변환해 보자.
SELECT a.department_id, a.department_name
 FROM departments a
WHERE EXISTS ( SELECT 1 
                 FROM job_history b
                WHERE a.department_id = b.department_id );
                
답 :
SELECT
    department_id
    , department_name
FROM departments
WHERE department_id IN (SELECT department_id
                        FROM job_history);
                        
                        
-- 6. 연도별 이탈리아 최대매출액과 사원을 작성하는 쿼리를 학습했다.
-- 이 쿼리를 기준으로 최대매출액 뿐만 아니라 최소매출액과 해당 사원을 조회하는 쿼리를 작성해 보자.

/*
필요한 것
이탈리아 연도 매출액 사원

이탈리아는 countries 테이블에 있다
연도와 매출액은 sales 테이블의 sales_month를 이용해 만들어야 할 것 같다
사원은 employees 테이블에 있다

countries 테이블에서 sales 테이블로 바로 조인을 할 수 없기 때문에 중간에 있는 customers 테이블을 거쳐간다
countries 테이블과 customers 테이블은 country_id를 이용해 조인한다
customers 테이블과 sales 테이블은 cust_id를 이용해 조인한다
sales 테이블과 employees 테이블은 employee_id를 이용해 조인한다
*/

/* 
(1)
연도, 사원별 이탈리아 매출액 구하기
연도는 sales 테이블의 sales_month를 이용하고 사원은 customers 테이블의 employee_id,
연간 매출액은 sales 테이블의 amount_sold을 이용하고 이탈리아는 countries 테이블의 country_name을 이용해 구한다
*/


SELECT
    SUBSTR(a.sales_month, 1, 4) AS years
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


/*
(2)
(1)을 이용해서 연도별 최대 매출액, 최소 매출액을 구한다
*/

SELECT
    years
    , MAX(amount_sold) AS max_sold
    , MIN(amount_sold) AS min_sold
FROM
    (SELECT
        SUBSTR(a.sales_month, 1, 4) AS years
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

/*
(3)
(1)의 결과와 (2)의 결과를 조인해서 최대매출, 최소매출액을 일으킨 사원을 찾아야 하므로, (1)과 (2) 결과를 인라인 뷰로 만든다
*/

SELECT
    emp.years
    , emp.amount_sold
FROM
    (SELECT
        SUBSTR(a.sales_month, 1, 4) AS years
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
                SUBSTR(a.sales_month, 1, 4) AS years
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
  AND (emp.amount_sold = sale.max_sold OR emp.amount_sold = sale.min_sold)
ORDER BY years;


/*
(4)
마지막으로 (3)의 결과와 사원 테이블을 조인해서 사원 이름을 가져온다
*/

SELECT
    emp.years
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
  AND (emp.amount_sold = sale.max_sold OR emp.amount_sold = sale.min_sold)
  AND emp.employee_id = emp2.employee_id
ORDER BY years;



-- 7장 연습문제
-- 1. 계층형 쿼리 응용편에서 LISTAGG 함수를 사용해 다음과 같이 로우를 컬럼으로 분리했다
SELECT department_id,
         LISTAGG(emp_name, ',') WITHIN GROUP (ORDER BY emp_name) as empnames
    FROM employees
   WHERE department_id IS NOT NULL
   GROUP BY department_id;
-- LISTAGG 함수 대신 계층형 쿼리, 분석함수를 사용해서 위 쿼리와 동일한 결과를 산출하는 쿼리를 작성해 보자


SELECT
    department_id
    , SUBSTR(SYS_CONNECT_BY_PATH(emp_name, ','), 2) empnames
FROM
    (SELECT emp_name
            , department_id
            , COUNT(*) OVER (PARTITION BY department_id) cnt
            , ROW_NUMBER () OVER (PARTITION BY department_id ORDER BY emp_name) rowseq
     FROM employees
     WHERE department_id IS NOT NULL)
WHERE rowseq = cnt
START WITH rowseq = 1
CONNECT BY PRIOR rowseq + 1 = rowseq
AND PRIOR department_id = department_id;


- 2. 아래의 쿼리는 사원테이블에서 JOB_ID가 'SH_CLERK'인 사원을 조회하는 쿼리이다

SELECT employee_id, emp_name, hire_date
FROM employees
WHERE job_id = 'SH_CLERK'
ORDER By hire_date; 

- 사원테이블에서 퇴사일자(retire_date)는 모두 비어있는데,
- 위 결과에서 사원번호가 184인 사원의 퇴사일자는 다음으로 입사일자가 빠른 192번 사원의 입사일자라고 가정해서
- 다음과 같은 형태로 결과를 추출해낼 수 있도록 쿼리를 작성해 보자. (입사일자가 가장 최근인 183번 사원의 퇴사일자는 NULL이다)

/*
EMPLOYEE_ID EMP_NAME             HIRE_DATE             RETIRE_DATE
----------- -------------------- -------------------  ---------------------------
        184 Nandita Sarchand     2004/01/27 00:00:00  2004/02/04 00:00:00
        192 Sarah Bell           2004/02/04 00:00:00  2005/02/20 00:00:00
        185 Alexis Bull          2005/02/20 00:00:00  2005/03/03 00:00:00
        193 Britney Everett      2005/03/03 00:00:00  2005/06/14 00:00:00
        188 Kelly Chung          2005/06/14 00:00:00  2005/08/13 00:00:00
....        
....
        199 Douglas Grant        2008/01/13 00:00:00  2008/02/03 00:00:00
        183 Girard Geoni         2008/02/03 00:00:00
*/

- 2번째 hire_date를 1번째 retire_date로 3번째 hire_date는 2번째 retire_date로 이런식으로 반복하면 된다
- 후행 로우의 값을 참조할 때는 LEAD를 쓴다
SELECT
    EMPLOYEE_ID
    , EMP_NAME
    , HIRE_DATE
    , LEAD(hire_date) OVER (PARTITION BY job_id ORDER BY hire_date) AS retire_date
FROM employees
WHERE job_id = 'SH_CLERK'
ORDER By hire_date;


- 3. sales 테이블에는 판매데이터, customers 테이블에는 고객정보가 있다. 2001년 12월(SALES_MONTH = '200112') 판매데이터 중
- 현재일자를 기준으로 고객의 나이(customers.cust_year_of_birth)를 계산해서 다음과 같이 연령대별 매출금액을 보여주는 쿼리를 작성해 보자.

-------------------------   
연령대    매출금액
-------------------------
10대      xxxxxx
20대      ....
30대      .... 
40대      ....
-------------------------   

/*
연령대를 구하려면 sysdate의 연도를 가져와서 cust_year_of_birth를 빼주면 된다
매출 금액은 sales 테이블의 amount_sold를 쓰면 된다
customers 테이블과 sales 테이블은 cust_id를 이용해 조인 해준다
*/
SELECT * FROM CUSTOMERS;
SELECT * FROM SALES;

WITH basis AS (SELECT
                    WIDTH_bUCKET(to_char(sysdate, 'yyyy') - b.cust_year_of_birth, 10, 90, 8) AS old_seg
                    , TO_CHAR(SYSDATE, 'yyyy') - b.cust_year_of_birth AS olds
                    , s.amount_sold
               FROM
                    sales s
                    , customers b
               WHERE s.sales_month = '200112'
                 AND s.cust_id = b.cust_id)
    , real_data AS (SELECT
                        old_seg * 10 || '대' AS old_segment
                        , SUM(amount_sold) AS sold_seg_amt
                    FROM basis
                    GROUP BY old_seg)
SELECT *
FROM real_data
ORDER BY old_segment;


- 4. 3번 문제를 이용해 월별로 판매금액이 가장 하위에 속하는 대륙 목록을 뽑아보자
- (대륙목록은 countries 테이블의 country_region에 있으며, country_id 컬럼으로 customers 테이블과 조인을 해서 구한다)

/*
---------------------------------   
매출월    지역(대륙)  매출금액 
---------------------------------
199801    Oceania      xxxxxx
199803    Oceania      xxxxxx
...
---------------------------------
*/

WITH basis AS (SELECT
                    c.country_region
                    , s.sales_month
                    , SUM(s.amount_sold) AS amt
               FROM
                    sales s
                    , customers b
                    , countries c
               WHERE s.cust_id = b.cust_id
                 AND b.country_id = c.country_id
               GROUP BY c.country_region, s.sales_month)
    , real_data AS (SELECT
                        sales_month
                        , country_region
                        , amt
                        , RANK() OVER (PARTITION BY sales_month ORDER BY amt) ranks
                    FROM basis)
SELECT *
FROM real_data
WHERE ranks = 1;
                    
               
- 5. 5장 연습문제 5번의 정답 결과를 이용해 다음과 같이 지역별, 대출종류별, 월별 대출잔액과 지역별 파티션을 만들어 대출종류별 대출잔액의 %를 구하는 쿼리를 작성해보자

/*
------------------------------------------------------------------------------------------------
지역    대출종류        201111         201112    201210    201211   201212   203110    201311
------------------------------------------------------------------------------------------------
서울    기타대출       73996.9( 36% )
서울    주택담보대출   130105.9( 64% ) 
부산
...
...
-------------------------------------------------------------------------------------------------
*/

/*
일단 5장의 테이블 형태와 그 코드

---------------------------------------------------------------------------------------
지역   201111   201112    201210    201211   201212   203110    201311
---------------------------------------------------------------------------------------
서울   
부산
...
...
---------------------------------------------------------------------------------------

SELECT REGION, 
       SUM(AMT1) AS "201111", 
       SUM(AMT2) AS "201112", 
       SUM(AMT3) AS "201210", 
       SUM(AMT4) AS "201211", 
       SUM(AMT5) AS "201312", 
       SUM(AMT6) AS "201310",
       SUM(AMT6) AS "201311"
  FROM ( 
         SELECT REGION,
                CASE WHEN PERIOD = '201111' THEN LOAN_JAN_AMT ELSE 0 END AMT1,
                CASE WHEN PERIOD = '201112' THEN LOAN_JAN_AMT ELSE 0 END AMT2,
                CASE WHEN PERIOD = '201210' THEN LOAN_JAN_AMT ELSE 0 END AMT3, 
                CASE WHEN PERIOD = '201211' THEN LOAN_JAN_AMT ELSE 0 END AMT4, 
                CASE WHEN PERIOD = '201212' THEN LOAN_JAN_AMT ELSE 0 END AMT5, 
                CASE WHEN PERIOD = '201310' THEN LOAN_JAN_AMT ELSE 0 END AMT6,
                CASE WHEN PERIOD = '201311' THEN LOAN_JAN_AMT ELSE 0 END AMT7
         FROM KOR_LOAN_STATUS
       )
GROUP BY REGION
ORDER BY REGION;

기존 코드에 대출 종류와 대출잔액의 %를 추가하면 된다
백분율을 구하는 것은 RATIO_TO_REPORT를 사용하면 된다
*/

WITH basis AS (SELECT
                    region
                    , gubun
                    , SUM(AMT1) AS AMT1
                    , SUM(AMT2) AS AMT2
                    , SUM(AMT3) AS AMT3
                    , SUM(AMT4) AS AMT4
                    , SUM(AMT5) AS AMT5
                    , SUM(AMT6) AS AMT6
                    , SUM(AMT7) AS AMT7
               FROM (SELECT
                        region
                        , gubun
                        , CASE WHEN period = '201111' THEN loan_jan_amt ELSE 0 END AMT1
                        , CASE WHEN period = '201112' THEN loan_jan_amt ELSE 0 END AMT2
                        , CASE WHEN period = '201210' THEN loan_jan_amt ELSE 0 END AMT3
                        , CASE WHEN period = '201211' THEN loan_jan_amt ELSE 0 END AMT4
                        , CASE WHEN period = '201212' THEN loan_jan_amt ELSE 0 END AMT5
                        , CASE WHEN period = '201310' THEN loan_jan_amt ELSE 0 END AMT6
                        , CASE WHEN period = '201311' THEN loan_jan_amt ELSE 0 END AMT7
                     FROM kor_loan_status)
               GROUP BY region, gubun)
SELECT
    region
    , gubun
    , AMT1 || '(' || ROUND(RATIO_TO_REPORT(amt1) OVER (PARTITION BY REGION), 2) * 100 || '%)' AS "201111"
    , AMT2 || '(' || ROUND(RATIO_TO_REPORT(amt2) OVER (PARTITION BY REGION), 2) * 100 || '%)' AS "201112"
    , AMT3 || '(' || ROUND(RATIO_TO_REPORT(amt3) OVER (PARTITION BY REGION), 2) * 100 || '%)' AS "201210"
    , AMT4 || '(' || ROUND(RATIO_TO_REPORT(amt4) OVER (PARTITION BY REGION), 2) * 100 || '%)' AS "201211"
    , AMT5 || '(' || ROUND(RATIO_TO_REPORT(amt5) OVER (PARTITION BY REGION), 2) * 100 || '%)' AS "201212"
    , AMT6 || '(' || ROUND(RATIO_TO_REPORT(amt6) OVER (PARTITION BY REGION), 2) * 100 || '%)' AS "201310"
    , AMT7 || '(' || ROUND(RATIO_TO_REPORT(amt7) OVER (PARTITION BY REGION), 2) * 100 || '%)' AS "201311"
FROM basis
ORDER BY region;