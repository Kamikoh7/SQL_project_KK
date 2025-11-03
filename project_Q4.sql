--4.Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH yearly AS (
    SELECT
        payroll_year AS year,
        AVG(avg_price_value) AS price_avg,
        AVG(avg_payroll_value) AS wage_avg
    FROM t_kamila_kohoutova_project_SQL_primary_final
    GROUP BY payroll_year
),
yoy AS (
    SELECT
        year,
        price_avg,
        wage_avg,
        LAG(price_avg) OVER(ORDER BY year) AS prev_price,
        LAG(wage_avg) OVER(ORDER BY year) AS prev_wage
    FROM yearly
)
SELECT
    year,
    ROUND((price_avg - prev_price) / prev_price * 100, 2) AS price_yoy_growth_pct,
    ROUND((wage_avg - prev_wage) / prev_wage * 100, 2) AS wage_yoy_growth_pct,
    ROUND(((price_avg - prev_price) / prev_price * 100) -
          ((wage_avg - prev_wage) / prev_wage * 100), 2) AS difference_pct
FROM yoy
WHERE prev_price IS NOT NULL
  AND prev_wage IS NOT NULL
  AND ((price_avg - prev_price) / prev_price * 100) -
      ((wage_avg - prev_wage) / prev_wage * 100) > 10
ORDER BY year;


