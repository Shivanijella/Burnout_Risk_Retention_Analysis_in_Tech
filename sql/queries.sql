CREATE DATABASE burnout_project;
USE burnout_project;

SELECT COUNT(*) AS total_rows
FROM burnout_analysis;

DESCRIBE burnout_analysis;

SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'burnout_project'
  AND TABLE_NAME = 'burnout_analysis';
  
SELECT
    COUNT(DISTINCT country) AS total_countries
FROM burnout_analysis;

SELECT COUNT(DISTINCT job_role) AS total_job_roles
FROM burnout_analysis;

SELECT burnout_level, COUNT(*) AS employees
FROM burnout_analysis
GROUP BY burnout_level
ORDER BY employees DESC;

SELECT work_mode, COUNT(*) AS employees
FROM burnout_analysis
GROUP BY work_mode;

SELECT company_size,
    COUNT(*) AS employees
FROM burnout_analysis
GROUP BY company_size
ORDER BY employees DESC;

SELECT ROUND(AVG(burnout_score),2) AS avg_burnout,
MIN(burnout_score) AS min_burnout,
MAX(burnout_score) AS max_burnout,

ROUND(AVG(stress_score),2) AS avg_stress,
ROUND(AVG(work_hours_per_week),2) AS avg_work_hours,
ROUND(AVG(sleep_hours_per_night),2) AS avg_sleep
FROM burnout_analysis;

SELECT
SUM(CASE WHEN burnout_score IS NULL THEN 1 ELSE 0 END) AS burnout_nulls,
SUM(CASE WHEN stress_score IS NULL THEN 1 ELSE 0 END) AS stress_nulls,
SUM(CASE WHEN work_hours_per_week IS NULL THEN 1 ELSE 0 END) AS work_hours_nulls,
SUM(CASE WHEN sleep_hours_per_night IS NULL THEN 1 ELSE 0 END) AS sleep_nulls
FROM burnout_analysis;

SELECT job_role,
COUNT(*) AS flight_risk_employees
FROM burnout_analysis
WHERE persona = 'Flight Risk'
GROUP BY job_role
ORDER BY flight_risk_employees DESC;

SELECT industry,
COUNT(*) AS early_risk_employees
FROM burnout_analysis
WHERE persona = 'Early Risk'
GROUP BY industry
ORDER BY early_risk_employees DESC;

SELECT company_size,
COUNT(*) AS flight_risk_employees
FROM burnout_analysis
WHERE persona = 'Flight Risk'
GROUP BY company_size
ORDER BY flight_risk_employees DESC;

SELECT country,
ROUND(AVG(burnout_score),2) AS avg_burnout
FROM burnout_analysis
GROUP BY country
ORDER BY avg_burnout DESC;

SELECT persona,
ROUND(AVG(salary_usd),2) AS avg_salary,
ROUND(AVG(burnout_score),2) AS avg_burnout
FROM burnout_analysis
GROUP BY persona
ORDER BY avg_salary DESC;

SELECT employee_id,country,job_role,burnout_level,burnout_score
FROM burnout_analysis
WHERE burnout_level = 'Severe'
  AND therapy_access = 0;
  
SELECT persona,
COUNT(*) AS employees,
ROUND(AVG(job_change_intention) * 100,2) AS job_change_rate
FROM burnout_analysis
GROUP BY persona
ORDER BY job_change_rate DESC;

SELECT persona,
ROUND(AVG(uses_therapy) * 100,2) AS therapy_usage_percent
FROM burnout_analysis
GROUP BY persona
ORDER BY therapy_usage_percent DESC;

SELECT *
FROM (
    SELECT
        employee_id,
        country,
        job_role,
        burnout_score,
        RANK() OVER (
            PARTITION BY country
            ORDER BY burnout_score DESC
        ) AS burnout_rank
    FROM burnout_analysis
) ranked
WHERE burnout_rank <= 5;

SELECT industry,
ROUND(AVG(burnout_score),2) AS avg_burnout,
    DENSE_RANK() OVER(
        ORDER BY AVG(burnout_score) DESC
    ) AS burnout_rank
FROM burnout_analysis
GROUP BY industry;

WITH burnout_summary AS
(
SELECT
persona,
ROUND(AVG(burnout_score),2) AS avg_burnout
FROM burnout_analysis
GROUP BY persona
)
SELECT *
FROM burnout_summary
ORDER BY avg_burnout DESC;

SELECT
employee_id,
job_role,
burnout_score
FROM burnout_analysis
WHERE burnout_score >
(
SELECT AVG(burnout_score)
FROM burnout_analysis
);

SELECT
employee_id,
salary_usd,
burnout_score,
job_role
FROM burnout_analysis
WHERE salary_usd >
(
SELECT AVG(salary_usd)
FROM burnout_analysis
)
AND burnout_score >
(
SELECT AVG(burnout_score)
FROM burnout_analysis
);

CREATE VIEW high_risk_employees AS
SELECT
employee_id,
country,
job_role,
persona,
burnout_score
FROM burnout_analysis
WHERE persona IN
('Flight Risk','Early Risk');

SELECT *
FROM high_risk_employees;
SELECT
employee_id,
burnout_score,
CASE
WHEN burnout_score >= 8 THEN 'Critical'
WHEN burnout_score >= 6 THEN 'High'
WHEN burnout_score >= 4 THEN 'Moderate'
ELSE 'Low'
END AS burnout_status
FROM burnout_analysis;

SELECT
employee_id,
country,
job_role,
burnout_score
FROM burnout_analysis
ORDER BY burnout_score DESC
LIMIT 10;