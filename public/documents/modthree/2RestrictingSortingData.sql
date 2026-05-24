/* =========================================================
2. RESTRICTING AND SORTING DATA
========================================================= */

-- Empleados del departamento 80
SELECT first_name,
       department_id
FROM employees
WHERE department_id = 80;

-- Salarios mayores a 5000
SELECT first_name,
       salary
FROM employees
WHERE salary > 5000;

-- Salarios entre 2000 y 5000
SELECT first_name,
       salary
FROM employees
WHERE salary BETWEEN 2000 AND 5000;

-- Departamentos especificos
SELECT first_name,
       department_id
FROM employees
WHERE department_id IN (10,20,30);

-- Nombres que empiezan por A
SELECT first_name
FROM employees
WHERE first_name LIKE 'A%';

-- Nombres donde la tercera letra es m
SELECT first_name
FROM employees
WHERE first_name LIKE '__m%';

-- Valores NO NULL
SELECT first_name
FROM employees
WHERE manager_id IS NOT NULL;

-- Uso de AND
SELECT first_name,
       salary
FROM employees
WHERE first_name LIKE 'A%'
AND salary >= 1000;

-- Uso de OR
SELECT first_name,
       salary
FROM employees
WHERE salary < 5000
OR department_id = 50;

-- Orden ascendente
SELECT first_name,
       salary
FROM employees
ORDER BY salary ASC;

-- Orden descendente
SELECT first_name,
       salary
FROM employees
ORDER BY salary DESC;