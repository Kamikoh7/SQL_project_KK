--5.Má výška HDP vliv na změny ve mzdách a cenách potravin? 
--Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin 
--či mzdách ve stejném nebo následujícím roce výraznějším růstem?

WITH gdp_data AS (
    SELECT 
        country_name,
        year,
        gdp_current_usd,
        gdp_growth_pct
    FROM t_kamila_kohoutova_project_SQL_secondary_final
    WHERE country_name = 'Czech Republic'              -- Zaměření na ČR
),
wages_prices AS (
    SELECT 
        payroll_year AS year,
        ROUND(AVG(avg_payroll_value)::numeric, 2) AS avg_wage,
        ROUND(AVG(avg_price_value)::numeric, 2) AS avg_price
    FROM t_kamila_kohoutova_project_SQL_primary_final
    GROUP BY payroll_year
)
SELECT 
    w.year,
    g.gdp_current_usd,
    g.gdp_growth_pct,
    w.avg_wage,
    w.avg_price,
    ROUND(((w.avg_wage / LAG(w.avg_wage) OVER (ORDER BY w.year)) - 1) * 100::numeric, 2) AS wage_growth_pct,
    ROUND(((w.avg_price / LAG(w.avg_price) OVER (ORDER BY w.year)) - 1) * 100::numeric, 2) AS price_growth_pct
FROM wages_prices w
JOIN gdp_data g 
    ON g.year = w.year
ORDER BY w.year;


