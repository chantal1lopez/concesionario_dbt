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
        st.service_type_name
    FROM  {{ ref('stg_concesionario__services') }} sv
    LEFT JOIN  {{ ref('stg_concesionario__vehicles') }} v ON sv.vehicle_id = v.vehicle_id
    LEFT JOIN  {{ ref('stg_concesionario__service_types') }} st ON sv.service_type_id = st.service_type_id
),

cte_vehicle_metrics AS (
    -- Métricas agregadas a nivel de vehículo
    SELECT
        vehicle_id,
        SUM(service_cost_usd) AS total_service_cost_usd_per_vehicle,
        COUNT(service_id) AS total_services_per_vehicle,
        AVG(service_cost_usd) AS average_service_cost_usd_per_vehicle
    FROM cte_base_services
    GROUP BY vehicle_id
),

cte_mechanic_metrics AS (
    -- Métricas agregadas a nivel de mecánico
    SELECT
        mechanic_id,
        SUM(service_cost_usd) AS total_service_cost_usd_per_mechanic,
        COUNT(service_id) AS services_count_per_mechanic
    FROM cte_base_services
    GROUP BY mechanic_id
),

cte_service_type_metrics AS (
    -- Métricas agregadas a nivel de tipo de servicio
    SELECT
        service_type_id,
        COUNT(service_id) AS services_count_by_type
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
        
        vm.total_service_cost_usd_per_vehicle,
        vm.total_services_per_vehicle,
        vm.average_service_cost_usd_per_vehicle,
        mm.total_service_cost_usd_per_mechanic,
        mm.services_count_per_mechanic,
        stm.services_count_by_type
    FROM cte_base_services bs
    LEFT JOIN cte_vehicle_metrics vm ON bs.vehicle_id = vm.vehicle_id
    LEFT JOIN cte_mechanic_metrics mm ON bs.mechanic_id = mm.mechanic_id
    LEFT JOIN cte_service_type_metrics stm ON bs.service_type_id = stm.service_type_id
)

-- Selección final
SELECT * 
FROM cte_service_final
