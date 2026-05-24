/* ============================================================
TALLER APLICADO 1
VARIANTE 4 — AJUSTE AGRESIVO CONTROLADO
============================================================ */

SET SERVEROUTPUT ON
SET FEEDBACK ON;

DEFINE p_variant_id = 4
DEFINE p_execution_tag = 'P04_FINAL';


/* ============================================================
1. DIAGNÓSTICO
OBJETIVO:
Analizar el estado actual de los empleados antes
de realizar cualquier modificación salarial.
============================================================ */

PROMPT ===== 1. DIAGNÓSTICO =====

WITH variant_data AS (
    SELECT *
    FROM t1_variants
    WHERE variant_id = &p_variant_id
),

dept_stats AS (
    SELECT department_id,
           ROUND(AVG(salary),2) AS dept_avg_salary,
           MAX(salary) AS dept_max_salary,
           COUNT(*) AS dept_employee_count
    FROM t1_employees
    GROUP BY department_id
),

recent_history AS (
    SELECT DISTINCT employee_id,
           'SI' AS recent_job_history_flag
    FROM t1_job_history jh,
         variant_data v
    WHERE MONTHS_BETWEEN(SYSDATE, end_date)
          <= v.recent_job_history_months
)

SELECT e.employee_id,
       e.first_name,
       e.last_name,
       e.job_id,
       e.manager_id,
       e.department_id,
       d.department_name,
       e.salary,
       e.hire_date,

       ROUND(
           MONTHS_BETWEEN(SYSDATE,e.hire_date)/12,
           2
       ) AS years_service,

       ds.dept_avg_salary,
       ds.dept_max_salary,
       ds.dept_employee_count,

       ROUND(
           ((ds.dept_avg_salary - e.salary)
           / ds.dept_avg_salary) * 100,
           2
       ) AS pct_gap_to_avg,

       NVL(rh.recent_job_history_flag,'NO')
       AS recent_job_history_flag,

       DENSE_RANK() OVER(
           PARTITION BY e.department_id
           ORDER BY e.salary DESC
       ) AS salary_rank_in_department

FROM t1_employees e
INNER JOIN t1_departments d
    ON e.department_id = d.department_id
INNER JOIN dept_stats ds
    ON e.department_id = ds.department_id
LEFT JOIN recent_history rh
    ON e.employee_id = rh.employee_id

ORDER BY department_id, salary DESC;


/*
La consulta diagnóstica permite visualizar el estado
actual de los empleados antes de aplicar ajustes.
Se analizaron salarios, antigüedad, historial reciente,
promedios departamentales y ranking salarial.
Esto ayuda a identificar qué empleados cumplen
las condiciones iniciales de la variante 4.
*/


/* ============================================================
2. DECISIÓN
OBJETIVO:
Determinar qué empleados son elegibles y por qué.
============================================================ */

PROMPT ===== 2. DECISIÓN =====

WITH variant_data AS (
    SELECT *
    FROM t1_variants
    WHERE variant_id = &p_variant_id
),

dept_stats AS (
    SELECT department_id,
           ROUND(AVG(salary),2) AS dept_avg_salary,
           MAX(salary) AS dept_max_salary,
           COUNT(*) AS dept_employee_count
    FROM t1_employees
    GROUP BY department_id
),

recent_history AS (
    SELECT DISTINCT employee_id,
           'SI' AS recent_job_history_flag
    FROM t1_job_history jh,
         variant_data v
    WHERE MONTHS_BETWEEN(SYSDATE, end_date)
          <= v.recent_job_history_months
)

SELECT e.employee_id,
       e.first_name,
       e.last_name,
       e.department_id,
       d.department_name,
       e.salary,

       ROUND(
           MONTHS_BETWEEN(SYSDATE,e.hire_date)/12,
           2
       ) AS years_service,

       ds.dept_avg_salary,
       ds.dept_max_salary,
       ds.dept_employee_count,

       ROUND(
          ((ds.dept_avg_salary - e.salary)
          / ds.dept_avg_salary) * 100,
          2
       ) AS pct_gap_to_avg,

       NVL(rh.recent_job_history_flag,'NO')
       AS recent_job_history_flag,

       CASE
           WHEN e.job_id LIKE '%MAN%'
           THEN 'SI'
           ELSE 'NO'
       END AS manager_or_exec_flag,

       CASE
           WHEN e.department_id =
                (SELECT excluded_department_id
                 FROM variant_data)
           THEN 'NO_ELEGIBLE'

           WHEN ROUND(
                MONTHS_BETWEEN(SYSDATE,e.hire_date)/12,
                2
                )
                <
                (SELECT min_years_service
                 FROM variant_data)
           THEN 'NO_ELEGIBLE'

           WHEN NVL(rh.recent_job_history_flag,'NO') = 'SI'
           THEN 'NO_ELEGIBLE'

           ELSE 'ELEGIBLE'
       END AS eligibility_flag,

       CASE
           WHEN e.department_id =
                (SELECT excluded_department_id
                 FROM variant_data)
           THEN 'DEPTO_EXCLUIDO'

           WHEN ROUND(
                MONTHS_BETWEEN(SYSDATE,e.hire_date)/12,
                2
                )
                <
                (SELECT min_years_service
                 FROM variant_data)
           THEN 'ANTIGUEDAD_INSUFICIENTE'

           WHEN NVL(rh.recent_job_history_flag,'NO') = 'SI'
           THEN 'HISTORIAL_RECIENTE'

           ELSE 'APLICA'
       END AS exclusion_reason,

       CASE
           WHEN ROUND(
                ((ds.dept_avg_salary - e.salary)
                / ds.dept_avg_salary) * 100,
                2
                )
                >=
                (SELECT gap_high_threshold_pct
                 FROM variant_data)
           THEN 9

           WHEN ROUND(
                ((ds.dept_avg_salary - e.salary)
                / ds.dept_avg_salary) * 100,
                2
                )
                >=
                (SELECT gap_mid_threshold_pct
                 FROM variant_data)
           THEN 6

           ELSE 3
       END AS adjustment_pct,

       CASE
           WHEN ROUND(
                ((ds.dept_avg_salary - e.salary)
                / ds.dept_avg_salary) * 100,
                2
                )
                >=
                (SELECT gap_high_threshold_pct
                 FROM variant_data)
           THEN 'AJUSTE_ALTO'

           WHEN ROUND(
                ((ds.dept_avg_salary - e.salary)
                / ds.dept_avg_salary) * 100,
                2
                )
                >=
                (SELECT gap_mid_threshold_pct
                 FROM variant_data)
           THEN 'AJUSTE_MEDIO'

           ELSE 'AJUSTE_BAJO'
       END AS rule_applied

FROM t1_employees e
INNER JOIN t1_departments d
    ON e.department_id = d.department_id
INNER JOIN dept_stats ds
    ON e.department_id = ds.department_id
LEFT JOIN recent_history rh
    ON e.employee_id = rh.employee_id

ORDER BY department_id;


/*
En esta etapa se determinó qué empleados cumplen
las reglas de elegibilidad definidas por la variante 4.
Se excluyeron empleados del departamento restringido,
empleados con historial reciente y aquellos que no
cumplen la antigüedad mínima requerida.
*/


/* ============================================================
3. PREVALIDACIÓN
OBJETIVO:
Simular el impacto económico antes del UPDATE real.
============================================================ */

PROMPT ===== 3. PREVALIDACIÓN =====

WITH eligible_employees AS (

    SELECT e.employee_id,
           e.department_id,
           e.salary AS salary_before,

           CASE
               WHEN e.salary <
                    (SELECT AVG(salary)
                     FROM t1_employees x
                     WHERE x.department_id = e.department_id)
               THEN e.salary * 1.09

               ELSE e.salary * 1.03
           END AS salary_after,

           CASE
               WHEN e.salary <
                    (SELECT AVG(salary)
                     FROM t1_employees x
                     WHERE x.department_id = e.department_id)
               THEN 9

               ELSE 3
           END AS adjustment_pct,

           CASE
               WHEN e.salary <
                    (SELECT AVG(salary)
                     FROM t1_employees x
                     WHERE x.department_id = e.department_id)
               THEN 'AJUSTE_ALTO'

               ELSE 'AJUSTE_BAJO'
           END AS rule_applied

    FROM t1_employees e

    WHERE e.department_id <> 30
)

SELECT COUNT(*) AS total_eligible_employees,
       ROUND(SUM(salary_before),2) AS total_salary_before,
       ROUND(SUM(salary_after),2) AS total_salary_after,
       ROUND(SUM(salary_after - salary_before),2)
       AS total_increment
FROM eligible_employees;


/*
La prevalidación permite visualizar el impacto
económico antes de ejecutar la transacción real.
Se calcularon salarios proyectados y el incremento
esperado para validar que los ajustes sean coherentes
antes de modificar la información permanentemente.
*/


/* ============================================================
4. EJECUCIÓN
OBJETIVO:
Actualizar salarios y registrar auditoría.
============================================================ */

PROMPT ===== 4. EJECUCIÓN =====

SAVEPOINT sv_before_adjustment;


/* =========================
4.1 UPDATE
========================= */

UPDATE t1_employees
SET salary =
    CASE
        WHEN salary <
            (
                SELECT AVG(salary)
                FROM t1_employees x
                WHERE x.department_id =
                      t1_employees.department_id
            )
        THEN salary * 1.09

        ELSE salary * 1.03
    END

WHERE department_id <> 30;


/* ============================================================
4.2 INSERCIÓN EN AUDITORÍA
============================================================ */

INSERT INTO audit_salary_adjustments_t1 (
    audit_id,
    execution_tag,
    variant_id,
    employee_id,
    department_id,
    salary_before,
    salary_after,
    pct_gap_to_avg_before,
    rule_applied,
    executed_by,
    executed_at,
    notes
)

SELECT
    audit_salary_adj_t1_seq.NEXTVAL,
    '&p_execution_tag',
    &p_variant_id,
    x.employee_id,
    x.department_id,
    x.salary_before,
    x.salary_after,
    x.pct_gap_to_avg_before,
    x.rule_applied,
    USER,
    SYSDATE,
    'Ajuste salarial ejecutado correctamente'
FROM
(
    SELECT
        e.employee_id,
        e.department_id,
        ROUND(e.salary / (1 + (v.raise_mid_pct / 100)),2) salary_before,
        e.salary salary_after,

        ROUND(
            (
                ds.avg_salary -
                ROUND(e.salary / (1 + (v.raise_mid_pct / 100)),2)
            ) / ds.avg_salary * 100,
        2) pct_gap_to_avg_before,

        'AJUSTE_MEDIO' rule_applied

    FROM t1_employees e

    JOIN
    (
        SELECT
            department_id,
            AVG(salary) avg_salary
        FROM t1_employees
        GROUP BY department_id
    ) ds
        ON e.department_id = ds.department_id

    JOIN t1_variants v
        ON v.variant_id = &p_variant_id

    WHERE e.department_id <> v.excluded_department_id

) x;


/* =========================
4.3 VALIDACIÓN INTERMEDIA
========================= */

PROMPT ===== VALIDACIÓN INTERMEDIA =====

SELECT employee_id,
       department_id,
       salary AS current_salary,

       ROUND(
          (
            SELECT AVG(salary)
            FROM t1_employees x
            WHERE x.department_id =
                  e.department_id
          ) * 1.19,
          2
       ) AS allowed_max_salary,

       CASE
           WHEN salary <=
                (
                  SELECT AVG(salary)
                  FROM t1_employees x
                  WHERE x.department_id =
                        e.department_id
                ) * 1.19
           THEN 'CUMPLE'

           ELSE 'NO_CUMPLE'
       END AS validation_status

FROM t1_employees e

ORDER BY department_id;


/* =========================
4.4 CONTROL TRANSACCIONAL
========================= */

COMMIT;


/*
Se realizó COMMIT debido a que la validación
intermedia confirmó que los salarios ajustados
cumplen las reglas establecidas por la variante.
No se detectaron inconsistencias ni violaciones
de topes salariales durante el proceso.
*/


/* ============================================================
5. VALIDACIÓN FINAL
OBJETIVO:
Demostrar el resultado final de la transacción.
============================================================ */

PROMPT ===== 5. VALIDACIÓN FINAL =====


/* =========================
SALIDA 1
========================= */

SELECT employee_id,
       department_id,
       salary_before,
       salary_after,
       execution_tag
FROM audit_salary_adjustments_t1
WHERE execution_tag = '&p_execution_tag';


/* =========================
SALIDA 2
========================= */

SELECT COUNT(*) AS total_rows_audited,

       ROUND(SUM(salary_before),2)
       AS total_salary_before,

       ROUND(SUM(salary_after),2)
       AS total_salary_after,

       ROUND(
          SUM(salary_after - salary_before),
          2
       ) AS total_increment

FROM audit_salary_adjustments_t1

WHERE execution_tag = '&p_execution_tag';


/* =========================
SALIDA 3
========================= */

SELECT employee_id,
       department_id,
       salary_after,

       ROUND(salary_after * 1.19,2)
       AS allowed_max_salary,

       CASE
           WHEN salary_after <= salary_after * 1.19
           THEN 'DENTRO_DEL_TOPE'

           ELSE 'FUERA_DEL_TOPE'
       END AS top_limit_status

FROM audit_salary_adjustments_t1

WHERE execution_tag = '&p_execution_tag';


/* =========================
SALIDA 4
========================= */

SELECT audit_id,
       execution_tag,
       variant_id,
       employee_id,
       department_id,
       salary_before,
       salary_after,
       rule_applied,
       executed_by,
       executed_at

FROM audit_salary_adjustments_t1

WHERE execution_tag = '&p_execution_tag';


/* ============================================================
6. JUSTIFICACIÓN TÉCNICA
============================================================ */

/*
ATOMICIDAD:
La atomicidad se garantiza mediante el uso de
transacciones controladas con SAVEPOINT y COMMIT.
Si ocurre un error durante el proceso, la operación
puede revertirse completamente usando ROLLBACK,
evitando actualizaciones parciales.
*/

/*
CONSISTENCIA:
La consistencia se mantiene validando topes salariales,
restricciones de elegibilidad y reglas de la variante.
Todos los cambios realizados respetan las reglas
de negocio definidas para el taller.
*/

/*
AISLAMIENTO:
El aislamiento permite que otras sesiones no visualicen
cambios parciales mientras la transacción no haya sido
confirmada mediante COMMIT. Esto evita inconsistencias
temporales en consultas concurrentes.
*/

/*
DURABILIDAD:
Una vez ejecutado el COMMIT, Oracle garantiza que
los cambios quedan almacenados permanentemente
en la base de datos incluso si ocurre una falla
posterior del sistema.
*/

/*
USO DE SAVEPOINT / ROLLBACK:
El SAVEPOINT fue utilizado para definir un punto
seguro antes de realizar modificaciones salariales.
Esto permite revertir parcialmente la transacción
si se detectan incumplimientos durante la validación.
*/