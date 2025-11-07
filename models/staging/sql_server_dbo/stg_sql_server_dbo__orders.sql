{{ config(
    materialized='incremental',
    unique_key = '_row'
    ) 
    }}

WITH source AS (

    SELECT * FROM {{ source('sql_server_dbo', 'orders') }}

),

{% if is_incremental() %}
    WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }} )
{% endif %}

renamed AS (

    SELECT
        order_id,
        shipping_service, -- normalizar
        shipping_cost AS dollars_shipping_cost,
        address_id,
        created_at,
        MD5(LOWER(REPLACE(REPLACE(promo_id, ' ', '_'), '-', '_'))) AS promo_id,
        estimated_delivery_at,
        order_cost AS dollars_order_cost,
        user_id,
        order_total AS dollars_order_total,
        CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at,
        tracking_id,
        status,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load
    FROM source

)

SELECT * FROM renamed