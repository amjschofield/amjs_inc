
-- 01_payroll_table.sql

SELECT 
    pe.payroll_entry_id,
    pe.payroll_run_id,
    pe.employee_id,
    pe.gross_pay,
    pe.overtime_pay,
    pe.bonus_pay,
    pr.pay_period,
    d.department_name
FROM 
    `employee-data-project-507314.employee_dataset.payroll_entries` pe

JOIN
    `employee-data-project-507314.employee_dataset.payroll_runs` pr
ON
    pe.payroll_run_id = pr.payroll_run_id

JOIN
    `employee-data-project-507314.employee_dataset.employees` e
ON
    pe.employee_id = e.employee_id

JOIN
    `employee-data-project-507314.employee_dataset.departments` d
ON
    e.department_id = d.department_id
