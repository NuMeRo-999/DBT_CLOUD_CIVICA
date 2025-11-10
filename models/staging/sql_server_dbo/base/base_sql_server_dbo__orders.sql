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
        COALESCE(NULLIF(shipping_service, ''), 'no_shipping_service') AS shipping_service_id,
        shipping_cost,
        address_id,
        created_at,
        MD5(LOWER(REPLACE(REPLACE(promo_id, ' ', '_'), '-', '_'))) AS promo_id,
        estimated_delivery_at,
        order_cost,
        user_id,
        order_total,
        delivered_at,
        tracking_id,
        status,
        _fivetran_synced
    FROM source

)

SELECT * FROM renamed