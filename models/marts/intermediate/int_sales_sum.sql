{{ config(
    materialized='incremental', 
    unique_key='sale_id'  
) }}

WITH
    cte_base_sales AS (
        SELECT
            s.sale_id,
            s.sale_date,
            s.customer_id,
            s.vehicle_id,
            s.sale_price_usd,
            s.financing_type,
            s.salesperson_id,
            s.branch_id,
            s.campaign_id,
            s.promotion_id,
            s.last_updated_utc,
            s.is_active,
            v.price_usd AS vehicle_price_usd,
            p.discount_type AS promotion_type,
            p.discount_value AS promotion_discount_value
        FROM {{ ref("stg_concesionario__sales") }} s
        LEFT JOIN {{ ref("stg_concesionario__vehicles") }} v ON s.vehicle_id = v.vehicle_id
        LEFT JOIN {{ ref("stg_concesionario__promotions") }} p
            ON s.promotion_id = p.promotion_id
            AND s.sale_date BETWEEN p.start_date AND p.end_date
    ),

    cte_sales_metrics AS (
        SELECT
            sale_id,
            sale_date,
            customer_id,
            vehicle_id,
            sale_price_usd AS final_price_usd,
            vehicle_price_usd AS base_price_usd,
            financing_type,
            promotion_type,
            salesperson_id,
            branch_id,
            campaign_id,
            promotion_id,
            last_updated_utc,
            is_active,
            CASE
                WHEN vehicle_price_usd > sale_price_usd THEN vehicle_price_usd - sale_price_usd
                ELSE 0
            END AS discount_value,
            sale_price_usd - vehicle_price_usd AS profit_margin
        FROM cte_base_sales
    )

{% if is_incremental() %}
, cte_max_values AS (
    SELECT
        MAX(sale_date) AS max_sale_date,
        MAX(last_updated_utc) AS max_last_updated_utc
    FROM {{ this }}
)
{% endif %}

SELECT *
FROM cte_sales_metrics
{% if is_incremental() %}
WHERE sale_date > (SELECT max_sale_date FROM cte_max_values)
   OR last_updated_utc > (SELECT max_last_updated_utc FROM cte_max_values)
{% endif %}

