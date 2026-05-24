/* =========================================================
8. SET OPERATIONS
========================================================= */

-- UNION
SELECT first_name
FROM employees
UNION
SELECT department_name
FROM departments;

-- UNION ALL
SELECT first_name
FROM employees
UNION ALL
SELECT department_name
FROM departments;

-- INTERSECT
SELECT department_id
FROM employees
INTERSECT
SELECT department_id
FROM departments;

-- MINUS
SELECT department_id
FROM departments
MINUS
SELECT department_id
FROM employees;