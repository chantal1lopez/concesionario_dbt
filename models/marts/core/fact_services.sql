WITH source AS (
    SELECT * 
    FROM {{ ref('int_services_aggregations') }}

)

-- Tabla de hechos: fact_services
SELECT
    service_id,                          
    service_date,                        
    vehicle_id,                          
    service_type_id,                     
    mechanic_id,                         
    service_cost_usd, 
    services_count_by_type,
    total_service_cost_usd_by_type,
    total_services_per_vehicle,                          
    total_service_cost_usd_per_vehicle             
FROM source         
