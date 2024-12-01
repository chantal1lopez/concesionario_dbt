{{ config(
    materialized='table',
    database='ALUMNO24_DEV_GOLD_DB',
    schema='concesionario'
) }}

WITH employee_performance AS (
    SELECT
        sp.salesperson_id,
        sp.name AS salesperson_name,
        DATE_TRUNC('month', s.sale_date) AS performance_month,
        COUNT(s.sale_id) AS total_sales,
        SUM(s.sale_price_usd) AS total_sales_revenue,
        AVG(s.sale_price_usd) AS avg_sale_value,
        COALESCE(SUM(serv.cost_usd), 0) AS total_services_cost,
        COUNT(serv.service_id) AS total_services_performed
    FROM {{ ref('stg_concesionario__sales') }} s
    LEFT JOIN {{ ref('stg_concesionario__salespeople') }} sp
        ON s.salesperson_id = sp.salesperson_id
    LEFT JOIN {{ ref('stg_concesionario__services') }} serv
        ON sp.salesperson_id = serv.mechanic_id
    WHERE s.is_active = TRUE OR serv.is_active = TRUE
    GROUP BY
        sp.salesperson_id,
        sp.name,
        DATE_TRUNC('month', s.sale_date)
)
SELECT * FROM employee_performance
