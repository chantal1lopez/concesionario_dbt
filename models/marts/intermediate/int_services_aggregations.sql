{{ config(
    materialized='incremental', 
    unique_key=['service_id', 'service_type_id']
) }}

WITH cte_base_services AS (
    -- Base de servicios con las uniones necesarias
    SELECT
        sv.service_id,
        sv.service_date,
        sv.vehicle_id,
        sv.service_type_id,
        sv.cost_usd AS service_cost_usd,
        sv.mechanic_id,
        v.model AS vehicle_model,
        v.brand_name AS vehicle_brand,
        v.price_usd AS vehicle_price_usd,
        st.service_type_name,
        s.customer_id,
        sv.last_updated_utc,
        sv.is_active
    FROM  {{ ref('stg_concesionario__services') }} sv
    LEFT JOIN  {{ ref('stg_concesionario__vehicles') }} v 
        ON sv.vehicle_id = v.vehicle_id
    LEFT JOIN  {{ ref('stg_concesionario__service_types') }} st 
        ON sv.service_type_id = st.service_type_id
    LEFT JOIN  {{ ref('stg_concesionario__sales') }} s 
        ON sv.service_id = s.sale_id  -- Corrección aquí
),

cte_vehicle_metrics AS (
    -- Métricas agregadas a nivel de vehículo
    SELECT
        vehicle_id,
        SUM(service_cost_usd) AS total_service_cost_usd_per_vehicle,
        COUNT(service_id) AS total_services_per_vehicle
    FROM cte_base_services
    GROUP BY vehicle_id
),

cte_service_type_metrics AS (
    -- Métricas agregadas a nivel de tipo de servicio
    SELECT
        service_type_id,
        COUNT(service_id) AS services_count_by_type,
        SUM(service_cost_usd) AS total_service_cost_usd_by_type
    FROM cte_base_services
    GROUP BY service_type_id
),

cte_service_final AS (
    -- Consolidar las métricas a nivel de servicio
    SELECT DISTINCT
        bs.service_id,
        bs.service_date,
        bs.vehicle_id,
        bs.vehicle_model,
        bs.vehicle_brand,
        bs.vehicle_price_usd,
        bs.service_type_id,
        bs.service_type_name,
        bs.service_cost_usd,
        bs.mechanic_id,
        bs.customer_id, 
        bs.last_updated_utc,
        bs.is_active, 
        
        vm.total_service_cost_usd_per_vehicle,
        vm.total_services_per_vehicle,
        stm.services_count_by_type,
        stm.total_service_cost_usd_by_type 
    FROM cte_base_services bs
    LEFT JOIN cte_vehicle_metrics vm ON bs.vehicle_id = vm.vehicle_id
    LEFT JOIN cte_service_type_metrics stm ON bs.service_type_id = stm.service_type_id
)

{% if is_incremental() %}
, cte_max_values AS (
    -- Calcula los valores máximos de `service_date` y `last_updated_utc` existentes en la tabla incremental
    SELECT
        MAX(service_date) AS max_service_date,
        MAX(last_updated_utc) AS max_last_updated_utc
    FROM {{ this }}
)
{% endif %}

-- Selección final
SELECT * 
FROM cte_service_final
{% if is_incremental() %}
WHERE service_date > (SELECT max_service_date FROM cte_max_values)
   OR last_updated_utc > (SELECT max_last_updated_utc FROM cte_max_values)
{% endif %}
