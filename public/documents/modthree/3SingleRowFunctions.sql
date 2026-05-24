/* =========================================================
3. SINGLE ROW FUNCTIONS
========================================================= */

-- Convertir a mayusculas
SELECT UPPER(first_name) AS nombre_mayuscula
FROM employees;

-- Convertir a minusculas
SELECT LOWER(first_name) AS nombre_minuscula
FROM employees;

-- Primera letra en mayuscula
SELECT INITCAP(first_name) AS nombre_formato
FROM employees;

-- Cantidad de caracteres
SELECT LENGTH(first_name) AS longitud
FROM employees;

-- Extraer caracteres
SELECT SUBSTR(first_name,1,3) AS letras
FROM employees;

-- Redondear numeros
SELECT ROUND(123.456,2) AS redondeado
FROM dual;

-- Truncar numeros
SELECT TRUNC(123.456,2) AS truncado
FROM dual;

-- Residuo de division
SELECT MOD(10,3) AS residuo
FROM dual;

-- Fecha actual
SELECT SYSDATE
FROM dual;