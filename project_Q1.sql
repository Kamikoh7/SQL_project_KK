--1.Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

SELECT 
	payroll_year,
	industry_branch_name,
	ROUND(AVG(avg_payroll_value), 2) AS avg_payroll_value
FROM t_kamila_kohoutova_project_SQL_primary_final
GROUP BY 
	payroll_year,
	industry_branch_name
ORDER BY 
	industry_branch_name,
	payroll_year
	;



