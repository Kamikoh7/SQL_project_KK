--SQL: tvorba sekundarni  tabulky t_kamila_kohoutova_project_SQL_secondary_final

SELECT*
FROM economies;

DROP TABLE IF EXISTS t_kamila_kohoutova_project_SQL_secondary_final;

CREATE TABLE t_kamila_kohoutova_project_SQL_secondary_final AS
SELECT
    c.country AS country_name,                    
    e.year,                                       
    e.gdp AS gdp_current_usd,                     
    ROUND(((e.gdp / LAG(e.gdp) OVER (PARTITION BY c.country ORDER BY e.year) - 1) * 100)::numeric, 2) 
        AS gdp_growth_pct,                        
    e.population,                                 
    e.gini,                                       
    e.taxes AS tax_revenue_percent_gdp,           
    c.continent                                   
FROM countries c
JOIN economies e 
    ON c.country = e.country
WHERE e.year BETWEEN 2006 AND 2018                
  AND c.continent = 'Europe'                       
ORDER BY c.country, e.year;







