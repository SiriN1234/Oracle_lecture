SELECT * FROM CITIES;
SELECT * FROM SUBCON;
SELECT * FROM ECONOMIES;
SELECT * FROM POPULATIONS;
SELECT * FROM SUMMER_MEDALS;

-- 서브쿼리
-- 1번
SELECT *
FROM POPULATIONS
WHERE year = 2015
  AND life_expectancy > (SELECT AVG(life_expectancy)
                         FROM populations);
                         

-- 2번
SELECT
    a.name
    , a.country_code
    , a.urbanarea_pop
FROM
    cities a
    , subcon b
WHERE a.name = b.capital
ORDER BY urbanarea_pop DESC;


-- 3번
SELECT
    a.code
    , a.inflation_rate
    , a.unemployment_rate
    , b.gov_form
FROM
    economies a
    , (SELECT 
            gov_form
            , code
       FROM subcon
       WHERE gov_form NOT LIKE 'Constitutional Monarchy%'
         AND gov_form NOT LIKE '%Republic%'
         AND gov_form NOT LIKE '%Monarchy') b
WHERE a.code = b.code
ORDER BY a.inflation_rate;



-- 4번
SELECT
    c.country_name
    , b.continent
    , a.inf
FROM
    (SELECT continent, MAX(inflation_rate) AS inf
     FROM subcon
  	 INNER JOIN economies
     USING (code)
     WHERE year = 2015
     GROUP BY continent) a
    , (SELECT country_name, continent, inflation_rate, code
       FROM subcon
       INNER JOIN economies
       USING (code)
       WHERE year = 2015) b
    , subcon c
WHERE a.inf = b.inflation_rate
  AND b.code = c.code
ORDER BY inf;


-- window
-- 1번
SELECT
    rownum AS row_n
    , year
    , city
    , sport
    , discipline
    , athlete
FROM summer_medals;


-- 2번
    
-- 3번

-- 4번
SELECT
    Year,
    Country AS champion
  FROM summer_medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold';