{{ config(
    materialized='table',
    database='ALUMNO24_DEV_GOLD_DB',
    schema='concesionario'
) }}

WITH finance_metrics AS (
    SELECT
        DATE_TRUNC('month', s.sale_date) AS period,
        SUM(s.final_price_usd) AS total_revenue,
        SUM(s.base_price_usd) AS total_cost,
        SUM(s.final_price_usd - s.base_price_usd) AS total_margin,
        AVG(s.final_price_usd - s.base_price_usd) AS avg_margin_per_sale
    FROM {{ ref('fact_sales') }} s
    WHERE s.is_active = TRUE
    GROUP BY DATE_TRUNC('month', s.sale_date)
)
SELECT * FROM finance_metrics
