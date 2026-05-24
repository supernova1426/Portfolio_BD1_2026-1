/* =========================================================
6. JOINS
========================================================= */

-- INNER JOIN
SELECT E.first_name,
       D.department_name
FROM employees E
INNER JOIN departments D
ON E.department_id = D.department_id;

-- LEFT JOIN
SELECT E.first_name,
       D.department_name
FROM employees E
LEFT JOIN departments D
ON E.department_id = D.department_id;

-- RIGHT JOIN
SELECT E.first_name,
       D.department_name
FROM employees E
RIGHT JOIN departments D
ON E.department_id = D.department_id;

-- FULL OUTER JOIN
SELECT E.first_name,
       D.department_name
FROM employees E
FULL OUTER JOIN departments D
ON E.department_id = D.department_id;

-- CROSS JOIN
SELECT E.first_name,
       D.department_name
FROM employees E
CROSS JOIN departments D;

-- NATURAL JOIN
SELECT first_name,
       department_name
FROM employees
NATURAL JOIN departments;

-- JOIN multiple
SELECT E.first_name,
       R.region_name
FROM employees E
INNER JOIN departments D
ON E.department_id = D.department_id
INNER JOIN locations L
ON D.location_id = L.location_id
INNER JOIN countries C
ON L.country_id = C.country_id
INNER JOIN regions R
ON C.region_id = R.region_id;

-- Empleados sin departamento
SELECT E.first_name,
       D.department_name
FROM employees E
LEFT JOIN departments D
ON E.department_id = D.department_id
WHERE D.department_id IS NULL;