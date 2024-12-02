WITH service_data AS (
    SELECT
        srv.service_id,
        srv.service_date,
        srv.service_cost_usd,
        veh.vehicle_id,
        sal.branch_id,
        srv.is_active
    FROM {{ ref('fact_services') }} srv
    LEFT JOIN {{ ref('dim_vehicle') }} veh
        ON srv.vehicle_id = veh.vehicle_id
    LEFT JOIN {{ ref('fact_sales') }} sal
        ON veh.vehicle_id = sal.vehicle_id
    WHERE srv.is_active = TRUE
),

efficiency_metrics AS (
    SELECT
        branch_id,
        DATE_TRUNC('MONTH', CAST(service_date AS DATE)) AS service_month,
        COUNT(service_id) AS total_services,
        SUM(service_cost_usd) AS total_service_cost,
        AVG(service_cost_usd) AS avg_service_cost,
        MAX(service_cost_usd) AS max_service_cost,
        MIN(service_cost_usd) AS min_service_cost
    FROM service_data
    GROUP BY
        branch_id,
        DATE_TRUNC('MONTH', CAST(service_date AS DATE)) 

)

SELECT * FROM efficiency_metrics
