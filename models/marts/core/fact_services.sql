{{ config(
    materialized='incremental',
    unique_key=['service_id', 'service_type_id']
) }}

{% if is_incremental() %}
WITH source AS (
    -- Seleccionar registros nuevos o actualizados desde `int_services_aggregations`
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
        is_active
    FROM {{ ref('int_services_aggregations') }}
    WHERE is_active = TRUE
),
updated_rows AS (
    -- Filtrar registros existentes que necesitan ser actualizados
    SELECT s.*
    FROM source s
    JOIN {{ this }} t
    ON s.service_id = t.service_id AND s.service_type_id = t.service_type_id
    WHERE (
        s.service_date != t.service_date OR
        s.vehicle_id != t.vehicle_id OR
        s.mechanic_id != t.mechanic_id OR
        s.customer_id != t.customer_id OR
        s.service_cost_usd != t.service_cost_usd OR
        s.services_count_by_type != t.services_count_by_type OR
        s.total_service_cost_usd_by_type != t.total_service_cost_usd_by_type OR
        s.total_services_per_vehicle != t.total_services_per_vehicle OR
        s.total_service_cost_usd_per_vehicle != t.total_service_cost_usd_per_vehicle
    )
),
new_rows AS (
    -- Seleccionar registros nuevos que no están en la tabla actual
    SELECT
        s.service_id,                           
        s.service_date,                         
        s.vehicle_id,                          
        s.service_type_id,                     
        s.mechanic_id,  
        s.customer_id,                        
        s.service_cost_usd, 
        s.services_count_by_type,
        s.total_service_cost_usd_by_type,
        s.total_services_per_vehicle,                          
        s.total_service_cost_usd_per_vehicle,
        s.is_active
    FROM source s
    LEFT JOIN {{ this }} t
    ON s.service_id = t.service_id AND s.service_type_id = t.service_type_id
    WHERE t.service_id IS NULL
)

-- Combinar nuevos y actualizados registros
SELECT * FROM updated_rows
UNION ALL
SELECT * FROM new_rows

{% endif %}
-- Primera ejecución: crear la tabla con todos los registros iniciales
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
    is_active
FROM {{ ref('int_services_aggregations') }}
WHERE is_active = TRUE
