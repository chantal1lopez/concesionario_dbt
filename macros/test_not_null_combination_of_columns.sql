{% test not_null_combination_of_columns(model, combination_of_columns) %}
SELECT *
FROM {{ model }}
WHERE (
    {% for col in combination_of_columns %}
        {{ col }} IS NULL {% if not loop.last %} OR {% endif %}
    {% endfor %}
)
{% endtest %}
