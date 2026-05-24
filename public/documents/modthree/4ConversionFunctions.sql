/* =========================================================
4. CONVERSION FUNCTIONS
========================================================= */

-- Numero a texto
SELECT TO_CHAR(salary) AS salario_texto
FROM employees;

-- Fecha a texto
SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY') AS fecha
FROM dual;

-- Texto a numero
SELECT TO_NUMBER('100') AS numero
FROM dual;

-- Texto a fecha
SELECT TO_DATE('19/05/2026','DD/MM/YYYY') AS fecha_convertida
FROM dual;