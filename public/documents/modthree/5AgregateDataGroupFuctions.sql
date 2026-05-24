/* =========================================================
5. AGGREGATE DATA GROUP FUNCTIONS
========================================================= */

-- Contar empleados
SELECT COUNT(*) AS total_empleados
FROM employees;

-- Promedio salarial
SELECT AVG(salary) AS promedio
FROM employees;

-- Suma total salarios
SELECT SUM(salary) AS suma_salarios
FROM employees;

-- Salario maximo
SELECT MAX(salary) AS salario_maximo
FROM employees;

-- Salario minimo
SELECT MIN(salary) AS salario_minimo
FROM employees;

-- Promedio por departamento
SELECT department_id,
       AVG(salary) AS promedio
FROM employees
GROUP BY department_id;

-- Cantidad por departamento
SELECT department_id,
       COUNT(*) AS cantidad
FROM employees
GROUP BY department_id;

-- HAVING
SELECT department_id,
       AVG(salary) AS promedio
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 5000;