/* =========================================================
1. SELECT
========================================================= */

-- Mostrar todos los empleados
SELECT *
FROM employees;

-- Mostrar columnas especificas
SELECT first_name,
       last_name,
       salary
FROM employees;

-- Alias con AS
SELECT first_name AS nombre,
       salary AS sueldo
FROM employees;

-- Concatenacion de datos
SELECT last_name || ' trabaja como ' || job_id AS empleado
FROM employees;

-- Concatenacion usando q'[ ]'
SELECT department_name || q'[ - Manager ID: ]'
|| manager_id AS informacion
FROM departments;