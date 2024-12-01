{% test unique_combination_of_columns(model, combination_of_columns) %}
SELECT
    {{ ", ".join(combination_of_columns) }},
    COUNT(*) AS duplicate_count
FROM {{ model }}
GROUP BY {{ ", ".join(combination_of_columns) }}
HAVING COUNT(*) > 1
{% endtest %}
