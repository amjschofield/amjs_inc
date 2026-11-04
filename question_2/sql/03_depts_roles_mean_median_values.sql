
-- Establish a master table from which to pull and perform calculations. This version pulls through department as well as performance rating.

WITH joined_table AS (
    SELECT 
        pr.review_id,
        pr.employee_id,
        jr.role_title,
        d.department_name,
        pr.review_year,
        pr.performance_rating,
        pr.promotion_flag,
        c.annual_salary
    FROM 
        `employee-data-project-507314.employee_dataset.performance_reviews` pr
    
    JOIN
        `employee-data-project-507314.employee_dataset.compensation` c
    ON
        pr.employee_id = c.employee_id
    
    JOIN
        `employee-data-project-507314.employee_dataset.employees` e
    ON
        pr.employee_id = e.employee_id

    JOIN
        `employee-data-project-507314.employee_dataset.departments` d
    ON
        e.department_id = d.department_id

    JOIN
        `employee-data-project-507314.employee_dataset.job_roles` jr
    ON
        e.role_id = jr.role_id

    WHERE
        pr.review_year = 2024
),

-- SELECT * FROM joined_table

-- Establish a column that shows mean salary from master table.

salary_summary AS (
    SELECT
        department_name,
        role_title,
        performance_rating,
        COUNT(DISTINCT employee_id) AS employee_count,
        AVG(annual_salary) AS mean_salary
    FROM 
        joined_table
    GROUP BY
        department_name,
        role_title,
        performance_rating
),

-- Establish a column that shows median salary from master table.

median_summary AS (
    SELECT DISTINCT
        department_name,
        role_title,
        performance_rating,
        PERCENTILE_CONT(annual_salary, 0.5) OVER (
            PARTITION BY 
                department_name,
                role_title,
                performance_rating
        ) AS median_salary
    FROM 
        joined_table
)

-- Pull through final result. Select columns from calculated tables and aggregate by department, role title, and performance rating to show any relationship between performance and compensation across each department.

SELECT
    s.department_name,
    s.role_title,
    s.performance_rating,
    s.employee_count,
    ROUND(s.mean_salary, 2) AS mean_salary,
    ROUND(m.median_salary, 2) AS median_salary
FROM 
    salary_summary s
JOIN 
    median_summary m
USING 
    (
        department_name,
        role_title,
        performance_rating
    )
ORDER BY 
    s.department_name,
    s.role_title,
    s.performance_rating;
    