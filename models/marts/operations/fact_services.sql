{{ config(
    materialized='incremental',
    unique_key=['service_id', 'service_type_id'],
    post_hook="DELETE FROM {{ this }} WHERE is_active = FALSE"
) }}

WITH
    cte_source_services AS (
        -- Seleccionar todos los registros desde la fuente
        SELECT
            service_id,                           
            service_date,                         
            vehicle_id,                          
            service_type_id,                     
            mechanic_id,  
            customer_id,                        
            service_cost_usd, 
            services_count_by_type,
            total_service_cost_usd_by_type,
            total_services_per_vehicle,                          
            total_service_cost_usd_per_vehicle,
            is_active,
            last_updated_utc
        FROM {{ ref('int_services_aggregations') }}
    ),
    
    cte_services_metrics AS (
        SELECT *
        FROM cte_source_services
    )
    
    {% if is_incremental() %}
    , cte_max_values AS (
        -- Obtener los valores máximos actuales de service_date y last_updated_utc
        SELECT
            MAX(service_date) AS max_service_date,
            MAX(last_updated_utc) AS max_last_updated_utc
        FROM {{ this }}
    )
    {% endif %}

SELECT *
FROM cte_services_metrics
{% if is_incremental() %}
-- Incluir solo registros nuevos o actualizados
WHERE service_date > (SELECT max_service_date FROM cte_max_values)
   OR last_updated_utc > (SELECT max_last_updated_utc FROM cte_max_values)
{% endif %}
