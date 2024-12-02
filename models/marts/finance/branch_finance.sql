{{ config(
    materialized='view',
    schema='concesionario',
    database='ALUMNO24_DEV_GOLD_DB'
) }}

WITH branch_finance AS (
    SELECT
        b.branch_id,
        b.branch_name,
        DATE_TRUNC('month', s.sale_date) AS period,
        SUM(s.final_price_usd) AS total_revenue,
        SUM(s.base_price_usd) AS total_cost,
        SUM(s.final_price_usd - s.base_price_usd) AS total_margin
    FROM {{ ref('fact_sales') }} s
    LEFT JOIN {{ ref('dim_branch') }} b
        ON s.branch_id = b.branch_id
    WHERE s.is_active = TRUE
    GROUP BY b.branch_id, b.branch_name, DATE_TRUNC('month', s.sale_date)
)
SELECT * FROM branch_finance
