{{ config({ "materialized":'table',
 "transient":true,
 "alias":'walmart_stores_dim',
 "pre_hook": macros_copy_csv('STORES'),
 "schema": 'SILVER'
})}}

WITH transform_stores AS(
SELECT
    STORE AS STORE
    , TYPE AS STORE_TYPE
    , SIZE AS STORE_SIZE
    , INSERT_DTS AS INSERT_DTS
    , UPDATE_DTS AS UPDATE_DTS
    , SOURCE_FILE_NAME AS SOURCE_FILE_NAME
    , SOURCE_FILE_ROW_NUMBER AS SOURCE_FILE_ROW_NUMBER
FROM {{source('source3','STORES')}}
)

SELECT *
FROM transform_stores