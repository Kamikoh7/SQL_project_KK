--2.Kolik je možné si koupit litrů mléka a kilogramů chleba za 
--první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT  
	payroll_year,
	price_category_name,
	ROUND(AVG(avg_payroll_value), 2) AS average_payroll_value,
	ROUND(AVG(avg_price_value), 2) AS average_price_value,
	ROUND(
		AVG(avg_payroll_value) / NULLIF(AVG(avg_price_value), 0),
		2
	) AS purchasable_quantity
FROM t_kamila_kohoutova_project_SQL_primary_final
WHERE 
	payroll_year IN (
		(SELECT MIN(payroll_year) FROM t_kamila_kohoutova_project_SQL_primary_final),
		(SELECT MAX(payroll_year) FROM t_kamila_kohoutova_project_SQL_primary_final)
	)
	AND (
		price_category_name ILIKE '%mléko%'
		OR price_category_name ILIKE '%chléb%'
	)
GROUP BY 
	payroll_year,
	price_category_name
ORDER BY 
	payroll_year,
	price_category_name;