{{ config(
    materialized='incremental',
    unique_key='sale_id'
) }}

{% if is_incremental() %}
WITH source AS (
    -- Seleccionar registros nuevos o actualizados desde `int_sales_sum`
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
        is_active                                
    FROM {{ ref('int_sales_sum') }}
),
updated_rows AS (
    -- Filtrar registros existentes que necesitan ser actualizados
    SELECT s.*
    FROM source s
    JOIN {{ this }} t
    ON s.sale_id = t.sale_id
    WHERE (
        s.sale_date != t.sale_date OR
        s.customer_id != t.customer_id OR
        s.vehicle_id != t.vehicle_id OR
        s.branch_id != t.branch_id OR
        s.campaign_id != t.campaign_id OR
        s.salesperson_id != t.salesperson_id OR
        s.promotion_id != t.promotion_id OR
        s.final_price_usd != t.final_price_usd OR
        s.base_price_usd != t.base_price_usd OR
        s.profit_margin != t.profit_margin OR
        s.discount_value != t.discount_value OR
        s.financing_type != t.financing_type
    ) AND s.is_active = TRUE
),
new_rows AS (
    -- Seleccionar registros nuevos que no están en la tabla actual
    SELECT s.*
    FROM source s
    LEFT JOIN {{ this }} t
    ON s.sale_id = t.sale_id
    WHERE t.sale_id IS NULL AND s.is_active = TRUE
),
inactive_rows AS (
    -- Identificar registros inactivos (is_active = FALSE)
    SELECT t.sale_id
    FROM {{ this }} t
    LEFT JOIN source s
    ON t.sale_id = s.sale_id
    WHERE s.sale_id IS NULL OR s.is_active = FALSE
)

-- Combinar nuevos y actualizados registros
SELECT * FROM updated_rows
UNION ALL
SELECT * FROM new_rows
{% endif %}
-- Primera ejecución: crear la tabla con todos los registros iniciales
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
    is_active                           
FROM {{ ref('int_sales_sum') }}
WHERE is_active = TRUE


