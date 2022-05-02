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
    code
    , inflation_rate
    , unemployment_rate
FROM
    economies
WHERE year = 2015
  AND code NOT IN (SELECT code
                   FROM subcon
                   WHERE (gov_form = 'Constitutional Monarchy'
                      OR gov_form LIKE '%Republic%'))
ORDER BY inflation_rate;



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
    ROWNUM AS row_n
    , a.*
FROM summer_medals a;


-- 2번
SELECT
    year
    , ROW_NUMBER() OVER(ORDER BY year) AS row_n
FROM (SELECT DISTINCT year
      FROM summer_medals) years;


-- 3번
WITH mc AS (SELECT
                athlete
                , COUNT(*) AS medals
            FROM summer_medals
            GROUP BY athlete)
SELECT
    medals
    , athlete
    , ROW_NUMBER() OVER (ORDER BY Medals DESC) AS row_n
FROM mc
ORDER BY medals desc
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;


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
    
WITH search_gold AS (SELECT
                        year,
                        Country AS champion
                     FROM summer_medals
                     WHERE
                        Discipline = 'Weightlifting' AND
                        Event = '69KG' AND
                        Gender = 'Men' AND
                        Medal = 'Gold')
SELECT
    year
    , champion
    , LAG(Champion) OVER (ORDER BY year) AS last_champion
FROM search_gold
ORDER BY year;


