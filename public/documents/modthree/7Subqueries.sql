/* =========================================================
7. SUBQUERIES
========================================================= */

-- Empleados con salario mayor al promedio
SELECT first_name,
       salary
FROM employees
WHERE salary >
(
    SELECT AVG(salary)
    FROM employees
);

-- Empleados en departamentos de location 1700
SELECT first_name
FROM employees
WHERE department_id IN
(
    SELECT department_id
    FROM departments
    WHERE location_id = 1700
);

-- Empleado con salario maximo
SELECT first_name,
       salary
FROM employees
WHERE salary =
(
    SELECT MAX(salary)
    FROM employees
);