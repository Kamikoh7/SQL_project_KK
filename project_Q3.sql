--3.Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
											-- 10 nejpomaleji zdražujících kategorií
WITH yearly_avg AS (
    SELECT 
        price_category_name,
        EXTRACT(YEAR FROM date_from) AS year,
        ROUND(AVG(avg_price_value), 2) AS avg_price
    FROM t_kamila_kohoutova_project_SQL_primary_final
    	GROUP BY price_category_name, EXTRACT(YEAR FROM date_from)
					),
growth AS (
    SELECT 
        price_category_name,
        year,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY price_category_name ORDER BY year) AS prev_year_price,
        ROUND(
            ((avg_price - LAG(avg_price) OVER (PARTITION BY price_category_name ORDER BY year))
             / NULLIF(LAG(avg_price) OVER (PARTITION BY price_category_name ORDER BY year), 0)) * 100, 
         2
        ) AS yoy_growth
    FROM yearly_avg
)
SELECT 
    price_category_name,
    ROUND(AVG(yoy_growth), 2) AS avg_yearly_growth_percent
FROM growth
	WHERE yoy_growth IS NOT NULL
	GROUP BY price_category_name
	ORDER BY avg_yearly_growth_percent ASC
	LIMIT 10;

