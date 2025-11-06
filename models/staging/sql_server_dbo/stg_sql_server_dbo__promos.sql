{{
    config(
        materialized='view'
    )
}}

WITH src_promos AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'promos') }}
),

renamed_casted AS (
    SELECT
        SHA2(TO_VARCHAR(promo_id), 256) AS promo_id,
        promo_id AS promo_name,
        discount,
        status,
        _fivetran_synced AS date_load
    FROM src_promos
)

SELECT * FROM renamed_casted;
