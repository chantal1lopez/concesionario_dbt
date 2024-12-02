WITH service_type_analysis AS (
    SELECT
        srv.service_type_id,
        st.service_type_name,
        COUNT(srv.service_id) AS total_services,
        SUM(srv.service_cost_usd) AS total_service_cost,
        AVG(srv.service_cost_usd) AS avg_service_cost
    FROM {{ ref('fact_services') }} srv
    LEFT JOIN {{ ref('dim_service_types') }} st
        ON srv.service_type_id = st.service_type_id
    WHERE srv.is_active = TRUE
    GROUP BY
        srv.service_type_id, st.service_type_name
)
SELECT * FROM service_type_analysis
