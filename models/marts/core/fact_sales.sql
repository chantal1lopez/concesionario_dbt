{{ config(
    materialized='incremental',
    unique_key='sale_id',
    post_hook="DELETE FROM {{ this }} WHERE is_active = FALSE"
) }}

WITH
    cte_source_sales AS (
        -- Seleccionar todos los registros desde la fuente
        SELECT
            sale_id,                                 
            sale_date,                               
            customer_id,                             
            vehicle_id,                             
            branch_id,                               
            campaign_id,                             
            salesperson_id,                          
            promotion_id,                            
            final_price_usd,                         
            base_price_usd,                          
            profit_margin,                           
            discount_value,                          
            financing_type,
            is_active,
            last_updated_utc
        FROM {{ ref('int_sales_sum') }}
    ),
    
    cte_sales_metrics AS (
        SELECT *
        FROM cte_source_sales
    )
    
    {% if is_incremental() %}
    , cte_max_values AS (
        -- Obtener los valores máximos actuales de sale_date y last_updated_utc
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
