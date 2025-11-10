WITH source AS (

    SELECT DISTINCT shipping_service FROM {{ ref('base_sql_server_dbo__orders') }}

),

renamed AS (

    SELECT
        MD5(shipping_service) AS shipping_service_id,
        shipping_service AS name,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load
    FROM source

    UNION ALL

    SELECT
        MD5('no_shipping_service') AS shipping_service_id,
        'no_shipping_service' AS name,
        CONVERT_TIMEZONE('UTC', current_date()) AS date_load
)

SELECT * FROM renamed