{{ config(
    materialized='table',
    database='ALUMNO24_DEV_GOLD_DB',
    schema='concesionario'

) }}

WITH source AS (
    SELECT
        s.salesperson_id,
        s.branch_id,
        s.campaign_id,
        s.promotion_id,
        COUNT(s.sale_id) AS total_sales_count,
        SUM(s.sale_price_usd) AS total_sales_value,
        AVG(s.sale_price_usd) AS average_sale_value,
        SUM(s.sale_price_usd - v.price_usd) AS profit_margin,
        DATE_TRUNC('day', s.sale_date) AS sales_date
    FROM {{ ref('stg_concesionario__sales') }} s
    LEFT JOIN {{ ref('stg_concesionario__vehicles') }} v
        ON s.vehicle_id = v.vehicle_id
    GROUP BY
        s.salesperson_id,
        s.branch_id,
        s.campaign_id,
        s.promotion_id,
        DATE_TRUNC('day', s.sale_date)
)
SELECT * FROM source
