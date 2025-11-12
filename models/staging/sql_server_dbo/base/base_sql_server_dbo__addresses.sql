
with
    src_addresses as (select * from {{ source("sql_server_dbo", "addresses") }}),

    renamed_casted as (
        select
            address_id,
            zipcode,
            country,
            state,
            address,
            _fivetran_synced as date_load
        from src_addresses
    )

select *
from renamed_casted
