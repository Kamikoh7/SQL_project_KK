--PROJECT

--SQL: tvorba primární finální tabulky (ČR: mzdy + ceny) t_kamila_kohoutova_project_SQL_primary_final

DROP TABLE IF EXISTS t_kamila_kohoutova_project_SQL_primary_final;

CREATE TABLE t_kamila_kohoutova_project_SQL_primary_final AS
SELECT
	cpib.name AS industry_branch_name,							
	cprc.name AS price_category_name,							
	cprc.price_value AS price_value,							
	cprc.price_unit AS price_unit,								
	cpvt.name AS value_type_name,								
	cpu.name AS unit_name,										
	cpc.name AS calculation_name,								
	cp.region_code AS region_code,								 
	czr.name AS region_name,						 			
	cp.date_from,												
	to_char(cp.date_from, 'DD, MM, YYYY') AS date,
	cpay.payroll_year,											
	ROUND(AVG(cpay.value)::numeric, 2) AS avg_payroll_value,				
	ROUND(AVG(cp.value)::numeric, 2) AS avg_price_value					
FROM czechia_price cp 					
LEFT JOIN czechia_payroll cpay
	ON cpay.payroll_year = date_part('year', cp.date_from)  	
LEFT JOIN czechia_payroll_industry_branch cpib 					
	ON cpib.code = cpay.industry_branch_code			
LEFT JOIN czechia_price_category cprc 							
	ON cprc.code = cp.category_code
LEFT JOIN czechia_payroll_calculation cpc 
	ON cpc.code = cpay.calculation_code
LEFT JOIN czechia_payroll_unit cpu 
	ON cpu.code = cpay.unit_code
LEFT JOIN czechia_payroll_value_type cpvt 
	ON cpvt.code = cpay.value_type_code
LEFT JOIN czechia_region czr
	ON cp.region_code = czr.code
WHERE
	cp.region_code IS NULL 								 	
	AND cpay.value_type_code  = 5958					
	AND cp.value IS NOT NULL
	AND cpay.value IS NOT NULL
GROUP BY
	industry_branch_name,								 
	price_category_name,
	price_value,
	price_unit,
	value_type_name,
	unit_name,
	calculation_name,
	region_code,
	region_name,
	date_from,
	date,
	payroll_year
ORDER BY
	cpay.payroll_year,
	cp.date_from,
	cpib.name
	;